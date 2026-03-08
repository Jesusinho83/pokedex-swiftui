//
//  PokemonRowView.swift
//  PracticaGtec
//
//  Created by Jesus Grimaldo on 06/03/26.
//

import SwiftUI

struct PokemonRowView: View {
    let pokemon: PokemonListItemModel
    
    @State private var mainType: String?
    
    private let repository: PokemonRepository = AppContainer.makePokemonRepository()
    
    private var imageURL: URL? {
        URL(
            string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(pokemon.id).png"
        )
    }
    
    private var cardColor: Color {
        guard let mainType else {
            return Color.white.opacity(0.45)
        }
        return PokemonTypeColor.color(for: mainType).opacity(0.72)
    }
    
    private var textColor: Color {
        guard let mainType else { return .white }
        return mainType == "electric" ? .black : .white
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(cardColor)
            
            Circle()
                .fill(Color.white.opacity(0.14))
                .frame(width: 90, height: 90)
                .offset(x: 82, y: -18)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("#\(String(format: "%03d", pokemon.id))")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(textColor.opacity(0.85))
                
                Text(pokemon.capitalizedName)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(textColor)
                    .lineLimit(1)
                
                Spacer()
                
                HStack(alignment: .bottom) {
                    if let mainType {
                        Text(mainType.capitalized)
                            .font(.caption.weight(.semibold))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.white.opacity(0.20))
                            .foregroundStyle(textColor)
                            .clipShape(Capsule())
                    } else {
                        Text("Loading...")
                            .font(.caption.weight(.semibold))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.white.opacity(0.20))
                            .foregroundStyle(textColor.opacity(0.85))
                            .clipShape(Capsule())
                    }
                    
                    Spacer()
                    
                    pokemonImage
                }
            }
            .padding(14)
        }
        .frame(height: 170)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 4)
        .task {
            await loadMainTypeIfNeeded()
        }
    }
    
    @ViewBuilder
    private var pokemonImage: some View {
        AsyncImage(url: imageURL) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(width: 62, height: 62)
                
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 90, height: 90)
                    .shadow(color: .black.opacity(0.10), radius: 5, x: 0, y: 3)
                
            case .failure:
                Image(systemName: "photo")
                    .font(.system(size: 24))
                    .foregroundStyle(textColor.opacity(0.7))
                    .frame(width: 62, height: 62)
                
            @unknown default:
                EmptyView()
            }
        }
    }
    
    private func loadMainTypeIfNeeded() async {
        guard mainType == nil else { return }
        
        do {
            let detail = try await repository.fetchPokemonDetail(urlString: pokemon.url)
            mainType = detail.types.first?.type.name
        } catch {
            mainType = nil
        }
    }
}
