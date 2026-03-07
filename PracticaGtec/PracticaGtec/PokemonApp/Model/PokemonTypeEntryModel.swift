//
//  PokemonTypeEntryModel.swift
//  PracticaGtec
//
//  Created by Jesus Grimaldo on 06/03/26.
//

import Foundation

struct PokemonTypeEntryModel: Decodable, Identifiable {
    let type: PokemonTypeModel
    
    var id: String { type.name }
}

struct PokemonTypeModel: Decodable {
    let name: String
    let url: String
}
