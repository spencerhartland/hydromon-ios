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
    
    public func color() -> Color {
        return Color(red: Double(self.red / 255), green: Double(self.green / 255), blue: Double(self.blue / 255))
    }
}
