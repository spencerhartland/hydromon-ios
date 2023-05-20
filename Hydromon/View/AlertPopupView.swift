//
//  AlertPopupView.swift
//  Hydromon
//
//  Created by Spencer Hartland on 5/14/23.
//

import Foundation
import SwiftUI

struct AlertPopupView<Content: View>: View {
    private let headerBarImageName = "HeaderBar"
    private let buttonBackgroundImageName = "ButtonBackground"
    
    private let headerText: String
    private let buttonText: String?
    private let infoBarText: String
    private let primaryColor: Color
    private let secondaryColor: Color
    private let action: (() -> Void)?
    private let content: () -> Content
    
    public init(
        headerText: String,
        buttonText: String? = nil,
        infoBarText: String = "",
        primaryColor: Color = Colors.primary,
        secondaryColor: Color = Colors.primary,
        _ action: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content) {
            self.headerText = headerText
            self.buttonText = buttonText
            self.infoBarText = infoBarText
            self.primaryColor = primaryColor
            self.secondaryColor = secondaryColor
            self.action = action
            self.content = content
    }
    
    var body: some View {
        VStack {
            // Header
            Image(headerBarImageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(self.primaryColor)
                .glow(self.primaryColor, intensity: 0.5)
                .overlay {
                    HStack {
                        Text(headerText)
                            .font(Fonts.semibold(size: 16))
                            .foregroundColor(Colors.background)
                        Spacer()
                    }
                    .padding([.top, .leading], 6)
                }
            
            // Content
            VStack {
                self.content()
            }
            .padding(8)
            .glow(self.primaryColor, intensity: 0.75)
            
            // Bottom bar
            HStack(alignment: .top, spacing: 4) {
                if let buttonText = self.buttonText,
                    let buttonAction = self.action {
                    Button {
                        buttonAction()
                    } label: {
                        ZStack {
                            Image(buttonBackgroundImageName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 144)
                                .foregroundColor(self.secondaryColor)
                                .glow(self.secondaryColor, intensity: 0.75)
                            Text(buttonText)
                                .foregroundColor(Colors.background)
                                .font(Fonts.semibold(size: 14))
                                .padding(.trailing, 16)
                        }
                    }
                }
                HStack {
                    Spacer()
                    Text(infoBarText)
                        .font(Fonts.regular(size: 12))
                        .padding(.vertical, 1)
                        .padding(.trailing, 8)
                }
                .foregroundColor(Colors.background)
                .background { self.primaryColor }
                .glow(self.primaryColor, intensity: 0.5)
            }
        }
        .foregroundColor(self.primaryColor)
        .background {
            self.primaryColor.opacity(0.25)
                .padding(.top, 8)
                .padding(.bottom, self.action != nil ? 36 : 0)
        }
    }
}
