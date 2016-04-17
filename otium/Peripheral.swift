//
//  Peripheral.swift
//  otium
//
//  Created by 若林俊輔 on 2016/04/17.
//  Copyright © 2016年 p6iwi6q. All rights reserved.
//
import CoreBluetooth
import CoreLocation

class Peripheral: CBPeripheralManager {
    
    private static let sharedInstance = Peripheral()
    private let beaconIdentifier = Configuration.Identifier()
    private let uuidString = Configuration.UUID()
    private let major = Configuration.Major()
    private let minor = Configuration.Minor()
    
    static func startAdvertising() {
        sharedInstance.delegate = sharedInstance
    }
}


extension Peripheral: CBPeripheralManagerDelegate {
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .Unknown:
            print("Unknown")
        case .Resetting:
            print("Resetting")
        case .Unsupported:
            print("Unsupported")
        case .Unauthorized:
            print("Unauthorized")
        case .PoweredOff:
            print("PoweredOff")
        case .PoweredOn:
            print("PoweredOn")
            startAdvertisingWithPeripheralManager(peripheral)
        }
    }
    
    func peripheralManagerDidStartAdvertising(peripheral: CBPeripheralManager, error: NSError?) {
        if let error = error {
            print("Failed to start advertising with error:\(error)")
        } else {
            print("Start advertising")
        }
    }
    
    private func startAdvertisingWithPeripheralManager(manager: CBPeripheralManager) {
        guard let proximityUUID = NSUUID(UUIDString: uuidString) else {
            return
        }
        
        let beaconRegion = CLBeaconRegion(proximityUUID: proximityUUID, major: major, minor: minor, identifier: beaconIdentifier)
        let beaconPeripheralData: NSDictionary = beaconRegion.peripheralDataWithMeasuredPower(nil)
        manager.startAdvertising(beaconPeripheralData as? [String: AnyObject])
    }
}
