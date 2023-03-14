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
                    HydromonStatusView(LCDColor: .constant(.red), statusLEDColor: .constant(.blue), LCDText: .constant("Hello, world!"), fillLevel: .constant(0.75))
                    ControlView(preferences: $viewModel.preferences)
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

struct ControlView: View {
    private let controlIndicatorImageName = "control_indicator-decoration"
    private let textfieldDisclosureBackgroundImageName = "control_textfield-disclosure-button"
    private let textfieldDisclosureHighlightImageName = "control_textfield-disclosure-button-highlight"
    private let disclosureIcon = "chevron.right"
    private let LCDStandbyMessageFooter = "The message displayed on the LCD during standy when the device is picked up and for a short time after."
    private let LCDStandbyMessgageControlTitle = "LCD Standby Message"
    
    @Binding var preferences: PreferenceSet
    
    var body: some View {
        textfieldDisclosureButton
    }
    
    private var textfieldDisclosureButton: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 2) {
                Spacer()
                Image(controlIndicatorImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                ZStack(alignment: .leading) {
                    Image(textfieldDisclosureBackgroundImageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    Image(textfieldDisclosureHighlightImageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Colors.secondary)
                    HStack {
                        Text(LCDStandbyMessgageControlTitle.uppercased())
                            .font(Fonts.semibold(size: 14))
                            .padding(.leading, 16)
                        
                        Spacer()
                        
                        HStack {
                            Text(preferences.LCDStandbyMessage.uppercased())
                                .font(Fonts.semibold(size: 14))
                            Image(systemName: disclosureIcon)
                                .font(.system(size: 10))
                                .offset(y: -0.5)
                        }
                        .foregroundColor(Colors.secondary)
                        .padding(.trailing, 24)
                    }
                    .foregroundColor(Colors.primary)
                }
                Spacer()
            }
            .foregroundColor(Colors.secondaryBackground)
            .frame(height: 40)
            Text(LCDStandbyMessageFooter)
                .font(Fonts.regular(size: 8))
                .padding([.leading, .trailing], 32)
                .foregroundColor(Colors.secondary)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .background {
                Colors.background
                    .ignoresSafeArea()
            }
            .preferredColorScheme(.dark)
    }
}
