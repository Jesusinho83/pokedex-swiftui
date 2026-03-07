//
//  PokemonSpriteModel.swift
//  PracticaGtec
//
//  Created by Jesus Grimaldo on 06/03/26.
//

import Foundation

struct PokemonSpriteModel: Decodable {
    let other: PokemonOtherSpritesModel
}

struct PokemonOtherSpritesModel: Decodable {
    let officialArtwork: PokemonOfficialArtworkModel
    
    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}

struct PokemonOfficialArtworkModel: Decodable {
    let frontDefault: String?
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}
