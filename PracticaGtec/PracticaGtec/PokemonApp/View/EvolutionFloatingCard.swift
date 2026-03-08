//
//  EvolutionFloatingCard.swift
//  PracticaGtec
//
//  Created by Jesus Grimaldo on 08/03/26.
//

import SwiftUI

struct EvolutionFloatingCard: View {
    
    let evolution: EvolutionCardDetailModel
    let onClose: () -> Void
    
    private var typeColor: Color {
        PokemonTypeColor.color(for: evolution.type)
    }
    
    private var textColor: Color {
        evolution.type == "electric" ? .black : .white
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.40)
                .ignoresSafeArea()
                .onTapGesture {
                    onClose()
                }
            
            VStack(spacing: 14) {
                
                ZStack {
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    typeColor.opacity(0.95),
                                    typeColor.opacity(0.65),
                                    typeColor.opacity(0.45)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .stroke(Color.white.opacity(0.25), lineWidth: 1.2)
                    
                    Circle()
                        .fill(Color.white.opacity(0.12))
                        .frame(width: 180, height: 180)
                        .offset(x: 85, y: -110)
                    
                    VStack(alignment: .leading, spacing: 14) {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("#\(String(format: "%03d", evolution.id))")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(textColor.opacity(0.85))
                                
                                Text(evolution.name)
                                    .font(.title.bold())
                                    .foregroundStyle(textColor)
                                
                                Text(evolution.type.capitalized)
                                    .font(.caption.weight(.semibold))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(Color.white.opacity(0.18))
                                    .foregroundStyle(textColor)
                                    .clipShape(Capsule())
                            }
                            
                            Spacer()
                        }
                        
                        HStack {
                            Spacer()
                            
                            AsyncImage(url: evolution.imageURL) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(width: 140, height: 140)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 150)
                                        .shadow(color: .black.opacity(0.18), radius: 14, x: 0, y: 8)
                                case .failure:
                                    Image(systemName: "photo")
                                        .font(.system(size: 50))
                                        .foregroundStyle(textColor.opacity(0.75))
                                        .frame(height: 150)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            
                            Spacer()
                        }
                        
                        VStack(alignment: .leading, spacing: 10) {
                            if let flavorText = evolution.flavorText, !flavorText.isEmpty {
                                Text(flavorText)
                                    .font(.footnote)
                                    .foregroundStyle(textColor.opacity(0.95))
                                    .lineLimit(3)
                            }
                            
                            HStack {
                                infoChip(title: "Altura", value: "\(evolution.height)")
                                infoChip(title: "Peso", value: "\(evolution.weight)")
                                infoChip(title: "Exp", value: "\(evolution.baseExperience)")
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Habilidades")
                                    .font(.caption.weight(.bold))
                                    .foregroundStyle(textColor.opacity(0.9))
                                
                                FlexibleAbilityWrap(
                                    abilities: evolution.abilities,
                                    textColor: textColor
                                )
                            }
                        }
                    }
                    .padding(22)
                }
                .frame(width: 320, height: 500)
                .shadow(color: .black.opacity(0.22), radius: 20, x: 0, y: 10)
            }
            .padding(.horizontal, 24)
        }
    }
    
    private func infoChip(title: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption2)
                .foregroundStyle(textColor.opacity(0.8))
            
            Text(value)
                .font(.caption.weight(.bold))
                .foregroundStyle(textColor)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color.white.opacity(0.14))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}
