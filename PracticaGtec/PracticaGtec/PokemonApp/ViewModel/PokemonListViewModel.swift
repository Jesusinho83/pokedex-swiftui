//
//  PokemonListViewModel.swift
//  PracticaGtec
//
//  Created by Jesus Grimaldo on 06/03/26.
//
import Foundation
import Combine

@MainActor
final class PokemonListViewModel: ObservableObject {
    
    @Published var pokemons: [PokemonListItemModel] = []
    @Published var allPokemonsIndex: [PokemonListItemModel] = []
    @Published var isLoading = false
    @Published var isLoadingMore = false
    @Published var errorMessage: String?
    
    @Published var searchText: String = ""
    @Published var selectedType: String = "All"
    
    let availableTypes: [String] = ["All", "Electric", "Fire", "Water", "Grass"]
    
    private let repository: PokemonRepository
    
    private var offset = 0
    private let limit = 20
    private var canLoadMore = true
    
    init(repository: PokemonRepository) {
        self.repository = repository
    }
    
    var displayedPokemons: [PokemonListItemModel] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        guard !query.isEmpty else {
            return pokemons
        }
        
        return allPokemonsIndex.filter {
            $0.name.lowercased().contains(query) ||
            String($0.id).contains(query)
        }
    }
    
    func loadPokemons() async {
        guard pokemons.isEmpty else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            async let paginatedResponse = repository.fetchPokemonListResponse(
                limit: limit,
                offset: offset
            )
            
            async let fullIndexResponse = repository.fetchPokemonListResponse(
                limit: 2000,
                offset: 0
            )
            
            let response = try await paginatedResponse
            let allResponse = try await fullIndexResponse
            
            pokemons = response.results
            allPokemonsIndex = allResponse.results.sorted { $0.id < $1.id }
            canLoadMore = response.next != nil
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func loadMore() async {
        guard selectedType == "All" else { return }
        guard searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        guard !isLoadingMore, !isLoading, canLoadMore else { return }
        
        isLoadingMore = true
        errorMessage = nil
        
        do {
            let nextOffset = offset + limit
            let response = try await repository.fetchPokemonListResponse(
                limit: limit,
                offset: nextOffset
            )
            
            offset = nextOffset
            
            let newItems = response.results.filter { newPokemon in
                !pokemons.contains(where: { $0.id == newPokemon.id })
            }
            
            pokemons.append(contentsOf: newItems)
            canLoadMore = response.next != nil
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoadingMore = false
    }
    
    func refresh() async {
        offset = 0
        canLoadMore = true
        errorMessage = nil
        pokemons = []
        
        if selectedType == "All" {
            await loadPokemons()
        } else {
            await loadPokemonsByType(selectedType)
        }
    }
    
    func selectType(_ type: String) async {
        guard selectedType != type else { return }
        
        selectedType = type
        searchText = ""
        errorMessage = nil
        
        if type == "All" {
            offset = 0
            canLoadMore = true
            pokemons = []
            await loadPokemons()
        } else {
            await loadPokemonsByType(type)
        }
    }
    
    private func loadPokemonsByType(_ type: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let results = try await repository.fetchPokemonsByType(type: type)
            pokemons = results.sorted { $0.id < $1.id }
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
