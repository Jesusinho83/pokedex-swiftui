//
//  PokemonListView.swift
//  PracticaGtec
//
//  Created by Jesus Grimaldo on 06/03/26.
//

import SwiftUI

struct PokemonListView: View {
    
    @StateObject private var viewModel: PokemonListViewModel
    
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
                placement: .navigationBarDrawer(displayMode: .automatic),
                prompt: "Buscar Pokémon"
            )
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
                VStack(spacing: 12) {
                    typeFilterBar
                    
                    LazyVStack(spacing: 14) {
                        ForEach(viewModel.displayedPokemons) { pokemon in
                            NavigationLink {
                                PokemonDetailView(
                                    pokemonURL: pokemon.url,
                                    viewModel: AppContainer.makePokemonDetailViewModel()
                                )
                            } label: {
                                PokemonRowView(pokemon: pokemon)
                            }
                            .buttonStyle(.borderless)
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
                            .padding(.vertical)
                        }
                    }
                    .padding(.vertical)
                }
            }
            .refreshable {
                await viewModel.refresh()
            }
        }
    }
    
    private var typeFilterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(viewModel.availableTypes, id: \.self) { type in
                    
                    let color = type == "All"
                    ? Color.gray
                    : PokemonTypeColor.color(for: type.lowercased())
                                        
                    let textColor: Color = type.lowercased() == "electric"
                    ? .gray
                    : (viewModel.selectedType == type ? .white : color)
                                        
                    Button {
                        Task {
                            await viewModel.selectType(type)
                        }
                    } label: {
                        Text(type)
                            .font(.subheadline.weight(.semibold))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(
                                    viewModel.selectedType == type
                                        ? color
                                        : color.opacity(0.15)
                                    )
                                .foregroundStyle(textColor)
                                .overlay(
                                    Capsule()
                                        .stroke(color.opacity(0.25), lineWidth: 1)
                                )
                                .clipShape(Capsule())
                    }
                 
                }
            }
            .padding(.horizontal)
            .animation(.spring(), value: viewModel.selectedType)
        }
    }
}
