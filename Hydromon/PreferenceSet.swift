//
//  PreferenceSet.swift
//  Hydromon
//
//  Created by Spencer Hartland on 2/9/23.
//

import Foundation

/**
 A set of user preferences regarding system settings such as LCD backlight color and message, LED color, and timeouts.
 */
struct PreferenceSet: Codable {
    // CodingKeys for decoding from JSON with Python-style names
    enum PreferenceKeys: String, CodingKey {
        case LCDStandbyMessage = "lcd-standby-message"
        case LCDAlertMessage = "lcd-alert-message"
        case LCDStandbyColor = "lcd-standby-color"
        case LCDAlertColor = "lcd-alert-color"
        case LEDStandbyColor = "led-standby-color"
        case LEDAlertColor = "led-alert-color"
        case standbyTimeout = "standby-timeout"
        case alertTimeout =  "alert-timeout"
        case alertDelay = "alert-delay"
        case OLEDMaxBrightness = "oled-max-brightness"
        case sipSize = "sip-size"
        case localNetworkSSID = "local-network-ssid"
        case localNetworkPassword = "local-network-password"
    }
    
    enum RGBKeys: String, CodingKey {
        case red, green, blue
    }
    
    // Preference values
    /// The message displayed on the LCD when the device is awake during standby.
    let LCDStandbyMessage: String
    /// The message displayed on the LCD when the drink reminder alert is active.
    let LCDAlertMessage: String
    /// The color of the LCD backlight when the device is awake during standby.
    let LCDStandbyColor: RGB
    /// The color of the LCD backlight when the drink reminder alert is active.
    let LCDAlertColor: RGB
    /// The color of the LED  when the device is awake during standby.
    let LEDStandbyColor: RGB
    /// The color of the LED  when the drink reminder alert is active.
    let LEDAlertColor: RGB
    /// The amount of time in seconds that the device remains awake after being lifted during standby.
    let standbyTimeout: Int
    /// The amount of time in seconds that the drink reminder alert is active.
    let alertTimeout: Int
    /// The duration of time in seconds between drink reminder alerts.
    let alertDelay: Int
    /// The maximum brightness setting of the OLED. Maximum valid brightness is 255.
    let OLEDMaxBrightness: Int
    /// The average size of a single drink of water, in milliliters.
    let sipSize: Int
    /// The name of the device's local network.
    let localNetworkSSID: String
    /// The password to the device's local newtork.
    let localNetworkPassword: String
    
    struct RGB: Codable {
        let red: Int
        let green: Int
        let blue: Int
    }
}

extension PreferenceSet {
    init(from decoder: Decoder) throws {
        // Root
        let root = try decoder.container(keyedBy: PreferenceKeys.self)
        LCDStandbyMessage = try root.decode(String.self, forKey: .LCDStandbyMessage)
        LCDAlertMessage = try root.decode(String.self, forKey: .LCDAlertMessage)
        LCDStandbyColor = try root.decode(RGB.self, forKey: .LCDStandbyColor)
        LCDAlertColor = try root.decode(RGB.self, forKey: .LCDAlertColor)
        LEDStandbyColor = try root.decode(RGB.self, forKey: .LEDStandbyColor)
        LEDAlertColor = try root.decode(RGB.self, forKey: .LEDAlertColor)
        standbyTimeout = try root.decode(Int.self, forKey: .standbyTimeout)
        alertTimeout =  try root.decode(Int.self, forKey: .alertTimeout)
        alertDelay = try root.decode(Int.self, forKey: .alertDelay)
        OLEDMaxBrightness = try root.decode(Int.self, forKey: .OLEDMaxBrightness)
        sipSize = try root.decode(Int.self, forKey: .sipSize)
        localNetworkSSID = try root.decode(String.self, forKey: .localNetworkSSID)
        localNetworkPassword = try root.decode(String.self, forKey: .localNetworkPassword)
    }
    
    init() {
        LCDStandbyMessage = "go vegan or die!" // CHANGE BACK TO ""
        LCDAlertMessage = ""
        LCDStandbyColor = .init(red: 0, green: 0, blue: 0)
        LCDAlertColor = .init(red: 0, green: 0, blue: 0)
        LEDStandbyColor = .init(red: 0, green: 0, blue: 0)
        LEDAlertColor = .init(red: 0, green: 0, blue: 0)
        standbyTimeout = 0
        alertTimeout = 0
        alertDelay = 0
        OLEDMaxBrightness = 0
        sipSize = 0
        localNetworkSSID = ""
        localNetworkPassword = ""
    }
}
