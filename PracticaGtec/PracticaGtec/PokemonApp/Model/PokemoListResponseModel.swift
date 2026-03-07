//
//  PokemoListResponseModel.swift
//  PracticaGtec
//
//  Created by Jesus Grimaldo on 06/03/26.
//

import Foundation

struct PokemoListResponseModel: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [PokemonListItemModel]
}
