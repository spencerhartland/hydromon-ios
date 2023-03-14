//
//  GlowViewModifier.swift
//  Hydromon
//
//  Created by Spencer Hartland on 2/16/23.
//

import Foundation
import SwiftUI

struct GlowViewModifier: ViewModifier {
    let color: Color
    var intensity: Double
    
    init(_ color: Color, intensity: Double) {
        self.color = color
        self.intensity = intensity
    }
    
    func body(content: Content) -> some View {
        content
            .shadow(color: intensity > 1.0 ? self.color.opacity(intensity - 1.0) : .clear, radius: 8.0)
            .shadow(color: self.color.opacity(intensity), radius: 8.0)
            .shadow(color: self.color.opacity(0.33*intensity), radius: 2.0)
    }
}

extension View {
    public func glow(_ color: Color, intensity: Double = 1.0) -> some View {
        modifier(GlowViewModifier(color, intensity: intensity))
    }
}
