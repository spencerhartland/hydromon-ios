//
//  BluetoothManager.swift
//  Hydromon
//
//  Created by Spencer Hartland on 5/2/23.
//

import Foundation
import CoreBluetooth
import UIKit

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
    @Published var preferences: PreferencesManager!
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        preferences = PreferencesManager(self.write)
        setupObservers()
    }
    
    // MARK: - BluetoothManager Public Methods
    
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
    
    /// Tell the central manager to retrieve previously connected peripherals and connect again automatically.
    func reconnect() {
        if let savedPeripheralIDString = UserDefaults.standard.string(forKey: deviceUUIDUserDefaultsKey),
           let savedPeripheralID = UUID(uuidString: savedPeripheralIDString) {
            let knownPeripherals = centralManager.retrievePeripherals(withIdentifiers: [savedPeripheralID])
            if knownPeripherals.count > 0 {
                self.peripheral = knownPeripherals[0]
                connect(peripheral: self.peripheral)
            }
        }
    }
    
    /// Tells the central manager to attempt to connect to the specified peripheral.
    func connect(peripheral: CBPeripheral) {
        peripheral.delegate = self
        centralManager.connect(peripheral, options: nil)
    }
    
    /// Tells the central manager to disconnect from the peripheral.
    func disconnect(peripheral: CBPeripheral) {
        centralManager.cancelPeripheralConnection(peripheral)
    }
    
    /// Writes the provided value to the specified characteristic.
    func write(_ value: String, to uuid: CBUUID) {
        print("write called")
        if let data = value.data(using: .utf8) {
            print("got data")
            do {
                let characteristic = try characteristics.getCharacteristic(with: uuid)
                print("attempting write, uuid: \(characteristic.uuid.uuidString)")
                self.peripheral.writeValue(data, for: characteristic, type: .withResponse)
            } catch {
                print("Invalid characteristic ID")
            }
        } else {
            print("Error getting data from string.")
        }
    }
    
    // MARK: - Lifecycle methods
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    @objc private func appWillEnterForeground() {
        reconnect()
    }
    
    @objc private func appWillResignActive() {
        print("App entering background")
        guard let peripheral = peripheral else {
            print("No peripheral to disconnect from.")
            return
        }
        print("Disconnecting from peripheral...")
        disconnect(peripheral: peripheral)
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
            let peripheralUUID = peripheral.identifier.uuidString
            UserDefaults.standard.set(peripheralUUID, forKey: deviceUUIDUserDefaultsKey)
            peripheral.discoverServices(nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        isConnected = false
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
                switch characteristic.uuid {
                case HydromonUUIDs.DeviceInformation.manufacturersNameID:
                    preferences.manufacturersName = value
                case HydromonUUIDs.DeviceInformation.modelNumberID:
                    preferences.modelNumber = value
                case HydromonUUIDs.DeviceInformation.firmwareRevisionID:
                    preferences.firmwareRevision = value
                case HydromonUUIDs.DeviceInformation.softwareRevisionID:
                    preferences.softwareRevision = value
                case HydromonUUIDs.Preferences.lcdStandbyMessageID:
                    preferences.lcdStandbyMessage = value
                case HydromonUUIDs.Preferences.lcdAlertMessageID:
                    preferences.lcdAlertMessage = value
                case HydromonUUIDs.Preferences.lcdStandbyColorID:
                    preferences.lcdStandbyColor = value
                case HydromonUUIDs.Preferences.lcdAlertColorID:
                    preferences.lcdAlertColor = value
                case HydromonUUIDs.Preferences.ledStandbyColorID:
                    preferences.ledStandbyColor = value
                case HydromonUUIDs.Preferences.ledAlertColorID:
                    preferences.ledAlertColor = value
                case HydromonUUIDs.Preferences.standbyTimeoutID:
                    preferences.standbyTimeout = Int(value) ?? 0
                case HydromonUUIDs.Preferences.alertTimeoutID:
                    preferences.alertTimeout = Int(value) ?? 0
                case HydromonUUIDs.Preferences.alertDelayID:
                    preferences.alertDelay = Int(value) ?? 0
                case HydromonUUIDs.Preferences.oledMaxBrightnessID:
                    preferences.oledMaxBrightness = Int(value) ?? 0
                case HydromonUUIDs.Preferences.sipSizeID:
                    preferences.sipSize = Int(value) ?? 0
                default:
                    // Unknown
                    if debug { print("Unknown characterisitc: \(characteristic.uuid)") }
                    break
                }
            } else {
                print("There was an error casting the characteristic's value as a String.")
            }
        }
    }
}
