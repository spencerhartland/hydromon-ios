//
//  AppConstants.swift
//  Hydromon
//
//  Created by Spencer Hartland on 2/15/23.
//

import Foundation
import SwiftUI

struct Colors {
    /// Electric Pink. A very bright purplish pink.
    static let accent = Color(red: 17/255, green: 235/255, blue: 247/255)
    /// Deep Pink. A dim purplish pink.
    static let secondaryAccent = Color(red: 125/255, green: 2/255, blue: 158/255)
    /// Not Quite White (TM).
    static let primary = Color(red: 207/255, green: 207/255, blue: 207/255)
    /// Gray-ish white
    static let secondary = Color(red: 135/255, green: 135/255, blue: 135/255)
    /// Dark Teal. A very dark, cool shade of teal.
    static let tertiary = Color(red: 2/255, green: 125/255, blue: 138/255)
    /// Highlight to be applied on background
    static let highlight = Color(red: 65/255, green: 65/255, blue: 65/255)
    /// Lighter Charcoal.
    static let background = Color(red: 4/255, green: 4/255, blue: 4/255)
    /// Deep Charcoal.
    static let secondaryBackground = Color(red: 24/255, green: 24/255, blue: 24/255)
}

struct Fonts {
    /// Rajdhani-Bold
    public static func bold(size: CGFloat) -> Font {
        return Font.custom("Rajdhani-Bold", size: size)
    }
    /// Rajdhani-Light
    public static func light(size: CGFloat) -> Font {
        return Font.custom("Rajdhani-Light", size: size)
    }
    /// Rajdhani-Medium
    public static func medium(size: CGFloat) -> Font {
        return Font.custom("Rajdhani-Medium", size: size)
    }
    /// Rajdhani-Regular
    public static func regular(size: CGFloat) -> Font {
        return Font.custom("Rajdhani-Regular", size: size)
    }
    /// Rajdhani-SemiBold
    public static func semibold(size: CGFloat) -> Font {
        return Font.custom("Rajdhani-SemiBold", size: size)
    }
}
