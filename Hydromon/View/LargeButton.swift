//
//  LargeButton.swift
//  Hydromon
//
//  Created by Spencer Hartland on 3/23/23.
//

import SwiftUI

struct LargeButton: View {
    private let largeButtonBackgroundImageName = "large-button-bg"
    private let largeButtonGradientImageName = "large-button-gradient"
    
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                Image(largeButtonBackgroundImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Colors.secondaryBackground)
                Text(title.uppercased())
                    .font(Fonts.semibold(size: 18))
                    .foregroundColor(Colors.primary)
                    .glow(Colors.primary, intensity: 0.5)
                Image(largeButtonGradientImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(color)
            }
            .frame(height: 64)
        }
    }
}
