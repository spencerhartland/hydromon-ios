//
//  IndicatorButton.swift
//  Hydromon
//
//  Created by Spencer Hartland on 3/21/23.
//

import SwiftUI

struct IndicatorButton: View {
    private let indicatorImageName = "control_color-picker-indicator"
    private let buttonBackgroundImageName = "control_color-picker-bg"
    private let buttonHighlightImageName = "control_color-picker-highlight"
    
    let title: String
    @Binding var rgb: RGB
    
    var body: some View {
        ZStack {
            Image(indicatorImageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(rgb.color())
            Image(buttonBackgroundImageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
            Image(buttonHighlightImageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(rgb.color())
            HStack {
                Text(title.uppercased())
                Spacer()
            }
            .foregroundColor(Colors.primary)
            .font(Fonts.semibold(size: 14))
            .padding(.leading, 32)
        }
        .foregroundColor(Colors.secondaryBackground)
        .padding(.horizontal, 8)
    }
}
