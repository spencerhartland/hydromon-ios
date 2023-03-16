//
//  CustomColorPicker.swift
//  Hydromon
//
//  Created by Spencer Hartland on 3/15/23.
//

import SwiftUI

struct CustomColorPicker: View {
    private let colorPickerColorWellImageName = "color-picker_color-well"
    private let subtitleTemplate = "Choose the %@'s %@ color by sliding the sliders or entering RGB values."
    
    let component: Hydromon.Component
    let mode: Hydromon.Mode
    
    @State private var rgb = (255.0, 255.0, 255.0)
    @State private var color = Color(red: 255/255, green: 255/255, blue: 255/255)
    
    var body: some View {
        VStack(spacing: 0) {
            Text("\(component.rawValue.uppercased()) \(mode.rawValue.uppercased())")
                .font(Fonts.bold(size: 32))
            Text(String(format: subtitleTemplate, component.rawValue.uppercased(), mode.rawValue))
                .font(Fonts.semibold(size: 10))
                .multilineTextAlignment(.center)
            colorSelectionView
            VStack(spacing: 32) {
                ColorPickerBar(color: .red) { value in
                    self.rgb.0 = value
                    self.color = Color(red: (self.rgb.0 / 255), green: (self.rgb.1 / 255), blue: (self.rgb.2 / 255))
                }
                ColorPickerBar(color: .green) { value in
                    self.rgb.1 = value
                    self.color = Color(red: (self.rgb.0 / 255), green: (self.rgb.1 / 255), blue: (self.rgb.2 / 255))
                }
                ColorPickerBar(color: .blue) { value in
                    self.rgb.2 = value
                    self.color = Color(red: (self.rgb.0 / 255), green: (self.rgb.1 / 255), blue: (self.rgb.2 / 255))
                }
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .foregroundColor(Colors.primary)
    }
    
    var colorSelectionView: some View {
        ZStack {
            Image(Hydromon.Icon.bottleImageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Colors.secondaryBackground)
            switch component {
            case .LCD:
                Image(Hydromon.Icon.lcdImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            case .OLED:
                Image(Hydromon.Icon.oledImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            case .LED:
                Image(Hydromon.Icon.ledImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        .foregroundColor(color)
    }
}

private struct ColorPickerBar: View {
    private static let maxSliderValue = 369.0
    private let colorPickerBarImageName = "control_color-picker-bar"
    
    @State var color: Color
    @State private var sliderValue = ColorPickerBar.maxSliderValue
    
    let action: (Double) -> Void
    
    var body: some View {
        VStack(spacing: 6) {
            HStack(spacing: 0) {
                Color.clear
                    .frame(width: sliderValue, height: 0)
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
            HStack(spacing: 0) {
                Color.clear
                    .frame(width: sliderValue, height: 0)
                Image(systemName: "play.fill")
                    .font(.system(size: 12))
                    .rotationEffect(.degrees(-90))
                Spacer()
            }
        }
        .foregroundColor(Colors.primary)
        .gesture(DragGesture(minimumDistance: 0)
            .onChanged({ value in
                self.sliderValue = boundSliderValue(value.location.x)
                action((self.sliderValue / ColorPickerBar.maxSliderValue) * 255)
            })
        )
    }
    
    private func boundSliderValue(_ value: Double) -> Double {
        var boundedValue = 0.0
        if value < 0.0 {
            boundedValue = 0.0
        } else if value > ColorPickerBar.maxSliderValue {
            boundedValue = ColorPickerBar.maxSliderValue
        } else {
            boundedValue = value
        }
        return boundedValue
    }
}

struct CustomColorPicker_Previews: PreviewProvider {
    static var previews: some View {
        CustomColorPicker(component: .LCD, mode: .standby)
            .background {
                Colors.background
                    .ignoresSafeArea()
            }
    }
}
