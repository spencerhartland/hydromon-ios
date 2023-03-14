//
//  BatterySOCView.swift
//  Hydromon
//
//  Created by Spencer Hartland on 3/9/23.
//

import SwiftUI

struct BatterySOCView: View {
    private let pointerSymbolName = "play.fill"

    @Binding var charging: Bool
    @Binding var batterySOC: Double
    
    var body: some View {
        Image(systemName: batterySymbolName())
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(Colors.primary)
    }
    
    private func batterySymbolName() -> String {
        if charging { return "battery.100.bolt" }
        
        if batterySOC <= 0.1 { return "battery.0"}
        else if batterySOC <= 0.25 { return "battery.25" }
        else if batterySOC <= 0.5 { return "battery.50" }
        else if batterySOC <= 0.75 { return "battery.75" }
        else { return "battery.100" }
    }
}

struct BatterySOCView_Previews: PreviewProvider {
    static var previews: some View {
        BatterySOCView(charging: .constant(false), batterySOC: .constant(1.0))
            .background {
                Colors.background
                    .ignoresSafeArea()
            }
    }
}
