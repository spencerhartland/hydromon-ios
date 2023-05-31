//
//  HydromonApp.swift
//  Hydromon
//
//  Created by Spencer Hartland on 1/31/23.
//

import SwiftUI

@main
struct HydromonApp: App {
    @AppStorage(deviceUUIDUserDefaultsKey) var deviceUUID: String = ""
    @StateObject var bluetoothManager = BluetoothManager()
    @State var shouldShowControlView: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if deviceUUID.isEmpty || !shouldShowControlView {
                BluetoothConnectionView(bluetoothManager: bluetoothManager, shouldShowControlView: $shouldShowControlView)
            } else {
                ControlView(bluetoothManager: bluetoothManager, shouldShowControlView: $shouldShowControlView)
                    .background { Colors.background.ignoresSafeArea() }
                    .preferredColorScheme(.dark)
                    .onAppear {
                        bluetoothManager.reconnect()
                    }
            }
        }
    }
}
