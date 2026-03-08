//
//  PokemonTypeResponseModel.swift
//  PracticaGtec
//
//  Created by Jesus Grimaldo on 07/03/26.
//

import Foundation

struct PokemonTypeResponseModel: Decodable {
    let pokemon: [PokemonTypeEntry]
}

struct PokemonTypeEntry: Decodable {
    let pokemon: PokemonTypePokemonItem
}

struct PokemonTypePokemonItem: Decodable {
    let name: String
    let url: String
}
