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
    private let texfieldDisclosureIndicatorImageName = "control_textfield-disclosure-indicator"
    private let textfieldDisclosureBackgroundImageName = "control_textfield-disclosure-bg"
    private let textfieldDisclosureHighlightImageName = "control_textfield-disclosure-highlight"
    private let disclosureIcon = "chevron.right"
    private let lcdStandbyMessageFooter = "This message will be displayed on the LCD during standby when you pick up your Hydromon."
    private let lcdStandbyMessgageControlTitle = "LCD Standby Message"
    
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        GeometryReader { geo in
            NavigationStack {
                VStack(alignment: .leading) {
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
                        // Controls
                        VStack(alignment: .leading) {
                            HStack {
                                NavigationLink {
                                    CustomColorPicker(component: .LCD, mode: .standby) { rgb in
                                        self.viewModel.updatePreference(.LCDStandbyColor, value: rgb)
                                    }
                                    .navigationBarBackButtonHidden()
                                } label: {
                                    IndicatorButton(title: "LCD STANDBY", rgb: $viewModel.preferences.LCDStandbyColor)
                                }
                                //colorPickerButton(title: "LED STANDBY")
                            }
                            HStack {
                                //colorPickerButton(title: "LCD REMINDER")
                                //colorPickerButton(title: "LED REMINDER")
                            }
                            .padding(.bottom, 16)
                            textfieldDisclosure(title: lcdStandbyMessgageControlTitle, currentValue: viewModel.preferences.LCDStandbyMessage, footer: lcdStandbyMessageFooter)
                        }
                    } else {
                        Spacer()
                        ConnectionProblemView {
                            viewModel.testConnection()
                        }
                        Spacer()
                    }
                }
                Spacer()
            }
        }
        .onAppear {
            viewModel.testConnection()
        }
    }
    
    func textfieldDisclosure(title: String, currentValue: String, footer: String) -> some View {
        VStack(alignment: .leading) {
            ZStack {
                Image(texfieldDisclosureIndicatorImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Image(textfieldDisclosureBackgroundImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Image(textfieldDisclosureHighlightImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Colors.secondary)
                HStack {
                    Text(title.uppercased())
                        .font(Fonts.semibold(size: 14))
                        .padding(.leading, 32)

                    Spacer()

                    HStack {
                        Text(currentValue.uppercased())
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
            .foregroundColor(Colors.secondaryBackground)
            .padding(.horizontal, 8)
            Text(footer)
                .font(Fonts.regular(size: 8))
                .padding([.leading, .trailing], 32)
                .foregroundColor(Colors.secondary)
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .background {
                Colors.background
                    .ignoresSafeArea()
            }
            .preferredColorScheme(.dark)
    }
}
