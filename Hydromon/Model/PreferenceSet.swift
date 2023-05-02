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
    enum PreferenceKey: String, CodingKey {
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
    
    // Preference values
    /// The message displayed on the LCD when the device is awake during standby.
    var LCDStandbyMessage: String
    /// The message displayed on the LCD when the drink reminder alert is active.
    var LCDAlertMessage: String
    /// The color of the LCD backlight when the device is awake during standby.
    var LCDStandbyColor: RGB
    /// The color of the LCD backlight when the drink reminder alert is active.
    var LCDAlertColor: RGB
    /// The color of the LED  when the device is awake during standby.
    var LEDStandbyColor: RGB
    /// The color of the LED  when the drink reminder alert is active.
    var LEDAlertColor: RGB
    /// The amount of time in seconds that the device remains awake after being lifted during standby.
    var standbyTimeout: Int
    /// The amount of time in seconds that the drink reminder alert is active.
    var alertTimeout: Int
    /// The duration of time in seconds between drink reminder alerts.
    var alertDelay: Int
    /// The maximum brightness setting of the OLED. Maximum valid brightness is 255.
    var OLEDMaxBrightness: Int
    /// The average size of a single drink of water, in milliliters.
    var sipSize: Int
    /// The name of the device's local network.
    var localNetworkSSID: String
    /// The password to the device's local newtork.
    var localNetworkPassword: String
    
    init() {
        LCDStandbyMessage = ""
        LCDAlertMessage = ""
        LCDStandbyColor = .init(red: 255, green: 255, blue: 255)
        LCDAlertColor = .init(red: 255, green: 255, blue: 255)
        LEDStandbyColor = .init(red: 255, green: 255, blue: 255)
        LEDAlertColor = .init(red: 255, green: 255, blue: 255)
        standbyTimeout = 0
        alertTimeout = 0
        alertDelay = 0
        OLEDMaxBrightness = 0
        sipSize = 0
        localNetworkSSID = ""
        localNetworkPassword = ""
    }
    
    init(from decoder: Decoder) throws {
        // Root
        let container = try decoder.container(keyedBy: PreferenceKey.self)
        LCDStandbyMessage = try container.decode(String.self, forKey: .LCDStandbyMessage)
        LCDAlertMessage = try container.decode(String.self, forKey: .LCDAlertMessage)
        LCDStandbyColor = try container.decode(RGB.self, forKey: .LCDStandbyColor)
        LCDAlertColor = try container.decode(RGB.self, forKey: .LCDAlertColor)
        LEDStandbyColor = try container.decode(RGB.self, forKey: .LEDStandbyColor)
        LEDAlertColor = try container.decode(RGB.self, forKey: .LEDAlertColor)
        standbyTimeout = try container.decode(Int.self, forKey: .standbyTimeout)
        alertTimeout =  try container.decode(Int.self, forKey: .alertTimeout)
        alertDelay = try container.decode(Int.self, forKey: .alertDelay)
        OLEDMaxBrightness = try container.decode(Int.self, forKey: .OLEDMaxBrightness)
        sipSize = try container.decode(Int.self, forKey: .sipSize)
        localNetworkSSID = try container.decode(String.self, forKey: .localNetworkSSID)
        localNetworkPassword = try container.decode(String.self, forKey: .localNetworkPassword)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: PreferenceKey.self)
        try container.encode(LCDStandbyMessage, forKey: .LCDStandbyMessage)
        try container.encode(LCDAlertMessage, forKey: .LCDAlertMessage)
        try container.encode(LCDStandbyColor, forKey: .LCDStandbyColor)
        try container.encode(LCDAlertColor, forKey: .LCDAlertColor)
        try container.encode(LEDStandbyColor, forKey: .LEDStandbyColor)
        try container.encode(LEDAlertColor, forKey: .LEDAlertColor)
        try container.encode(standbyTimeout, forKey: .standbyTimeout)
        try container.encode(alertTimeout, forKey: .alertTimeout)
        try container.encode(alertDelay, forKey: .alertDelay)
        try container.encode(OLEDMaxBrightness, forKey: .OLEDMaxBrightness)
        try container.encode(sipSize, forKey: .sipSize)
        try container.encode(localNetworkSSID, forKey: .localNetworkSSID)
        try container.encode(localNetworkPassword, forKey: .localNetworkPassword)
    }
}
