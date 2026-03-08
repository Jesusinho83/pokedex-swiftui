//
//  PokemonRepositoryImpl.swift
//  PracticaGtec
//
//  Created by Jesus Grimaldo on 07/03/26.
//

import Foundation

final class PokemonRepositoryImpl: PokemonRepository {
    
    private let service: PokemonServiceProtocol
    
    init(service: PokemonServiceProtocol = PokemonService()) {
        self.service = service
    }
    
    func fetchPokemonListResponse(
        limit: Int,
        offset: Int
    ) async throws -> PokemoListResponseModel {
        try await service.fetchPokemonListResponse(
            limit: limit,
            offset: offset
        )
    }
    
    func fetchPokemonDetail(
        urlString: String
    ) async throws -> PokemonDetailModel {
        try await service.fetchPokemonDetail(
            urlString: urlString
        )
    }
}
