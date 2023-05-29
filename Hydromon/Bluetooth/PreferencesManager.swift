//
//  PreferencesManager.swift
//  Hydromon
//
//  Created by Spencer Hartland on 5/28/23.
//

import Foundation
import CoreBluetooth

enum PreferencesManagerError: Error {
    case InvalidPreferenceID
}

/// Manages a collection of user preferences.
class PreferencesManager {
    private var preferences: [CBUUID: String] = [:]
    
    /// Provides functionality for adding or modifying preference values to the collection.
    public func update(preference id: CBUUID, value: String) {
        preferences[id] = value
    }
    
    /**
     Returns the value of the preference with the specified UUID. If the UUID is not
     present within the collection, throws an `InvalidPreferenceID` error.
     
     - Returns: The value of the preference with the specified UUID
     */
    public func getValue(for preference: CBUUID) throws -> String {
        guard let value = preferences[preference] else {
            throw PreferencesManagerError.InvalidPreferenceID
        }
        return value
    }
}
