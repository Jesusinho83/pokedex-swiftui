//
//  PokemonService.swift
//  PracticaGtec
//
//  Created by Jesus Grimaldo on 06/03/26.
//

import Foundation

protocol PokemonServiceProtocol {
    func fetchPokemonListResponse(limit: Int, offset: Int) async throws -> PokemoListResponseModel
    func fetchPokemonDetail(urlString: String) async throws -> PokemonDetailModel
}

final class PokemonService: PokemonServiceProtocol {
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    func fetchPokemonListResponse(limit: Int = 20, offset: Int = 0) async throws -> PokemoListResponseModel {
        let endpoint = "https://pokeapi.co/api/v2/pokemon?limit=\(limit)&offset=\(offset)"
        let response: PokemoListResponseModel = try await apiService.fetch(urlString: endpoint)
        return response
    }
    
    func fetchPokemonDetail(urlString: String) async throws -> PokemonDetailModel {
        let detail: PokemonDetailModel = try await apiService.fetch(urlString: urlString)
        return detail
    }
}
