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
    var major: CLBeaconMajorValue = 1
    var minor: CLBeaconMajorValue = 1
    
    
    
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
        
        setUserInfo()
        
        let beaconRegion = CLBeaconRegion(proximityUUID: proximityUUID, major: major, minor: minor, identifier: beaconIdentifier)
        let beaconPeripheralData: NSDictionary = beaconRegion.peripheralDataWithMeasuredPower(nil)
        manager.startAdvertising(beaconPeripheralData as? [String: AnyObject])
    }
    
    func setUserInfo(){
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        //前回の保存内容があるかどうかを判定
        if((defaults.objectForKey("otium_major")) != nil){
            //objectsを配列として確定させ、前回の保存内容を格納
            major = CLBeaconMajorValue((defaults.objectForKey("otium_major")! as! String))!
            print("periperal : Major : \(major)")
        }else{
            print("error : periperal : nil : Major")
        }
        if((defaults.objectForKey("otium_minor")) != nil){
            minor = CLBeaconMinorValue((defaults.objectForKey("otium_minor")! as! String))!
            print("periperal : Minorr:\(minor)")
        }else{
            print("error : periperal : nil:Minor")
        }
        //  connectFirebase.inital_set(otium_major+otium_minor)
        //   connectFirebase.set_major(otium_major)
        //   connectFirebase.set_minor(otium_minor)
    }

}

