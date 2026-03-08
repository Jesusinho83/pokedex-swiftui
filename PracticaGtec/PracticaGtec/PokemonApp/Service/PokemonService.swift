//
//  PokemonService.swift
//  PracticaGtec
//
//  Created by Jesus Grimaldo on 06/03/26.
//

import Foundation

protocol PokemonServiceProtocol {
    
    func fetchPokemonListResponse(limit: Int,offset: Int) async throws -> PokemoListResponseModel
    
    func fetchPokemonDetail(urlString: String) async throws -> PokemonDetailModel
    func fetchPokemonsByType(type: String) async throws -> PokemonTypeResponseModel
    
    func fetchPokemonSpecies(urlString: String) async throws -> PokemonSpeciesModel
    func fetchEvolutionChain(urlString: String) async throws -> EvolutionChainModel
}

final class PokemonService: PokemonServiceProtocol {
    
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    func fetchPokemonListResponse(limit: Int = 20,offset: Int = 0) async throws -> PokemoListResponseModel {
        
        let endpoint = Endpoint.pokemonList(
            limit: limit,
            offset: offset
        )
        
        let response: PokemoListResponseModel = try await apiService.fetch(
            endpoint: endpoint
        )
        
        return response
    }
    
    func fetchPokemonDetail(urlString: String) async throws -> PokemonDetailModel {
        
        let endpoint = Endpoint.pokemonDetail(
            urlString: urlString
        )
        
        let detail: PokemonDetailModel = try await apiService.fetch(
            endpoint: endpoint
        )
        
        return detail
    }
    
    func fetchPokemonsByType(type: String) async throws -> PokemonTypeResponseModel {
           let endpoint = Endpoint.pokemonByType(type: type)
           let response: PokemonTypeResponseModel = try await apiService.fetch(endpoint: endpoint)
           return response
       }
    
    func fetchPokemonSpecies(urlString: String) async throws -> PokemonSpeciesModel {
        let endpoint = Endpoint.pokemonSpecies(urlString: urlString)
        let response: PokemonSpeciesModel = try await apiService.fetch(endpoint: endpoint)
        return response
    }
    
    func fetchEvolutionChain(urlString: String) async throws -> EvolutionChainModel {
        let endpoint = Endpoint.evolutionChain(urlString: urlString)
        let response: EvolutionChainModel = try await apiService.fetch(endpoint: endpoint)
        return response
    }
}
