//
//  WaterLevelStatusView.swift
//  Hydromon
//
//  Created by Spencer Hartland on 3/6/23.
//

import SwiftUI

struct WaterLevelStatusView: View {
    private let pointerSymbolName = "play.fill"
    private let titleText = "WATER LEVEL"
    private let filllevelBarHeight: CGFloat = 96
    private let fillLevelBarImageName = "fill-level-bar"
    private let fillLevelGradient = LinearGradient(stops: [
        .init(color: .red, location: 0.1),
        .init(color: .orange, location: 0.25),
        .init(color: .green, location: 1.0)
    ], startPoint: .bottom, endPoint: .top)
    
    let fillLevelIndicatorColor: Color
    
    @Binding var fillLevel: Double
    @State var contentSize: CGSize = .zero
    
    init(_ fillLevel: Binding<Double>) {
        self._fillLevel = fillLevel
        self.fillLevelIndicatorColor = fillLevel.wrappedValue > 0.5 ? .green : fillLevel.wrappedValue >= 0.25 ? .orange : .red
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .bottom, spacing: 16) {
                Image(systemName: pointerSymbolName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 8)
                    .glow(Colors.primary)
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                HStack(alignment: .bottom) {
                    Image(fillLevelBarImageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: filllevelBarHeight)
                        .foregroundColor(.clear)
                        .background {
                            ZStack {
                                // Fill level bar -- Background
                                fillLevelGradient
                                    .mask {
                                        Image(fillLevelBarImageName)
                                            .resizable()
                                    }
                                // Fill level bar -- Glow
                                fillLevelGradient
                                    .overlay {
                                        VStack {
                                            Colors.background
                                                .frame(height: filllevelBarHeight - (filllevelBarHeight * fillLevel))
                                            Color.clear
                                        }
                                        .mask {
                                            Image(fillLevelBarImageName)
                                                .resizable()
                                        }
                                    }
                                    .mask {
                                        Image(fillLevelBarImageName)
                                            .resizable()
                                    }
                                    .blur(radius: 4)
                            }
                        }
                        .overlay {
                            VStack {
                                Colors.secondaryBackground
                                    .frame(height: filllevelBarHeight - (filllevelBarHeight * fillLevel))
                                Color.clear
                            }
                            .mask {
                                Image(fillLevelBarImageName)
                                    .resizable()
                            }
                        }
                    VStack(alignment: .leading, spacing: -6) {
                        Text(titleText)
                            .font(Fonts.bold(size: 10))
                        Text("\(100*fillLevel, specifier: "%.0f")%")
                            .font(Fonts.bold(size: 24))
                            .foregroundColor(Colors.primary)
                    }
                    .offset(y: 8)
                }
                Spacer()
            }
            .foregroundColor(Colors.primary)
            Spacer()
        }
    }
}

struct WaterLevelStatusView_Previews: PreviewProvider {
    static var previews: some View {
        WaterLevelStatusView(.constant(0.5))
            .background {
                Colors.background
                    .ignoresSafeArea()
            }
    }
}
