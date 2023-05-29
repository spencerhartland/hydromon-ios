//
//  HydromonServices.swift
//  Hydromon
//
//  Created by Spencer Hartland on 5/11/23.
//

import Foundation
import CoreBluetooth

struct HydromonUUIDs {
    struct DeviceInformation {
        static let serviceID = CBUUID(string: "180A")
        static let manufacturersNameID = CBUUID(string: "2A29")
        static let modelNumberID = CBUUID(string: "2A24")
        static let firmwareRevisionID = CBUUID(string: "2A26")
        static let softwareRevisionID = CBUUID(string: "2A28")
    }
    
    struct Preferences {
        static let serviceID = CBUUID(string: "3302752a-7beb-4888-b085-e11754996bb2")
        static let lcdStandbyMessageID = CBUUID(string: "4a91052a-662d-47ca-b0aa-f07027740024")
        static let lcdAlertMessageID = CBUUID(string: "a54cb484-e60e-4d12-8a5a-496d037d98d4")
        static let lcdStandbyColorID = CBUUID(string: "29794ca0-0950-40a9-a415-a51c48e42a65")
        static let lcdAlertColorID = CBUUID(string: "d46d5a24-ea99-4d8b-97f0-3ddeafbaeaa1")
        static let ledStandbyColorID = CBUUID(string: "7188af7a-2e34-4601-8b9f-86c870e7fa75")
        static let ledAlertColorID = CBUUID(string: "66158896-dc53-49af-8939-b199f967ecb6")
        static let standbyTimeoutID = CBUUID(string: "305709aa-36d6-4fa1-a2cc-7a3500bcbacb")
        static let alertTimeoutID = CBUUID(string: "8c995b1b-42a6-417d-9c0f-73f1763b8c38")
        static let alertDelayID = CBUUID(string: "18aea917-aab1-470f-8585-56554ecf238e")
        static let oledMaxBrightnessID = CBUUID(string: "944b859f-3a45-4fbd-80c5-186a1c6ec4bf")
        static let sipSizeID = CBUUID(string: "0795115d-6604-4dad-abb8-21290b91d256")
    }
}
