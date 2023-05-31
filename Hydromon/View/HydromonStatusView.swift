//
//  HydromonStatusView.swift
//  Hydromon
//
//  Created by Spencer Hartland on 3/4/23.
//

import SwiftUI

struct HydromonStatusView: View {
    
    @StateObject var viewModel = ViewModel()
    
    @Binding var LCD: String
    @Binding var statusLED: String
    
    @State private var contentSize: CGSize = .zero
    
    var body: some View {
        VStack {
            HStack { Spacer() }
                .background { ViewGeometry() }
                .onPreferenceChange(ViewSizeKey.self) {
                    contentSize = $0
                }
            ZStack {
                // Hydroflask bottle
                Image(Hydromon.Icon.bottleImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Colors.primary)
                // OLED
                OLEDDisplayView(fillLevel: $viewModel.fillLevel)
                // Status LED
                Image(Hydromon.Icon.ledImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(RGB(from: statusLED).color())
                    .glow(RGB(from: statusLED).color(), intensity: 1.75)
                // LCD
                Image(Hydromon.Icon.lcdImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(RGB(from: LCD).color())
                    .glow(RGB(from: LCD).color(), intensity: 0.75)
            }
            .frame(width: contentSize.width / 2)
            .padding(.vertical, 16)
        }
        .overlay {
            HStack(spacing: 0) {
                VStack(alignment: .leading) {
                    Spacer()
                    Color.clear
                }
                Color.clear
                    .frame(width: 78)
                VStack {
                    Spacer()
                    ZStack(alignment: .topLeading) {
                        Color.clear
                        WaterLevelStatusView($viewModel.fillLevel)
                    }
                    .frame(height: 157)
                }
            }
        }
    }
}

private struct OLEDDisplayView: View {
    private let fullFillLevelValue: Double = 59 // empty = 40
    
    @Binding var fillLevel: Double
    
    var body: some View {
        Image(Hydromon.Icon.oledImageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(.clear)
            .background {
                Rectangle()
                    .foregroundColor(fillLevel >= 0.5 ? .green : fillLevel >= 0.25 ? .orange : .red)
                    .mask {
                        VStack {
                            Spacer()
                            Rectangle()
                                .frame(height: fillLevelValue(fillLevel))
                        }
                    }
                    .mask {
                        Image(Hydromon.Icon.oledImageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
            }
            .glow(fillLevel >= 0.5 ? .green : fillLevel >= 0.25 ? .orange : .red)
    }
    
    func fillLevelValue(_ level: Double) -> Double {
        let offset: Double = 19
        return fullFillLevelValue - (offset - (offset * fillLevel))
    }
}
