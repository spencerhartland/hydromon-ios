//
//  RGB.swift
//  Hydromon
//
//  Created by Spencer Hartland on 3/16/23.
//

import Foundation
import SwiftUI

struct RGB: Codable {
    var red: Int
    var green: Int
    var blue: Int
    
    public init(red: Int, green: Int, blue: Int) {
        self.red = red
        self.green = green
        self.blue = blue
    }
    
    public init(from hexString: String) {
        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)
        
        self.red = Int((rgbValue & 0xFF0000) >> 16)
        self.green = Int((rgbValue & 0x00FF00) >> 8)
        self.blue = Int(rgbValue & 0x0000FF)
    }
    
    public func color() -> Color {
        return Color(red: (Double(self.red) / 255), green: (Double(self.green) / 255), blue: (Double(self.blue) / 255))
    }
    
    public func hexString() -> String {
        return String(format: "%02X%02X%02X", self.red, self.green, self.blue)
    }
}
