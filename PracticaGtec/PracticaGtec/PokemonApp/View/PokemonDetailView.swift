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
    @State private var selectedEvolutionCard: EvolutionCardDetailModel?
    
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
        .overlay {
            if let card = viewModel.selectedEvolutionCard {
                EvolutionFloatingCard(
                    evolution: card,
                    onClose: {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                            viewModel.selectedEvolutionCard = nil
                        }
                    }
                )
                .transition(.opacity.combined(with: .scale(scale: 0.92)))
                .zIndex(10)
            }
        }
        .animation(
            .spring(response: 0.35, dampingFraction: 0.85),
            value: viewModel.selectedEvolutionCard != nil
        )
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
                    quickInfoCard(pokemon)
                    
                    if let flavorText = viewModel.flavorText {
                        flavorTextCard(flavorText)
                    }
                    
                    abilitiesCard(pokemon)
                    statsCard(pokemon)
                    movesCard(pokemon)
                    
                    if !viewModel.evolutionStages.isEmpty {
                        evolutionsCard
                    }
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
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
            
            Text(pokemon.name.capitalized)
                .font(.largeTitle.bold())
            
            HStack(spacing: 8) {
                ForEach(pokemon.types) { typeEntry in
                    let typeName = typeEntry.type.name
                    let chipColor = PokemonTypeColor.color(for: typeName)
                    
                    Text(typeName.capitalized)
                        .font(.caption.weight(.semibold))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(chipColor.opacity(0.2))
                        .foregroundStyle(typeName == "electric" ? .black : chipColor)
                        .clipShape(Capsule())
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(backgroundColor.opacity(0.25))
        )
    }
    
    private func quickInfoCard(_ pokemon: PokemonDetailModel) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Información")
                .font(.title3.weight(.semibold))
            
            HStack {
                infoItem(title: "Altura", value: "\(pokemon.height)")
                Spacer()
                infoItem(title: "Peso", value: "\(pokemon.weight)")
            }
            
            HStack {
                infoItem(title: "Base Exp", value: "\(pokemon.baseExperience)")
                Spacer()
                infoItem(title: "Forma", value: pokemon.forms.first?.name.capitalized ?? "-")
            }
        }
        .padding()
        .background(cardBackground)
    }
    
    private func flavorTextCard(_ text: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Descripción")
                .font(.title3.weight(.semibold))
            
            Text(text)
                .font(.body)
                .foregroundStyle(.primary)
        }
        .padding()
        .background(cardBackground)
    }
    
    private func abilitiesCard(_ pokemon: PokemonDetailModel) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Habilidades")
                .font(.title3.weight(.semibold))
            
            ForEach(pokemon.abilities) { item in
                HStack {
                    Text(item.ability.name.capitalized)
                        .font(.subheadline.weight(.medium))
                    
                    Spacer()
                    
                    if item.isHidden {
                        Text("Hidden")
                            .font(.caption.weight(.semibold))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color.black.opacity(0.08))
                            .clipShape(Capsule())
                    }
                }
            }
        }
        .padding()
        .background(cardBackground)
    }
    
    private func statsCard(_ pokemon: PokemonDetailModel) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Estadísticas")
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
                                .fill(backgroundColor)
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
        .background(cardBackground)
    }
    
    private func movesCard(_ pokemon: PokemonDetailModel) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Moves")
                .font(.title3.weight(.semibold))
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(Array(pokemon.moves.prefix(6))) { move in
                    Text(move.move.name.capitalized)
                        .font(.caption.weight(.semibold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .background(Color.black.opacity(0.06))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
            }
        }
        .padding()
        .background(cardBackground)
    }
    
    private var evolutionsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            Text("Evoluciones")
                .font(.title3.weight(.semibold))
            
            ScrollView(.horizontal, showsIndicators: false) {
                
                HStack(spacing: 14) {
                    
                    ForEach(viewModel.evolutionStages) { evolution in
                        
                        Button {
                            Task {
                                await viewModel.loadEvolutionPreview(for: evolution)
                            }
                        } label: {
                            
                            ZStack {
                                
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .fill(Color.gray.opacity(0.15))
                                    .frame(width: 110, height: 120)
                                
                                Circle()
                                    .fill(Color.white.opacity(0.15))
                                    .frame(width: 60, height: 60)
                                    .offset(x: 25, y: -35)
                                
                                VStack(spacing: 6) {
                                    
                                    AsyncImage(url: evolution.imageURL) { phase in
                                        switch phase {
                                            
                                        case .empty:
                                            ProgressView()
                                                .frame(width: 70, height: 70)
                                            
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 75, height: 75)
                                                .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 3)
                                            
                                        case .failure:
                                            Image(systemName: "photo")
                                                .frame(width: 70, height: 70)
                                            
                                        @unknown default:
                                            EmptyView()
                                        }
                                    }
                                    
                                    Text(evolution.name)
                                        .font(.caption.weight(.semibold))
                                        .lineLimit(1)
                                }
                            }
                            .frame(width: 110, height: 120)
                            .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 4)
                            
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .padding()
        .background(cardBackground)
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
    
    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 24, style: .continuous)
            .fill(Color(.systemBackground))
            .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
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
