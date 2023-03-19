//
//  ContentView.swift
//  Hydromon
//
//  Created by Spencer Hartland on 1/31/23.
//

import Foundation
import SwiftUI

struct ContentView: View {
    private let hydromonText = "hydromon"
    
    @Binding var presentedViews: [AnyView]
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    ConnectionStatusView($viewModel.connected)
                        .offset(x: -8)
                        .padding(.bottom)
                    ZStack(alignment: .bottomTrailing) {
                        HydromonLogoView()
                        BatterySOCView(charging: .constant(false), batterySOC: .constant(0.55))
                            .frame(height: 6)
                            .offset(x: -24, y: -2.5)
                    }
                }
                .padding(.leading)
                if viewModel.connected {
                    HydromonStatusView(viewModel: .init(), LCDColor: .constant(.green), statusLEDColor: .constant(.green))
                    ControlView(preferences: $viewModel.preferences, presentedViews: $presentedViews)
                } else {
                    Spacer()
                    ConnectionProblemView {
                        viewModel.testConnection()
                    }
                    Spacer()
                }
            }
        }
        .onAppear {
            viewModel.testConnection()
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(presentedViews: .constant([]))
            .background {
                Colors.background
                    .ignoresSafeArea()
            }
            .preferredColorScheme(.dark)
    }
}
