//
//  PokemonTypeColor.swift
//  PracticaGtec
//
//  Created by Jesus Grimaldo on 07/03/26.
//

import SwiftUI

struct PokemonTypeColor {

    static func color(for type: String) -> Color {
        switch type.lowercased() {

        case "fire":
            return Color.red

        case "water":
            return Color.blue

        case "grass":
            return Color.green

        case "electric":
            return Color.yellow

        case "poison":
            return Color.purple

        case "bug":
            return Color.green.opacity(0.7)

        case "normal":
            return Color.gray

        case "ground":
            return Color.brown

        case "fairy":
            return Color.pink

        case "psychic":
            return Color.pink.opacity(0.7)

        case "rock":
            return Color.gray.opacity(0.6)

        case "ice":
            return Color.cyan

        case "dragon":
            return Color.indigo

        case "dark":
            return Color.black

        case "fighting":
            return Color.orange

        case "ghost":
            return Color.purple.opacity(0.7)

        default:
            return Color.gray
        }
    }
}
