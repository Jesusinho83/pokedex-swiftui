//
//  PokemonListView.swift
//  PracticaGtec
//
//  Created by Jesus Grimaldo on 06/03/26.
//

import SwiftUI

struct PokemonListView: View {
    
    @StateObject private var viewModel: PokemonListViewModel
    
    private let columns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]
    
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
        HStack(spacing: 0) {
            ForEach(viewModel.availableTypes, id: \.self) { type in
                let color = type == "All"
                    ? Color.gray
                    : PokemonTypeColor.color(for: type.lowercased())
                
                let isSelected = viewModel.selectedType == type
                
                Button {
                    Task {
                        await viewModel.selectType(type)
                    }
                } label: {
                    VStack(spacing: 6) {
                        Circle()
                            .fill(isSelected ? color : color.opacity(0.25))
                            .frame(width: 10, height: 10)
                        
                        Text(type)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(isSelected ? color : .secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                }
            }
        }
        .padding(.horizontal, 8)
        .padding(.top, 8)
        .padding(.bottom, 10)
        .background(.ultraThinMaterial)
        .overlay(alignment: .top) {
            Divider()
        }
    }
}
