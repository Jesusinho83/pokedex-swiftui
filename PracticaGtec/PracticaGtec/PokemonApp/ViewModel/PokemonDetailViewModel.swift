//
//  PokemonDetailViewModel.swift
//  PracticaGtec
//
//  Created by Jesus Grimaldo on 06/03/26.
//

import Foundation
import Combine

@MainActor
final class PokemonDetailViewModel: ObservableObject {
    @Published var pokemon: PokemonDetailModel?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let service: PokemonServiceProtocol
    
    init(service: PokemonServiceProtocol = PokemonService()) {
        self.service = service
    }
    
    func loadPokemonDetail(from urlString: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            pokemon = try await service.fetchPokemonDetail(urlString: urlString)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
