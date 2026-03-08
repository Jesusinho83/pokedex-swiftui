//
//  Endpoint.swift
//  PracticaGtec
//
//  Created by Jesus Grimaldo on 07/03/26.
//

import Foundation

enum Endpoint {

    case pokemonList(limit: Int, offset: Int)
    case pokemonDetail(urlString: String)
    case pokemonByType(type: String)
    case pokemonSpecies(urlString: String)
    case evolutionChain(urlString: String)


    var url: URL? {
        switch self {

        case .pokemonList(let limit, let offset):
            return URL(string:
                "https://pokeapi.co/api/v2/pokemon?limit=\(limit)&offset=\(offset)"
            )

        case .pokemonDetail(let urlString):
            return URL(string: urlString)
            
        case .pokemonByType(let type):
            return URL(string: "https://pokeapi.co/api/v2/type/\(type.lowercased())")
            
        case .pokemonSpecies(let urlString):
            return URL(string: urlString)
                   
        case .evolutionChain(let urlString):
            return URL(string: urlString)
        }
    }
}
