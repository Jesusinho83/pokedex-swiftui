//
//  MoreTypesSheet.swift
//  PracticaGtec
//
//  Created by Elizabeth Nieves on 08/03/26.
//

import SwiftUI

struct MoreTypesSheet: View {
    
    let selectedType: String
    let allTypes: [String]
    let onSelect: (String) -> Void
    
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
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
            ScrollView {
                LazyVGrid(columns: columns, spacing: 14) {
                    ForEach(allTypes, id: \.self) { type in
                        let color = PokemonTypeColor.color(for: type.lowercased())
                        let isSelected = selectedType == type
                        
                        Button {
                            onSelect(type)
                        } label: {
                            HStack(spacing: 10) {
                                Circle()
                                    .fill(color)
                                    .frame(width: 10, height: 10)
                                
                                Text(type)
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(.white )
                                
                                Spacer()
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .fill(color)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .stroke(color.opacity(0.18), lineWidth: 1)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .navigationTitle("More Types")
            .navigationBarTitleDisplayMode(.inline)
        }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}
