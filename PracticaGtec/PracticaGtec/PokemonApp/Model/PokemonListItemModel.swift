//
//  .swift
//  PracticaGtec
//
//  Created by Jesus Grimaldo on 06/03/26.
//

import Foundation

struct PokemonListItemModel: Identifiable, Decodable{
    let name: String
    let url: String
    
    var id: Int {
        url.split(separator: "/").compactMap { Int($0) }.last ?? 0
    }
    
    var capitalizedName: String {
        name.capitalized
    }
}
