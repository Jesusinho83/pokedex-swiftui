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
    let baseExperience: Int
    let types: [PokemonTypeEntryModel]
    let stats: [PokemonStatEntryModel]
    let sprites: PokemonSpriteModel
    let abilities: [PokemonAbilityEntryModel]
    let forms: [PokemonFormEntryModel]
    let moves: [PokemonMoveEntryModel]
    let species: PokemonSpeciesReferenceModel

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case height
        case weight
        case baseExperience = "base_experience"
        case types
        case stats
        case sprites
        case abilities
        case forms
        case moves
        case species
    }
}

struct PokemonAbilityEntryModel: Decodable, Identifiable {
    let ability: PokemonAbilityModel
    let isHidden: Bool

    var id: String { ability.name }

    enum CodingKeys: String, CodingKey {
        case ability
        case isHidden = "is_hidden"
    }
}

struct PokemonAbilityModel: Decodable {
    let name: String
    let url: String
}

struct PokemonFormEntryModel: Decodable, Identifiable {
    let name: String
    let url: String

    var id: String { name }
}

struct PokemonMoveEntryModel: Decodable, Identifiable {
    let move: PokemonMoveModel

    var id: String { move.name }
}

struct PokemonMoveModel: Decodable {
    let name: String
    let url: String
}

struct EvolutionCardDetailModel: Identifiable {
    let id: Int
    let name: String
    let imageURL: URL?
    let type: String
    let flavorText: String?
    let height: Int
    let weight: Int
    let baseExperience: Int
    let abilities: [String]
}
