//
//  BluetoothManager.swift
//  Hydromon
//
//  Created by Spencer Hartland on 5/2/23.
//

import Foundation
import CoreBluetooth

class BluetoothManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    private let devInfoServiceUUID = CBUUID(string: "180A")
    private let modelNumUUID = CBUUID(string: "2A24")
    private let prefsJSONUUID = CBUUID(string: "29794ca0-0950-40a9-a415-a51c48e42a65")
    private let hydromonDeviceName = "hydromon"
    
    @Published var centralManager: CBCentralManager!
    @Published var peripheral: CBPeripheral!
    
    @Published var isSwitchedOn = false
    @Published var peripherals = [Peripheral]()
    @Published var isConnected: Bool = false
    @Published var batteryLevel: Int?
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            isSwitchedOn = true
        } else {
            isSwitchedOn = false
        }
    }
    
    func startScanning() {
        if isSwitchedOn {
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    
    func stopScanning() {
        centralManager.stopScan()
    }
    
    func connect(peripheral: CBPeripheral) {
        self.peripheral = peripheral
        self.peripheral.delegate = self
        centralManager.connect(peripheral, options: nil)
    }
    
    func write(_ value: String, for characteristic: CBCharacteristic) {
        if let data = value.data(using: .utf8) {
            self.peripheral.writeValue(data, for: characteristic, type: .withResponse)
        } else {
            print("Error getting data from string.")
        }
    }
    
    // CBCentralManagerDelegate
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let newPeripheral = Peripheral(id: UUID(), peripheral: peripheral)
        if let deviceName = peripheral.name {
            if deviceName == hydromonDeviceName {
                peripherals.append(newPeripheral)
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if peripheral == self.peripheral {
            print("Connected to your Hydromon")
            peripheral.discoverServices(nil)
        }
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Failed to connect to \(peripheral.name ?? "unknown"): \(error?.localizedDescription ?? "unknown error")")
    }
    
    // CBPeripheralDelegate
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print("Error discovering services: \(error.localizedDescription)")
            return
        }
        
        if let services = peripheral.services {
            print("Number of services \(services.count)")
            for service in services {
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error {
            print("Error discovering characteristics: \(error.localizedDescription)")
            return
        }
        
        for characteristic in service.characteristics ?? [] {
            print("Discovered characteristic: \(characteristic)")
            // Do stuff with characteristics: read, write, etc.
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
            if let error = error {
                print("Error reading value for characteristic: \(error.localizedDescription)")
                return
            }
            
            if let data = characteristic.value {
                let dataString = String(data: data, encoding: .utf8) ?? ""
                print("New value: \(dataString)")
                // Do something with the new value
            }
        }
}
