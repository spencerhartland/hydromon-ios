//
//  PreferencesManager.swift
//  Hydromon
//
//  Created by Spencer Hartland on 5/28/23.
//

import Foundation
import CoreBluetooth

/// Manages a collection of user preferences.
class PreferencesManager: ObservableObject {
    private static let defaultString = ""
    private static let defaultColor = "ffffff"
    private static let defaultInt = 0
    
    @Published var manufacturersName: String = defaultString
    @Published var modelNumber: String = defaultString
    @Published var firmwareRevision: String = defaultString
    @Published var softwareRevision: String = defaultString
    @Published var lcdStandbyMessage: String = defaultString {
        didSet {
            if oldValue != lcdStandbyMessage && oldValue != PreferencesManager.defaultString {
                if let onPreferenceUpdate = onPreferenceUpdate {
                    onPreferenceUpdate(lcdStandbyMessage, HydromonUUIDs.Preferences.lcdStandbyMessageID)
                }
            }
        }
    }
    @Published var lcdAlertMessage: String = defaultString {
        didSet {
            if oldValue != lcdAlertMessage && oldValue != PreferencesManager.defaultString {
                if let onPreferenceUpdate = onPreferenceUpdate {
                    onPreferenceUpdate(lcdAlertMessage, HydromonUUIDs.Preferences.lcdAlertMessageID)
                }
            }
        }
    }
    @Published var lcdStandbyColor: String = defaultColor {
        didSet {
            print("didSet called")
            if oldValue != lcdStandbyColor && oldValue != PreferencesManager.defaultColor {
                print("Old value: \(oldValue), new value: \(lcdStandbyColor)")
                if let onPreferenceUpdate = onPreferenceUpdate {
                    print("calling onPreferenceUpdate...")
                    onPreferenceUpdate(lcdStandbyColor, HydromonUUIDs.Preferences.lcdStandbyColorID)
                }
            }
        }
    }
    @Published var lcdAlertColor: String = defaultColor {
        didSet {
            if oldValue != lcdAlertColor && oldValue != PreferencesManager.defaultColor {
                if let onPreferenceUpdate = onPreferenceUpdate {
                    onPreferenceUpdate(lcdAlertColor, HydromonUUIDs.Preferences.lcdAlertColorID)
                }
            }
        }
    }
    @Published var ledStandbyColor: String = defaultColor {
       didSet {
           if oldValue != ledStandbyColor && oldValue != PreferencesManager.defaultColor {
               if let onPreferenceUpdate = onPreferenceUpdate {
                   onPreferenceUpdate(ledStandbyColor, HydromonUUIDs.Preferences.ledStandbyColorID)
               }
           }
       }
    }
    @Published var ledAlertColor: String = defaultColor {
        didSet {
            if oldValue != ledAlertColor && oldValue != PreferencesManager.defaultColor {
                if let onPreferenceUpdate = onPreferenceUpdate {
                    onPreferenceUpdate(ledAlertColor, HydromonUUIDs.Preferences.ledAlertColorID)
                }
            }
        }
    }
    @Published var standbyTimeout: Int = defaultInt {
        didSet {
            if oldValue != standbyTimeout && oldValue != PreferencesManager.defaultInt {
                if let onPreferenceUpdate = onPreferenceUpdate {
                    onPreferenceUpdate(String(standbyTimeout), HydromonUUIDs.Preferences.standbyTimeoutID)
                }
            }
        }
    }
    @Published var alertTimeout: Int = defaultInt {
        didSet {
            if oldValue != alertTimeout && oldValue != PreferencesManager.defaultInt {
                if let onPreferenceUpdate = onPreferenceUpdate {
                    onPreferenceUpdate(String(alertTimeout), HydromonUUIDs.Preferences.alertTimeoutID)
                }
            }
        }
    }
    @Published var alertDelay: Int = defaultInt {
        didSet {
            if oldValue != alertDelay && oldValue != PreferencesManager.defaultInt {
                if let onPreferenceUpdate = onPreferenceUpdate {
                    onPreferenceUpdate(String(alertDelay), HydromonUUIDs.Preferences.alertDelayID)
                }
            }
        }
    }
    @Published var oledMaxBrightness: Int = defaultInt {
        didSet {
            if oldValue != oledMaxBrightness && oldValue != PreferencesManager.defaultInt {
                if let onPreferenceUpdate = onPreferenceUpdate {
                    onPreferenceUpdate(String(oledMaxBrightness), HydromonUUIDs.Preferences.oledMaxBrightnessID)
                }
            }
        }
    }
    @Published var sipSize: Int = defaultInt {
        didSet {
            if oldValue != sipSize && oldValue != PreferencesManager.defaultInt {
                if let onPreferenceUpdate = onPreferenceUpdate {
                    onPreferenceUpdate(String(sipSize), HydromonUUIDs.Preferences.sipSizeID)
                }
            }
        }
    }
    
    let onPreferenceUpdate: ((String, CBUUID) -> Void)?
    
    public init(_ handler: ((String, CBUUID) -> Void)? = nil) {
        self.onPreferenceUpdate = handler
    }
}
