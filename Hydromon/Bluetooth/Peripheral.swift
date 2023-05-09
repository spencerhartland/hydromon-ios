//
//  Peripheral.swift
//  Hydromon
//
//  Created by Spencer Hartland on 5/2/23.
//

import Foundation
import CoreBluetooth

/// A structure representing a Hydromon bluetooth peripheral
struct Peripheral: Identifiable, Equatable {
    let id: UUID
    let characteristics: [String: Any]
    var peripheral: CBPeripheral
    
    init(id: UUID, peripheral: CBPeripheral) {
        self.id = id
        self.peripheral = peripheral
        self.characteristics = [String: Any]()
    }

    static func ==(lhs: Peripheral, rhs: Peripheral) -> Bool {
        return lhs.id == rhs.id
    }
}
