//
//  BluetoothTestView.swift
//  Hydromon
//
//  Created by Spencer Hartland on 5/2/23.
//

import SwiftUI

struct BluetoothTestView: View {
    @StateObject private var bluetoothManager = BluetoothManager()
    
    var body: some View {
        VStack {
            if bluetoothManager.isSwitchedOn {
                Button {
                    bluetoothManager.startScanning()
                } label: {
                    Text("Scan")
                }
                
                List(bluetoothManager.peripherals) { peripheral in
                    Button {
                        bluetoothManager.stopScanning()
                        peripheral.peripheral.delegate = bluetoothManager
                        bluetoothManager.connect(peripheral: peripheral.peripheral)
                    } label: {
                        Text(peripheral.peripheral.name ?? "Unknown")
                    }
                }
                
                if bluetoothManager.isConnected {
                    List(Array(bluetoothManager.preferences.keys), id: \.uuidString) { id in
                        Text("\(id) : \(bluetoothManager.preferences[id] ?? "Unknown")")
                    }
                }
            } else {
                Text("Bluetooth is not available.")
            }
        }
        .onAppear {
            bluetoothManager.centralManager.delegate = bluetoothManager
        }
    }
}

struct BluetoothTestView_Previews: PreviewProvider {
    static var previews: some View {
        BluetoothTestView()
    }
}
