//
//  PracticaGtecApp.swift
//  PracticaGtec
//
//  Created by Jesus Grimaldo on 06/03/26.
//

import SwiftUI

@main
struct PracticaGtecApp: App {
    var body: some Scene {
        WindowGroup {
            PokemonListView(
                viewModel: AppContainer.makePokemonListViewModel()
            )
            .preferredColorScheme(.light)
        }
    }
}
