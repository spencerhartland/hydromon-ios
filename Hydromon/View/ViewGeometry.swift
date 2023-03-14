//
//  ViewGeometry.swift
//  Hydromon
//
//  Created by Spencer Hartland on 3/5/23.
//

import SwiftUI

struct ViewSizeKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct ViewGeometry: View {
    var body: some View {
        GeometryReader { geo in
            Color.clear
                .preference(key: ViewSizeKey.self, value: geo.size)
        }
    }
}
