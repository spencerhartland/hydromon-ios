//
//  HighlightViewModifer.swift
//  Hydromon
//
//  Created by Spencer Hartland on 3/6/23.
//

import SwiftUI

private struct HighlightViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            VStack {
                Spacer()
                Colors.highlight
                    .frame(height: 6)
                    .cornerRadius(6)
                    .blur(radius: 2)
            }
            content
        }
    }
}

extension View {
    public func highlight() -> some View {
        modifier(HighlightViewModifier())
    }
}
