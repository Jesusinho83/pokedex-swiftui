//
//  PokemonListView.swift
//  PracticaGtec
//
//  Created by Jesus Grimaldo on 06/03/26.
//

import SwiftUI

struct PokemonListView: View {
    @StateObject private var viewModel = PokemonListViewModel()
    
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
                        await viewModel.loadPokemons()
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
                LazyVStack(spacing: 14) {
                    ForEach(viewModel.pokemons) { pokemon in
                        NavigationLink {
                            PokemonDetailView(pokemonURL: pokemon.url)
                        } label: {
                            PokemonRowView(pokemon: pokemon)
                        }
                        .buttonStyle(.borderless)
                        .onAppear {
                            if pokemon.id == viewModel.pokemons.last?.id {
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
            .refreshable {
                await viewModel.refresh()
            }
        }
    }
}
