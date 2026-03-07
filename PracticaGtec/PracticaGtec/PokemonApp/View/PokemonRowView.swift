//
//  PokemonRowView.swift
//  PracticaGtec
//
//  Created by Jesus Grimaldo on 06/03/26.
//

import SwiftUI

struct PokemonRowView: View {
    let pokemon: PokemonListItemModel
    
    var imageURL: URL? {
        URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(pokemon.id).png")
    }
    
    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 70, height: 70)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)
                case .failure:
                    Image(systemName: "photo")
                        .font(.system(size: 28))
                        .foregroundStyle(.gray.opacity(0.6))
                        .frame(width: 70, height: 70)
                @unknown default:
                    EmptyView()
                }
            }
            .padding(8)
            .background(Color.white.opacity(0.9))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            
            VStack(alignment: .leading, spacing: 6) {
                Text("#\(String(format: "%03d", pokemon.id))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text(pokemon.capitalizedName)
                    .font(.headline)
                    .foregroundStyle(.primary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.gray)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 4)
        )
        .padding(.horizontal)
    }
}

