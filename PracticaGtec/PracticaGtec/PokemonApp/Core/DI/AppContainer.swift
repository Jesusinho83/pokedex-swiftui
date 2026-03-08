//
//  AppContainer.swift
//  PracticaGtec
//
//  Created by Jesus Grimaldo on 07/03/26.
//

import SwiftUI

enum AppContainer {
    
    static func makePokemonRepository() -> PokemonRepository {
        let apiService = APIService()
        let pokemonService = PokemonService(apiService: apiService)
        let repository = PokemonRepositoryImpl(service: pokemonService)
        return repository
    }
    
    static func makePokemonListViewModel() -> PokemonListViewModel {
        let repository = makePokemonRepository()
        return PokemonListViewModel(repository: repository)
    }
    
    static func makePokemonDetailViewModel() -> PokemonDetailViewModel {
        let repository = makePokemonRepository()
        return PokemonDetailViewModel(repository: repository)
    }
}
