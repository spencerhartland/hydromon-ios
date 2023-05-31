//
//  ContentView.swift
//  Hydromon
//
//  Created by Spencer Hartland on 1/31/23.
//

import Foundation
import SwiftUI

struct ControlView: View {
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
    
    @StateObject var bluetoothManager: BluetoothManager
    @Binding var shouldShowControlView: Bool
    
    var body: some View {
        GeometryReader { geo in
            NavigationStack {
                VStack(alignment: .leading) {
                    if bluetoothManager.isConnected {
                        VStack(alignment: .leading, spacing: 0) {
                            ConnectionStatusView($bluetoothManager.isConnected)
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
                        HydromonStatusView(
                            LCD: $bluetoothManager.preferences.lcdStandbyColor,
                            statusLED: $bluetoothManager.preferences.ledStandbyColor)
                        // Controls
                        controls
                            .ignoresSafeArea()
                    } else {
                        Spacer()
                        ConnectionProblemView {
                            shouldShowControlView = false
                        }
                        .padding(16)
                        Spacer()
                    }
                }
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
                        CustomColorPicker(component: .LCD, mode: .standby, color: $bluetoothManager.preferences.lcdStandbyColor)
                        .navigationBarBackButtonHidden()
                    } label: {
                        IndicatorButton(title: "LCD STANDBY", rgb: bluetoothManager.preferences.lcdStandbyColor)
                    }
                    // ALERT
                    NavigationLink {
                        CustomColorPicker(component: .LCD, mode: .alert, color: $bluetoothManager.preferences.lcdAlertColor)
                        .navigationBarBackButtonHidden()
                    } label: {
                        IndicatorButton(title: "LCD ALERT", rgb: bluetoothManager.preferences.lcdAlertColor)
                    }
                }
                // STATUS LED
                HStack {
                    // STANDBY
                    NavigationLink {
                        CustomColorPicker(component: .LED, mode: .standby, color: $bluetoothManager.preferences.ledStandbyColor)
                        .navigationBarBackButtonHidden()
                    } label: {
                        IndicatorButton(title: "LED STANDBY", rgb: bluetoothManager.preferences.ledStandbyColor)
                    }
                    // ALERT
                    NavigationLink {
                        CustomColorPicker(component: .LED, mode: .alert, color: $bluetoothManager.preferences.ledAlertColor)
                        .navigationBarBackButtonHidden()
                    } label: {
                        IndicatorButton(title: "LED ALERT", rgb: bluetoothManager.preferences.ledAlertColor )
                    }
                }
                .padding(.bottom, 16)
                // LCD STANDBY MESSAGE
                NavigationLink {
                    PreferenceTextfieldView(title: lcdStandbyMessgageTitle, footer: lcdStandbyMessageFooter, preference: $bluetoothManager.preferences.lcdStandbyMessage)
                        .navigationBarBackButtonHidden()
                } label: {
                    textfieldDisclosure(title: lcdStandbyMessgageTitle, currentValue: bluetoothManager.preferences.lcdStandbyMessage, footer: lcdStandbyMessageFooter)
                }
                // LCD ALERT MESSAGE
                NavigationLink {
                    PreferenceTextfieldView(title: lcdAlertMessageTitle, footer: lcdAlertMessageFooter, preference: $bluetoothManager.preferences.lcdAlertMessage)
                        .navigationBarBackButtonHidden()
                } label: {
                    textfieldDisclosure(title: lcdAlertMessageTitle, currentValue: bluetoothManager.preferences.lcdAlertMessage, footer: lcdAlertMessageFooter)
                }
                // STANDBY TIMEOUT
                NavigationLink {
                    PreferenceNumberEntryView(title: standbyTimeoutTitle, footer: standbyTimeoutFooter, preference: $bluetoothManager.preferences.standbyTimeout)
                        .navigationBarBackButtonHidden()
                } label: {
                    textfieldDisclosure(title: standbyTimeoutTitle, currentValue: String(bluetoothManager.preferences.standbyTimeout), footer: standbyTimeoutFooter)
                }
                // ALERT TIMEOUT
                NavigationLink {
                    PreferenceNumberEntryView(title: alertTimeoutTitle, footer: alertTimeoutFooter, preference: $bluetoothManager.preferences.alertTimeout)
                        .navigationBarBackButtonHidden()
                } label: {
                    textfieldDisclosure(title: alertTimeoutTitle, currentValue: String(bluetoothManager.preferences.alertTimeout), footer: alertTimeoutFooter)
                }
                // ALERT DELAY
                NavigationLink {
                    PreferenceNumberEntryView(title: alertDelayTitle, footer: alertDelayFooter, preference: $bluetoothManager.preferences.alertDelay)
                        .navigationBarBackButtonHidden()
                } label: {
                    textfieldDisclosure(title: alertDelayTitle, currentValue: String(bluetoothManager.preferences.alertDelay), footer: alertDelayFooter)
                }
                // OLED MAX BRIGHTNESS
                NavigationLink {
                    PreferenceNumberEntryView(title: oledMaxBrightnessTitle, footer: oledMaxBrightnessFooter, preference: $bluetoothManager.preferences.oledMaxBrightness)
                        .navigationBarBackButtonHidden()
                } label: {
                    textfieldDisclosure(title: oledMaxBrightnessTitle, currentValue: String(bluetoothManager.preferences.oledMaxBrightness), footer: oledMaxBrightnessFooter)
                }
                // SIP SIZE
                NavigationLink {
                    PreferenceNumberEntryView(title: sipSizeTitle, footer: sipSizeFooter, preference: $bluetoothManager.preferences.sipSize)
                        .navigationBarBackButtonHidden()
                } label: {
                    textfieldDisclosure(title: sipSizeTitle, currentValue: String(bluetoothManager.preferences.sipSize), footer: sipSizeFooter)
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
