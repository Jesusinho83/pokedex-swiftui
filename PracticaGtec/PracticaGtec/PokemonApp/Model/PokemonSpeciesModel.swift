//
//  PokemonSpeciesModel.swift
//  PracticaGtec
//
//  Created by Jesus Grimaldo on 08/03/26.
//
import Foundation


struct PokemonSpeciesModel: Decodable {
    let flavorTextEntries: [PokemonFlavorTextEntryModel]
    let evolutionChain: PokemonEvolutionChainReferenceModel

    enum CodingKeys: String, CodingKey {
        case flavorTextEntries = "flavor_text_entries"
        case evolutionChain = "evolution_chain"
    }
}

struct PokemonFlavorTextEntryModel: Decodable, Identifiable {
    let flavorText: String
    let language: PokemonNamedResourceModel

    var id: String {
        "\(language.name)-\(flavorText)"
    }

    enum CodingKeys: String, CodingKey {
        case flavorText = "flavor_text"
        case language
    }
}

struct PokemonEvolutionChainReferenceModel: Decodable {
    let url: String
}

struct PokemonSpeciesReferenceModel: Decodable {
    let name: String
    let url: String
}

struct PokemonNamedResourceModel: Decodable {
    let name: String
    let url: String
}

import Foundation

struct EvolutionChainModel: Decodable {
    let chain: EvolutionNodeModel
}

struct EvolutionNodeModel: Decodable {
    let species: PokemonSpeciesReferenceModel
    let evolvesTo: [EvolutionNodeModel]

    enum CodingKeys: String, CodingKey {
        case species
        case evolvesTo = "evolves_to"
    }
}
