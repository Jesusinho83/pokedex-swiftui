//
//  FlexibleAbilityWrap.swift
//  PracticaGtec
//
//  Created by Jesus Grimaldos on 08/03/26.
//

import SwiftUI

struct FlexibleAbilityWrap: View {
    let abilities: [String]
    let textColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(abilities, id: \.self) { ability in
                Text(ability)
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.white.opacity(0.16))
                    .foregroundStyle(textColor)
                    .clipShape(Capsule())
            }
        }
    }
}
