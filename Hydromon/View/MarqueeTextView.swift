//
//  MarqueeTextView.swift
//  Hydromon
//
//  Created by Spencer Hartland on 3/4/23.
//

import SwiftUI

struct MarqueeTextView: View {
    private let spacing: CGFloat = 4
    let text: String
    
    @State private var animate: Bool = false
    @State private var contentSize: CGSize = .zero
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        ZStack {
            Text(text)
                .background(ViewGeometry())
                .onPreferenceChange(ViewSizeKey.self) {
                    contentSize = $0
                }
                .offset(x: animate ? -contentSize.width - spacing : 0, y: 0)
                .onAppear {
                    withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) {
                        animate = true
                    }
                }
                .padding(.trailing, spacing)
            
            Text(text)
                .offset(x: animate ? 0 : contentSize.width + spacing, y: 0)
                .padding(.trailing, spacing)
        }
        .foregroundColor(Colors.background)
        .font(Fonts.semibold(size: 14))
        .mask {
            Rectangle()
        }
    }
}

struct MarqueeTextView_Previews: PreviewProvider {
    static var previews: some View {
        MarqueeTextView("Hello")
    }
}
