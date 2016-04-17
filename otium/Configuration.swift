//
//  Configuration.swift
//  otium
//
//  Created by 若林俊輔 on 2016/04/18.
//  Copyright © 2016年 p6iwi6q. All rights reserved.
//

/// Get the singleton object.

import Foundation
import CoreLocation

class Configuration
{
    private static let _UUID = "aaaabbbb-aaaa-aaaa-aaaa-aaaabbbbcccc"
    private static let _identifier = "pj7.link"
    private static let _major = CLBeaconMajorValue(arc4random() % 100)
    private static let _minor = CLBeaconMinorValue(arc4random() % 3)
    
    class func UUID() -> String {
        return self._UUID
    }
    class func Identifier() -> String {
        return self._identifier
    }
    class func Major() ->  CLBeaconMajorValue{
        return self._major
    }
    class func Minor() -> CLBeaconMinorValue{
        return self._minor
    }
    
    private init() {}
}