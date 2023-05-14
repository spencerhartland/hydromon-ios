//
//  ConnectionProblemView.swift
//  Hydromon
//
//  Created by Spencer Hartland on 2/16/23.
//

import Foundation
import SwiftUI

struct ConnectionProblemView: View {
    private let symbolName = "exclamationmark.triangle.fill"
    private let warningText = "WARNING"
    private let warningDescriptionText = "Unable to establish connection with your Hydromon via local network."
    private let notConnectedText = "[ NOT CONNECTED ]"
    private let buttonText = "RE-CONNECT"
    private let deviceIP = "172.20.10.11"
    
    private let action: () -> Void
    
    public init(_ action: @escaping () -> Void) {
        self.action = action
    }
    
    var body: some View {
        AlertPopupView(
            headerText: self.warningText,
            buttonText: self.buttonText,
            infoBarText: self.deviceIP,
            primaryColor: Color.red) {
                self.action()
            } content: {
                Image(systemName: symbolName)
                    .font(.system(size: 32))
                Text(notConnectedText)
                    .font(Fonts.semibold(size: 28))
                Text(warningDescriptionText.uppercased())
                    .font(Fonts.medium(size: 14))
                    .multilineTextAlignment(.center)
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
