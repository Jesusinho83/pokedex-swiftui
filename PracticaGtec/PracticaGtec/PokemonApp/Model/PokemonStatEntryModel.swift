//
//  PokemonStatEntryModel.swift
//  PracticaGtec
//
//  Created by Jesus Grimaldo on 06/03/26.
//

import Foundation

struct  PokemonStatEntryModel: Decodable, Identifiable {
    let baseStat: Int
    let stat: PokemonStat
    
    var id: String { stat.name }
    
    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case stat
    }
}

struct PokemonStat: Decodable {
    let name: String
}
