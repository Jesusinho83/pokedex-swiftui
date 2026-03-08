//
//  PokemonDetailViewModel.swift
//  PracticaGtec
//
//  Created by Jesus Grimaldo on 06/03/26.
//

import Foundation
import Combine

struct PokemonEvolutionDisplayModel: Identifiable {
    let id: Int
    let name: String
    let imageURL: URL?
}

@MainActor
final class PokemonDetailViewModel: ObservableObject {
    
    @Published var pokemon: PokemonDetailModel?
    @Published var species: PokemonSpeciesModel?
    @Published var evolutionChain: EvolutionChainModel?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedEvolutionCard: EvolutionCardDetailModel?
    
    private let repository: PokemonRepository
    
    init(repository: PokemonRepository) {
        self.repository = repository
    }
    
    func loadPokemonDetail(from urlString: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let pokemon = try await repository.fetchPokemonDetail(urlString: urlString)
            self.pokemon = pokemon
            
            let species = try await repository.fetchPokemonSpecies(urlString: pokemon.species.url)
            self.species = species
            
            let chain = try await repository.fetchEvolutionChain(urlString: species.evolutionChain.url)
            self.evolutionChain = chain
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    var flavorText: String? {
        guard let species else { return nil }
        
        let preferredEntry =
            species.flavorTextEntries.first(where: { $0.language.name == "es" }) ??
            species.flavorTextEntries.first(where: { $0.language.name == "en" })
        
        return preferredEntry?.flavorText
            .replacingOccurrences(of: "\n", with: " ")
            .replacingOccurrences(of: "\u{000C}", with: " ")
    }
    
    var evolutionStages: [PokemonEvolutionDisplayModel] {
        guard let evolutionChain else { return [] }
        
        let nodes = flattenEvolutionChain(node: evolutionChain.chain)
        
        return nodes.compactMap { species in
            guard let id = extractID(from: species.url) else { return nil }
            
            return PokemonEvolutionDisplayModel(
                id: id,
                name: species.name.capitalized,
                imageURL: URL(
                    string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png"
                )
            )
        }
    }
    
    private func flattenEvolutionChain(node: EvolutionNodeModel) -> [PokemonSpeciesReferenceModel] {
        var result: [PokemonSpeciesReferenceModel] = [node.species]
        
        for child in node.evolvesTo {
            result.append(contentsOf: flattenEvolutionChain(node: child))
        }
        
        return result
    }
    
    private func extractID(from urlString: String) -> Int? {
        urlString
            .split(separator: "/")
            .compactMap { Int($0) }
            .last
    }
    
    func loadEvolutionPreview(for evolution: PokemonEvolutionDisplayModel) async {
        
        do {
            let detail = try await repository.fetchPokemonDetail(
                urlString: "https://pokeapi.co/api/v2/pokemon/\(evolution.id)"
            )
            
            let species = try await repository.fetchPokemonSpecies(
                urlString: detail.species.url
            )
            
            let flavorText =
                species.flavorTextEntries.first(where: { $0.language.name == "es" })?.flavorText
                ?? species.flavorTextEntries.first(where: { $0.language.name == "en" })?.flavorText
            
            let cleanedFlavorText = flavorText?
                .replacingOccurrences(of: "\n", with: " ")
                .replacingOccurrences(of: "\u{000C}", with: " ")
            
            let mainType = detail.types.first?.type.name ?? "normal"
            
            let card = EvolutionCardDetailModel(
                id: detail.id,
                name: detail.name.capitalized,
                imageURL: URL(string: detail.sprites.other.officialArtwork.frontDefault ?? ""),
                type: mainType,
                flavorText: cleanedFlavorText,
                height: detail.height,
                weight: detail.weight,
                baseExperience: detail.baseExperience,
                abilities: detail.abilities.map { $0.ability.name.capitalized }
            )
            
            await MainActor.run {
                    self.selectedEvolutionCard = card
            }
            
        } catch {
            print("Error loading evolution card detail:", error.localizedDescription)
        }
    }
}
