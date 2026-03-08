//
//  Repositories.swift
//  PracticaGtec
//
//  Created by Jesus Grimaldo on 07/03/26.
//

import Foundation

protocol PokemonRepository {
    
    func fetchPokemonListResponse(limit: Int,offset: Int) async throws -> PokemoListResponseModel
    
    func fetchPokemonDetail(urlString: String) async throws -> PokemonDetailModel
    func fetchPokemonsByType(type: String) async throws -> [PokemonListItemModel]
    
    func fetchPokemonSpecies(urlString: String) async throws -> PokemonSpeciesModel
    func fetchEvolutionChain(urlString: String) async throws -> EvolutionChainModel
}
