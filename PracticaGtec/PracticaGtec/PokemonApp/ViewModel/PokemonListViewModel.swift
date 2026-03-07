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
    @Published var isLoading = false
    @Published var isLoadingMore = false
    @Published var errorMessage: String?
    
    private let service: PokemonServiceProtocol
    
    private var offset = 0
    private let limit = 20
    private var canLoadMore = true
    
    init(service: PokemonServiceProtocol = PokemonService()) {
        self.service = service
    }
    
    func loadPokemons() async {
        guard pokemons.isEmpty else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await service.fetchPokemonListResponse(limit: limit, offset: offset)
            pokemons = response.results
            canLoadMore = response.next != nil
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func loadMore() async {
        guard !isLoadingMore, !isLoading, canLoadMore else { return }

        isLoadingMore = true
        errorMessage = nil

        do {
            let nextOffset = offset + limit
            let response = try await service.fetchPokemonListResponse(limit: limit, offset: nextOffset)

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
        await loadPokemons()
    }
}
