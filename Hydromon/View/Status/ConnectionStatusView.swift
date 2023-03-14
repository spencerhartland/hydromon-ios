//
//  ConnectionStatusView.swift
//  Hydromon
//
//  Created by Spencer Hartland on 2/11/23.
//

import SwiftUI

struct ConnectionStatusView: View {
    private let symbolName = "drop.fill"
    private let connectedText = "Connected"
    private let notConnectedText = "Not Connected"
    
    @Binding var connected: Bool
    @State var connectionStatusIndicatorColor: Color
    // Animation
    @State var animate: Bool = false
    @State var fadeOutRadar: Bool = false
    
    init(_ connected: Binding<Bool>) {
        self._connected = connected
        self.connectionStatusIndicatorColor = connected.wrappedValue ? Colors.accent : .red
    }
    
    var body: some View {
        HStack(spacing: 2) {
            ZStack {
                Circle()
                    .foregroundColor(connectionStatusIndicatorColor.opacity(fadeOutRadar ? 0.0 : 0.5))
                    .frame(height: connected ? (animate ? 24 : 0) : 0)
                Image(systemName: symbolName)
                    .font(.system(size: 8))
                    .foregroundColor(connectionStatusIndicatorColor)
                    .glow(connectionStatusIndicatorColor)
                    .onAppear {
                        withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                            if connected { self.animate.toggle() }
                        }
                        withAnimation(.linear(duration: 0.75).delay(0.75).repeatForever(autoreverses: false)) {
                            if connected { self.fadeOutRadar.toggle() }
                        }
                    }
            }
            .frame(width: 24, height: 24)
            Text((connected ? connectedText : notConnectedText).uppercased())
                .font(.system(size: 8, weight: .bold, design: .monospaced))
                .foregroundColor(Colors.secondary)
        }
    }
}

struct ConnectionStatusView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionStatusView(.constant(true))
    }
}
