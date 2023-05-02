//
//  ConnectionProblemView.swift
//  Hydromon
//
//  Created by Spencer Hartland on 2/16/23.
//

import Foundation
import SwiftUI

struct ConnectionProblemView: View {
    private let headerBarImageName = "HeaderBar"
    private let symbolName = "exclamationmark.triangle.fill"
    private let warningText = "WARNING"
    private let warningDescriptionText = "Unable to establish connection with your Hydromon via local network."
    private let notConnectedText = "[ NOT CONNECTED ]"
    private let buttonBackgroundImageName = "ButtonBackground"
    private let buttonText = "RE-CONNECT"
    private let deviceIP = "172.20.10.11"
    
    private let action: () -> Void
    
    public init(_ action: @escaping () -> Void) {
        self.action = action
    }
    
    var body: some View {
        VStack {
            // Warning header
            Image(headerBarImageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.red)
                .glow(.red, intensity: 0.5)
                .overlay {
                    HStack {
                        Text(warningText)
                            .font(Fonts.semibold(size: 16))
                            .foregroundColor(Colors.background)
                        Spacer()
                    }
                    .padding([.top, .leading], 6)
                }
            
            // Warning content
            VStack {
                Image(systemName: symbolName)
                    .font(.system(size: 32))
                Text(notConnectedText)
                    .font(Fonts.semibold(size: 28))
                Text(warningDescriptionText.uppercased())
                    .font(Fonts.medium(size: 14))
                    .multilineTextAlignment(.center)
            }
            .padding(8)
            .glow(.red, intensity: 0.75)
            
            // Bottom bar
            HStack(alignment: .top, spacing: 4) {
                Button {
                    action()
                } label: {
                    ZStack {
                        Image(buttonBackgroundImageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 144)
                            .foregroundColor(Colors.primary)
                            .glow(Colors.primary, intensity: 0.75)
                        Text(buttonText)
                            .foregroundColor(Colors.background)
                            .font(Fonts.semibold(size: 14))
                            .padding(.trailing, 16)
                    }
                }
                HStack {
                    Spacer()
                    Text(deviceIP)
                        .font(Fonts.regular(size: 12))
                        .padding(.vertical, 1)
                        .padding(.trailing, 8)
                }
                .foregroundColor(Colors.background)
                .background {
                    Color.red
                }
                .glow(.red, intensity: 0.5)
            }
        }
        .foregroundColor(.red)
        .background {
            Rectangle()
                .foregroundColor(.red.opacity(0.25))
                .padding(.top, 8)
                .padding(.bottom, 36)
        }
    }
}

struct ConnectionProblemView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Colors.background
                .ignoresSafeArea()
            ConnectionProblemView {
                print("hi")
            }
            .padding(32)
        }
    }
}
