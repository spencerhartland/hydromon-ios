//
//  CustomColorPicker.swift
//  Hydromon
//
//  Created by Spencer Hartland on 3/15/23.
//

import SwiftUI

struct CustomColorPicker: View {
    private let colorPickerRGBEntryOutlineImageName = "color-picker_rgb-entry-outline"
    private let subtitleTemplate = "Choose the %@'s %@ color by sliding the sliders."
    private let largeButtonBackgroundImageName = "large-button-bg"
    private let largeButtonGradientImageName = "large-button-gradient"
    private let buttonTextTemplate = "Set %@ color"
    
    let component: Hydromon.Component
    let mode: Hydromon.Mode
    let action: (RGB) -> Void
    
    @State private var rgb = RGB(red: 255, green: 255, blue: 255)
    @State private var color = Color(red: 255/255, green: 255/255, blue: 255/255)
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 0) {
                Text("\(component.rawValue.uppercased()) \(mode.rawValue.uppercased())")
                    .font(Fonts.bold(size: 32))
                Text(String(format: subtitleTemplate, component.rawValue.uppercased(), mode.rawValue))
                    .font(Fonts.semibold(size: 10))
                    .multilineTextAlignment(.center)
            }
            ColorSelectionView(component: component, color: $color)
            rgbEntry
            VStack(spacing: 24) {
                ColorPickerBar(color: Color(red: 1, green: 0, blue: 0)) { value in
                    self.rgb.red = Int(value)
                    self.color = Color(red: Double(self.rgb.red / 255), green: Double(self.rgb.green / 255), blue: Double(self.rgb.blue / 255))
                }
                ColorPickerBar(color: Color(red: 0, green: 1, blue: 0)) { value in
                    self.rgb.green = Int(value)
                    self.color = Color(red: Double(self.rgb.red / 255), green: Double(self.rgb.green / 255), blue: Double(self.rgb.blue / 255))
                }
                ColorPickerBar(color: Color(red: 0, green: 0, blue: 1)) { value in
                    self.rgb.blue = Int(value)
                    self.color = Color(red: Double(self.rgb.red / 255), green: Double(self.rgb.green / 255), blue: Double(self.rgb.blue / 255))
                }
            }
            Spacer()
            Button {
                action(rgb)
            } label: {
                ZStack {
                    Image(largeButtonBackgroundImageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Colors.secondaryBackground)
                    Text(String(format: buttonTextTemplate, mode.rawValue).uppercased())
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
        .padding(.horizontal, 16)
        .foregroundColor(Colors.primary)
    }
    
    var rgbEntry: some View {
        ZStack {
            Image(colorPickerRGBEntryOutlineImageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Colors.secondaryBackground)
            HStack(spacing: 0) {
                Text("R")
                Text("\(self.rgb.red)")
                    .padding(.trailing, 4)
                    .foregroundColor(Colors.primary)
                Text("G")
                Text("\(self.rgb.green)")
                    .padding(.trailing, 4)
                    .foregroundColor(Colors.primary)
                Text("B")
                Text("\(self.rgb.blue)")
                    .padding(.trailing, 4)
                    .foregroundColor(Colors.primary)
            }
            .font(Fonts.semibold(size: 18))
            .offset(x: 6)
        }
        .frame(width: 170)
        .foregroundColor(Colors.secondary)
    }
}

private struct ColorSelectionView: View {
    private let colorPickerColorWellImageName = "color-picker_color-well"
    private let pointerSymbolName = "play.fill"
    
    let component: Hydromon.Component
    
    @Binding var color: Color
    
    var body: some View {
        ZStack {
            Image(Hydromon.Icon.bottleImageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Colors.secondaryBackground)
            switch component {
            case .LCD:
                // TODO: - Add in accessory views that show the color in a larger color well in addition to the compoent
                Image(Hydromon.Icon.lcdImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .glow(color, intensity: 0.5)
                lcdDetailColorWell
            case .OLED:
                // No color options for OLED, so ignore this case
                EmptyView()
            case .LED:
                Image(Hydromon.Icon.ledImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .glow(color)
                ledDetailColorWell
            }
        }
        .foregroundColor(color)
    }
    
    var lcdDetailColorWell: some View {
        HStack(spacing: 0) {
            Color.clear
            VStack(alignment: .trailing) {
                Color.clear
                    .frame(height: 14)
                HStack(alignment: .bottom) {
                    Image(colorPickerColorWellImageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(color)
                        .frame(width: 72)
                    Image(systemName: pointerSymbolName)
                        .font(.system(size: 10))
                        .foregroundColor(Colors.primary)
                }
                Spacer()
            }
            Color.clear
                .frame(width: 228)
        }
    }
    
    var ledDetailColorWell: some View {
        HStack(spacing: 0) {
            Color.clear
                .frame(width: 228)
            VStack(alignment: .trailing) {
                Spacer()
                HStack(alignment: .bottom) {
                    Image(systemName: pointerSymbolName)
                        .font(.system(size: 10))
                        .foregroundColor(Colors.primary)
                        .rotationEffect(.degrees(180))
                    Image(colorPickerColorWellImageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(color)
                        .rotation3DEffect(.degrees(180), axis: (x: 1, y: 0, z: 0))
                        .frame(width: 72)
                }
                Color.clear
                    .frame(height: 14)
            }
            Color.clear
        }
    }
}

private struct ColorPickerBar: View {
    private struct SliderBounds {
        static let min = 0.0
        static let max = 350.0
    }
    private let colorPickerBarImageName = "control_color-picker-bar"
    private let pointerSymbolName = "play.fill"
    
    @State var color: Color
    @State private var sliderValue = SliderBounds.max
    
    let action: (Double) -> Void
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Color.clear
                    .frame(width: sliderValue)
                Image(systemName: pointerSymbolName)
                    .font(.system(size: 12))
                    .rotationEffect(.degrees(90))
                    .foregroundColor(Colors.primary)
                    .glow(Colors.primary)
                Color.clear
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
        }
        .frame(width: 350)
        .gesture(DragGesture(minimumDistance: 0)
            .onChanged({ value in
                self.sliderValue = boundSliderValue(value.location.x)
                action(((self.sliderValue - SliderBounds.min) / (SliderBounds.max - SliderBounds.min)) * 255)
                print(self.sliderValue)
            })
        )
    }
    
    private func boundSliderValue(_ value: Double) -> Double {
        var boundedValue = SliderBounds.min
        if value < SliderBounds.min {
            boundedValue = SliderBounds.min
        } else if value > SliderBounds.max {
            boundedValue = SliderBounds.max
        } else {
            boundedValue = value
        }
        return boundedValue
    }
}

struct CustomColorPicker_Previews: PreviewProvider {
    static var previews: some View {
        CustomColorPicker(component: .LED, mode: .standby) { color in
            print("\(color.red) \(color.green) \(color.blue)")
        }
            .background {
                Colors.background
                    .ignoresSafeArea()
            }
    }
}
