//
//  ContentView-ViewModel.swift
//  Hydromon
//
//  Created by Spencer Hartland on 3/14/23.
//

import Foundation

extension ContentView {
    @MainActor class ViewModel: ObservableObject {
        private let httpRequestHandler = RequestHandler()
        
        @Published var connected = true // CHANGE to false
        @Published var preferences = PreferenceSet()
        
        func testConnection() {
            httpRequestHandler.testConnection { success, response in
                if !success {
                    print(response)
                    return
                }
                self.connected = true
            }
        }
        
        func updatePreference(_ preference: PreferenceSet.PreferenceKey, value: Any) {
            switch preference {
            case .LCDStandbyMessage:
                self.preferences.LCDStandbyMessage = value as! String
            case .LCDAlertMessage:
                self.preferences.LCDAlertMessage = value as! String
            case .LCDStandbyColor:
                self.preferences.LCDStandbyColor = value as! RGB
            case .LCDAlertColor:
                self.preferences.LCDAlertColor = value as! RGB
            case .LEDStandbyColor:
                self.preferences.LEDStandbyColor = value as! RGB
            case .LEDAlertColor:
                self.preferences.LEDAlertColor = value as! RGB
            case .standbyTimeout:
                self.preferences.standbyTimeout = value as! Int
            case .alertTimeout:
                self.preferences.alertTimeout = value as! Int
            case .alertDelay:
                self.preferences.alertDelay = value as! Int
            case .OLEDMaxBrightness:
                self.preferences.OLEDMaxBrightness = value as! Int
            case .sipSize:
                self.preferences.sipSize = value as! Int
            case .localNetworkSSID:
                self.preferences.localNetworkSSID = value as! String
            case .localNetworkPassword:
                self.preferences.localNetworkPassword = value as! String
            }
            return
        }
    }
}
