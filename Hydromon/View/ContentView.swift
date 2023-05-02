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
    private let lcdStandbyMessgageTitle = "LCD Standby Message"
    private let lcdStandbyMessageFooter = "This message will be displayed on the LCD during standby when you pick up your Hydromon."
    private let lcdAlertMessageTitle = "LCD Alert Message"
    private let lcdAlertMessageFooter = "This message will be displayed on the LCD during a drink reminder alert."
    private let standbyTimeoutTitle = "Standby Timeout"
    private let standbyTimeoutFooter = "The amount of time the device will stay awake after being picked up, in seconds."
    private let alertTimeoutTitle = "Alert Timeout"
    private let alertTimeoutFooter = "The duration of a drink reminder alert, in seconds."
    private let alertDelayTitle = "Alert Delay"
    private let alertDelayFooter = "The delay between drink reminder alerts, in seconds."
    private let oledMaxBrightnessTitle = "OLED Max Brightness"
    private let oledMaxBrightnessFooter = "The maximum brightness of the fill level display. Maximum brightness: 255."
    private let sipSizeTitle = "Sip Size"
    private let sipSizeFooter = "The average amount of water consumed in one 'sip,' in milileters."
    
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
                        HydromonStatusView(viewModel: .init(), LCD: $viewModel.preferences.LCDStandbyColor, statusLED: $viewModel.preferences.LEDStandbyColor)
                        // Controls
                        controls
                            .ignoresSafeArea()
                    } else {
                        Spacer()
                        ConnectionProblemView {
                            viewModel.testConnection()
                        }
                        .padding(16)
                        Spacer()
                    }
                }
            }
        }
        .onAppear {
            viewModel.testConnection()
        }
        .onChange(of: viewModel.connected) { connected in
            if connected {
                viewModel.fetchPreferences()
            }
        }
    }
    
    private var controls: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                // COLORS
                // LCD
                HStack {
                    // STANDBY
                    NavigationLink {
                        CustomColorPicker(component: .LCD, mode: .standby) { rgb in
                            self.viewModel.updatePreference(.LCDStandbyColor, value: rgb)
                        }
                        .navigationBarBackButtonHidden()
                    } label: {
                        IndicatorButton(title: "LCD STANDBY", rgb: $viewModel.preferences.LCDStandbyColor)
                    }
                    // ALERT
                    NavigationLink {
                        CustomColorPicker(component: .LCD, mode: .alert) { rgb in
                            self.viewModel.updatePreference(.LCDAlertColor, value: rgb)
                        }
                        .navigationBarBackButtonHidden()
                    } label: {
                        IndicatorButton(title: "LCD ALERT", rgb: $viewModel.preferences.LCDAlertColor)
                    }
                }
                // STATUS LED
                HStack {
                    // STANDBY
                    NavigationLink {
                        CustomColorPicker(component: .LED, mode: .standby) { rgb in
                            self.viewModel.updatePreference(.LEDStandbyColor, value: rgb)
                        }
                        .navigationBarBackButtonHidden()
                    } label: {
                        IndicatorButton(title: "LED STANDBY", rgb: $viewModel.preferences.LEDStandbyColor)
                    }
                    // ALERT
                    NavigationLink {
                        CustomColorPicker(component: .LED, mode: .alert) { rgb in
                            self.viewModel.updatePreference(.LEDAlertColor, value: rgb)
                        }
                        .navigationBarBackButtonHidden()
                    } label: {
                        IndicatorButton(title: "LED ALERT", rgb: $viewModel.preferences.LEDAlertColor)
                    }
                }
                .padding(.bottom, 16)
                // LCD STANDBY MESSAGE
                NavigationLink {
                    PreferenceTextfieldView(title: lcdStandbyMessgageTitle, preference: $viewModel.preferences.LCDStandbyMessage)
                        .navigationBarBackButtonHidden()
                } label: {
                    textfieldDisclosure(title: lcdStandbyMessgageTitle, currentValue: viewModel.preferences.LCDStandbyMessage, footer: lcdStandbyMessageFooter)
                }
                // LCD ALERT MESSAGE
                NavigationLink {
                    PreferenceTextfieldView(title: lcdAlertMessageTitle, preference: $viewModel.preferences.LCDAlertMessage)
                        .navigationBarBackButtonHidden()
                } label: {
                    textfieldDisclosure(title: lcdAlertMessageTitle, currentValue: viewModel.preferences.LCDAlertMessage, footer: lcdAlertMessageFooter)
                }
                // STANDBY TIMEOUT
                NavigationLink {
                    PreferenceNumberEntryView(title: standbyTimeoutTitle, footer: standbyTimeoutFooter, preference: $viewModel.preferences.standbyTimeout)
                        .navigationBarBackButtonHidden()
                } label: {
                    textfieldDisclosure(title: standbyTimeoutTitle, currentValue: String(viewModel.preferences.standbyTimeout), footer: standbyTimeoutFooter)
                }
                // ALERT TIMEOUT
                NavigationLink {
                    PreferenceNumberEntryView(title: alertTimeoutTitle, footer: alertTimeoutFooter, preference: $viewModel.preferences.alertTimeout)
                        .navigationBarBackButtonHidden()
                } label: {
                    textfieldDisclosure(title: alertTimeoutTitle, currentValue: String(viewModel.preferences.alertTimeout), footer: alertTimeoutFooter)
                }
                // ALERT DELAY
                NavigationLink {
                    PreferenceNumberEntryView(title: alertDelayTitle, footer: alertDelayFooter, preference: $viewModel.preferences.alertDelay)
                        .navigationBarBackButtonHidden()
                } label: {
                    textfieldDisclosure(title: alertDelayTitle, currentValue: String(viewModel.preferences.alertDelay), footer: alertDelayFooter)
                }
                // OLED MAX BRIGHTNESS
                NavigationLink {
                    PreferenceNumberEntryView(title: oledMaxBrightnessTitle, footer: oledMaxBrightnessFooter, preference: $viewModel.preferences.OLEDMaxBrightness)
                        .navigationBarBackButtonHidden()
                } label: {
                    textfieldDisclosure(title: oledMaxBrightnessTitle, currentValue: String(viewModel.preferences.OLEDMaxBrightness), footer: oledMaxBrightnessFooter)
                }
                // SIP SIZE
                NavigationLink {
                    PreferenceNumberEntryView(title: sipSizeTitle, footer: sipSizeFooter, preference: $viewModel.preferences.sipSize)
                        .navigationBarBackButtonHidden()
                } label: {
                    textfieldDisclosure(title: sipSizeTitle, currentValue: String(viewModel.preferences.sipSize), footer: sipSizeFooter)
                }
            }
            .padding(.top, 16)
            .padding(.bottom, 24)
        }
        .mask {
            LinearGradient(stops: [
                .init(color: .clear, location: 0.01),
                .init(color: .black, location: 0.04)
            ], startPoint: .top, endPoint: .bottom)
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .background {
                Colors.background
                    .ignoresSafeArea()
            }
            .preferredColorScheme(.dark)
            .edgesIgnoringSafeArea(.bottom)
    }
}
