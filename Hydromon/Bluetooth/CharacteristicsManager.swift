//
//  CharacteristicsManager.swift
//  Hydromon
//
//  Created by Spencer Hartland on 5/28/23.
//

import Foundation
import CoreBluetooth

extension BluetoothManager {
    enum CharacteristicsManagerError: Error {
        case InvalidCharacteristicID
    }
    
    class CharacteristicsManager {
        private var characteristics: [CBUUID: CBCharacteristic] = [:]
        
        /// Provides functionality for adding / modifying characteristics to / in the collection.
        public func update(_ characteristic: CBCharacteristic, withID id: CBUUID) {
            characteristics[id] = characteristic
        }
        
        /**
         Returns the `CBCharacteristic` with the specified UUID. If the UUID is not
         present within the collection, throws an `InvalidCharacteristicID` error.
         
         - Returns: The `CBCharacteristic` with the specified UUID.
         */
        public func getCharacteristic(with id: CBUUID) throws -> CBCharacteristic {
            guard let char = characteristics[id] else {
                throw CharacteristicsManagerError.InvalidCharacteristicID
            }
            return char
        }
    }
}
