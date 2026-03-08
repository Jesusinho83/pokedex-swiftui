//
//  PokemonDetailView.swift
//  PracticaGtec
//
//  Created by Jesus Grimaldo on 06/03/26.
//

import SwiftUI

struct PokemonDetailView: View {
    
    let pokemonURL: String
    
    @StateObject private var viewModel: PokemonDetailViewModel
    
    init(
        pokemonURL: String,
        viewModel: PokemonDetailViewModel
    ) {
        self.pokemonURL = pokemonURL
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    private var backgroundColor: Color {
        guard let pokemon = viewModel.pokemon else {
            return Color(.systemGray6)
        }
        
        let type = pokemon.types.first?.type.name ?? "normal"
        return PokemonTypeColor.color(for: type)
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    backgroundColor.opacity(0.35),
                    backgroundColor.opacity(0.05)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            content
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadPokemonDetail(from: pokemonURL)
        }
    }
    
    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            VStack(spacing: 16) {
                ProgressView()
                    .scaleEffect(1.2)
                
                Text("Cargando detalle...")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        } else if let errorMessage = viewModel.errorMessage {
            VStack(spacing: 16) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.system(size: 40))
                    .foregroundStyle(.gray)
                
                Text("No se pudo cargar el detalle")
                    .font(.headline)
                
                Text(errorMessage)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding()
        } else if let pokemon = viewModel.pokemon {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    headerView(pokemon)
                    infoCard(pokemon)
                    statsCard(pokemon)
                }
                .padding()
            }
        }
    }
    
    private func headerView(_ pokemon: PokemonDetailModel) -> some View {
        let mainType = pokemon.types.first?.type.name ?? "normal"
        let backgroundColor = PokemonTypeColor.color(for: mainType)
        
        return VStack(spacing: 14) {
            AsyncImage(url: URL(string: pokemon.sprites.other.officialArtwork.frontDefault ?? "")) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(height: 220)
                    .shadow(radius: 10)
                    .scaleEffect(1.05)
            } placeholder: {
                ProgressView()
            }
            
            Text("#\(String(format: "%03d", pokemon.id))")
                .foregroundStyle(.secondary)
            
            Text(pokemon.name.capitalized)
                .font(.largeTitle.bold())
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(backgroundColor.opacity(0.25))
        )
    }
    
    private func infoCard(_ pokemon: PokemonDetailModel) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Información")
                .font(.title3.weight(.semibold))
            
            HStack {
                infoItem(title: "Altura", value: "\(pokemon.height)")
                Spacer()
                infoItem(title: "Peso", value: "\(pokemon.weight)")
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
        )
    }
    
    private func infoItem(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text(value)
                .font(.headline)
        }
    }
    
    private func statsCard(_ pokemon: PokemonDetailModel) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Stats")
                .font(.title3.weight(.semibold))
            
            ForEach(pokemon.stats) { stat in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(formattedStatName(stat.stat.name))
                            .font(.subheadline.weight(.medium))
                        
                        Spacer()
                        
                        Text("\(stat.baseStat)")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.secondary)
                    }
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray.opacity(0.15))
                                .frame(height: 10)
                            
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.black)
                                .frame(
                                    width: max(
                                        12,
                                        min(
                                            CGFloat(stat.baseStat) / 150 * geometry.size.width,
                                            geometry.size.width
                                        )
                                    ),
                                    height: 10
                                )
                        }
                    }
                    .frame(height: 10)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
        )
    }
    
    private func formattedStatName(_ name: String) -> String {
        switch name {
        case "hp": return "HP"
        case "attack": return "Attack"
        case "defense": return "Defense"
        case "special-attack": return "Special Attack"
        case "special-defense": return "Special Defense"
        case "speed": return "Speed"
        default: return name.capitalized
        }
    }
}
