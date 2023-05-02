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
        
        @Published var connected = false
        @Published var preferences = PreferenceSet()
        
        func testConnection() {
            httpRequestHandler.testConnection { success, response in
                if !success {
                    self.connected = false
                    return
                }
                self.connected = true
            }
        }
        
        func updatePreference(_ preference: PreferenceSet.PreferenceKey, value: Any) {
            switch preference {
            case .LCDStandbyMessage:
                self.preferences.LCDStandbyMessage = value as? String ?? ""
            case .LCDAlertMessage:
                self.preferences.LCDAlertMessage = value as? String ?? ""
            case .LCDStandbyColor:
                self.preferences.LCDStandbyColor = value as? RGB ?? RGB(red: 255, green: 255, blue: 255)
            case .LCDAlertColor:
                self.preferences.LCDAlertColor = value as? RGB ?? RGB(red: 255, green: 255, blue: 255)
            case .LEDStandbyColor:
                self.preferences.LEDStandbyColor = value as? RGB ?? RGB(red: 255, green: 255, blue: 255)
            case .LEDAlertColor:
                self.preferences.LEDAlertColor = value as? RGB ?? RGB(red: 255, green: 255, blue: 255)
            case .standbyTimeout:
                self.preferences.standbyTimeout = value as? Int ?? 0
            case .alertTimeout:
                self.preferences.alertTimeout = value as? Int ?? 0
            case .alertDelay:
                self.preferences.alertDelay = value as? Int ?? 0
            case .OLEDMaxBrightness:
                self.preferences.OLEDMaxBrightness = value as? Int ?? 0
            case .sipSize:
                self.preferences.sipSize = value as? Int ?? 0
            case .localNetworkSSID:
                self.preferences.localNetworkSSID = value as? String ?? ""
            case .localNetworkPassword:
                self.preferences.localNetworkPassword = value as? String ?? ""
            }
            uploadPreferences()
            return
        }
        
        func fetchPreferences() {
            httpRequestHandler.getPreferences { success, response in
                if !success {
                    print("Failed to fetch preferences.")
                    return
                }
                guard let jsonData = response.data(using: .utf8) else {
                    print("Failed to get data from server response.")
                    return
                }
                do {
                    self.preferences = try JSONDecoder().decode(PreferenceSet.self, from: jsonData)
                } catch {
                    print("Failed to decode preferences from server repsonse: \(error)")
                }
            }
        }
        
        private func uploadPreferences() {
            // Encode PreferenceSet to JSON
            do {
                let jsonData = try JSONEncoder().encode(self.preferences)
                httpRequestHandler.setPreferences(data: jsonData) { success, response in
                    print("Success: \(success)")
                }
            } catch {
                print("Error encoding preferences: \(error)")
            }
        }
    }
}
