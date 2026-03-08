//
//  PokemonListView.swift
//  PracticaGtec
//
//  Created by Jesus Grimaldo on 06/03/26.
//

import SwiftUI

struct PokemonListView: View {
    @Namespace private var typeBarNamespace
    @StateObject private var viewModel: PokemonListViewModel
    
    private let columns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]
    private func iconName(for type: String) -> String {
        switch type.lowercased() {
        case "all": return "square.grid.2x2.fill"
        case "fire": return "flame.fill"
        case "water": return "drop.fill"
        case "grass": return "leaf.fill"
        case "electric": return "bolt.fill"
        default: return "line.3.horizontal.decrease.circle.fill"
        }
    }

    private func colorForBottomBarItem(_ type: String) -> Color {
        if type == "More" {
            if viewModel.selectedType == "All" || viewModel.primaryTypes.contains(viewModel.selectedType) {
                return .secondary
            } else {
                return PokemonTypeColor.color(for: viewModel.selectedType.lowercased())
            }
        }
        
        return type == "All"
            ? .gray
            : PokemonTypeColor.color(for: type.lowercased())
    }

    private func isSelectedBottomBarItem(_ type: String) -> Bool {
        if type == "More" {
            return !viewModel.primaryTypes.contains(viewModel.selectedType) && viewModel.selectedType != "All"
        }
        
        return viewModel.selectedType == type
    }
    
    init(viewModel: PokemonListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [
                        Color(.systemGray6),
                        Color.blue
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                content
            }
            .navigationTitle("Pokédex")
            .navigationBarTitleDisplayMode(.large)
            .searchable(
                text: $viewModel.searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Buscar Pokémon"
            )
            .safeAreaInset(edge: .bottom) {
                bottomTypeBar
            }
            .task {
                await viewModel.loadPokemons()
            }
            .sheet(isPresented: $viewModel.isShowingMoreTypes) {
                MoreTypesSheet(
                    selectedType: viewModel.selectedType,
                    allTypes: viewModel.allAvailableTypes.filter { !viewModel.primaryTypes.contains($0) && $0 != "All" }
                ) { selectedType in
                    Task {
                        await viewModel.selectType(selectedType)
                        viewModel.isShowingMoreTypes = false
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            VStack(spacing: 16) {
                ProgressView()
                    .scaleEffect(1.2)
                
                Text("Cargando Pokémon...")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        } else if let errorMessage = viewModel.errorMessage {
            VStack(spacing: 16) {
                Image(systemName: "wifi.exclamationmark")
                    .font(.system(size: 42))
                    .foregroundStyle(.gray)
                
                Text("Ocurrió un error")
                    .font(.headline)
                
                Text(errorMessage)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Button {
                    Task {
                        await viewModel.refresh()
                    }
                } label: {
                    Text("Reintentar")
                        .fontWeight(.semibold)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.black)
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                }
            }
            .padding()
        } else {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.displayedPokemons) { pokemon in
                        NavigationLink {
                            PokemonDetailView(
                                pokemonURL: pokemon.url,
                                viewModel: AppContainer.makePokemonDetailViewModel()
                            )
                        } label: {
                            PokemonRowView(pokemon: pokemon)
                        }
                        .buttonStyle(.plain)
                        .onAppear {
                            if pokemon.id == viewModel.displayedPokemons.last?.id {
                                Task {
                                    await viewModel.loadMore()
                                }
                            }
                        }
                    }
                    
                    if viewModel.isLoadingMore {
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                        .gridCellColumns(2)
                        .padding(.vertical)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 12)
                .padding(.bottom, 90)
            }
            .refreshable {
                await viewModel.refresh()
            }
        }
    }
    
    private var bottomTypeBar: some View {
        let items = viewModel.primaryTypes + ["More"]
        
        return HStack(spacing: 0) {
            ForEach(items, id: \.self) { type in
                let isSelected = isSelectedBottomBarItem(type)
                
                Button {
                    if type == "More" {
                        viewModel.isShowingMoreTypes = true
                    } else {
                        Task {
                            await viewModel.selectType(type)
                        }
                    }
                } label: {
                    VStack(spacing: 6) {
                        Image(systemName: iconName(for: type))
                            .font(.system(size: 18, weight: .semibold))
                        
                        Text(type)
                            .font(.caption2.weight(.semibold))
                            .lineLimit(1)
                    }
                    .foregroundStyle(isSelected ? .gray : .secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background {
                        if isSelected {
                            Capsule()
                                .fill(.white)
                                .padding(.horizontal, 6)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 10)
        .padding(.top, 8)
        .padding(.bottom, 10)
        .background(.ultraThinMaterial)
        .overlay(alignment: .top) {
            Divider()
        }
    }
}
