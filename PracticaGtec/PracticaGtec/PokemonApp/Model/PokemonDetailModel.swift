//
//  PokemonDetailModel.swift
//  PracticaGtec
//
//  Created by Jesus Grimaldo on 06/03/26.
//

import Foundation

struct PokemonDetailModel: Decodable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let types: [PokemonTypeEntryModel]
    let stats: [PokemonStatEntryModel]
    let sprites: PokemonSpriteModel
}
