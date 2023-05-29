//
//  BluetoothManager.swift
//  Hydromon
//
//  Created by Spencer Hartland on 5/2/23.
//

import Foundation
import CoreBluetooth

class BluetoothManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    private let hydromonDeviceName = "hydromon"
    
    // Central Bluetooth Manager
    private var centralManager: CBCentralManager!
    // CBCharacteristics for each preference
    private var characteristics = CharacteristicsManager()
    
    /// The `CBPeripheral` this device is connected to (a Hydromon).
    @Published var peripheral: CBPeripheral!
    /// A boolean vaue indicating whether or not Bluetooth is switched on.
    @Published var isSwitchedOn = false
    /// A boolean value indicating whether or not this device is connected to a Hydromon device.
    @Published var isConnected: Bool = false
    /// An instance of `PreferencesManager` which manages a collection of user preferences.
    @Published var preferences = PreferencesManager()
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    // MARK: - BluetoothManager
    
    /// Tells the central manager to begin scanning for peripherals.
    func startScanning() {
        if isSwitchedOn {
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    
    /// Tells the central manager to stop scanning for peripherals. This should be called once the desired peripheral has been discovered.
    func stopScanning() {
        centralManager.stopScan()
    }
    
    /// Tells the central manager to attempt to connect to the specified peripheral.
    func connect(peripheral: CBPeripheral) {
        self.peripheral.delegate = self
        centralManager.connect(peripheral, options: nil)
    }
    
    /// Writes the provided value to the specified characteristic.
    func write(_ value: String, to uuid: CBUUID) {
        if let data = value.data(using: .utf8) {
            do {
                let characteristic = try characteristics.getCharacteristic(with: uuid)
                self.peripheral.writeValue(data, for: characteristic, type: .withoutResponse)
            } catch {
                print("Invalid characteristic ID")
            }
        } else {
            print("Error getting data from string.")
        }
    }
    
    // MARK: - CBCentralManagerDelegate
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            isSwitchedOn = true
        } else {
            isSwitchedOn = false
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if let deviceName = peripheral.name {
            if deviceName == hydromonDeviceName {
                self.peripheral = peripheral
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if peripheral == self.peripheral {
            if debug { print("Connected to your Hydromon") }
            isConnected = true
            peripheral.discoverServices(nil)
        }
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Failed to connect to \(peripheral.name ?? "unknown"): \(error?.localizedDescription ?? "unknown error")")
    }
    
    // MARK: - CBPeripheralDelegate
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print("Error discovering services: \(error.localizedDescription)")
            return
        }
        
        if let services = peripheral.services {
            if debug { print("Number of services \(services.count)") }
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
            // Store reference to each characteristic so it can later be written to
            self.characteristics.update(characteristic, withID: characteristic.uuid)
            if characteristic.properties.contains(.read) {
                if debug { print("Attempting to read value for characteristic: \(characteristic.uuid)") }
                peripheral.readValue(for: characteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("Error reading value for characteristic: \(error.localizedDescription)")
            return
        }
        
        if let data = characteristic.value {
            if let value = String(data: data, encoding: .utf8) {
                if debug { print("Value: \(value)") }
                preferences.update(preference: characteristic.uuid, value: value)
            } else {
                print("There was an error casting the characteristic's value as a String.")
            }
        }
    }
}
