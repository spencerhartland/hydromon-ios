//
//  CustomColorPicker.swift
//  Hydromon
//
//  Created by Spencer Hartland on 3/15/23.
//

import SwiftUI

struct CustomColorPicker: View {
    private let colorPickerBarImageName = "control_color-picker-bar"
    
    var body: some View {
        VStack(spacing: 48) {
            colorPickerBar(color: .red)
            colorPickerBar(color: .green)
            colorPickerBar(color: .blue)
        }
        .padding(.horizontal, 16)
    }
    
    func colorPickerBar(color: Color) -> some View {
        VStack(spacing: 6) {
            HStack {
                Color.clear
                    .frame(width: 100, height: 0)
                Image(systemName: "play.fill")
                    .font(.system(size: 12))
                    .rotationEffect(.degrees(90))
                Spacer()
            }
            Image(colorPickerBarImageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.clear)
                .background {
                    LinearGradient(
                        colors: [Colors.secondaryBackground, color],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .mask {
                        Image(colorPickerBarImageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                }
            HStack {
                Color.clear
                    .frame(width: 100, height: 0)
                Image(systemName: "play.fill")
                    .font(.system(size: 12))
                    .rotationEffect(.degrees(-90))
                Spacer()
            }
        }
        .foregroundColor(Colors.primary)
    }
}

struct CustomColorPicker_Previews: PreviewProvider {
    static var previews: some View {
        CustomColorPicker()
    }
}
