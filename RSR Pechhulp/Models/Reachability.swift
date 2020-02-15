//
//  Reachability.swift
//  RSR Pechhulp
//
//  Created by Julia Zamaitat on 14.02.20.
//  Copyright © 2020 Julia Zamaitat. All rights reserved.
//
// Resource used: https://stackoverflow.com/questions/30743408/check-for-internet-connection-with-swift

import SystemConfiguration

// I decided not to use the CocoaPods Reachability library for the sake of simplicity - the Connection now only gets checked once when the map view becomes
// visible
// Singleton
public class Reachability {
  
  private static var shared: Reachability?
  
  public class func getInstance() -> Reachability {
    if shared == nil {
      shared = Reachability()
    }
    return shared!
  }

  private init() {}

  // Checks cellular or WIFI connection for the device
  func isConnectedToNetwork() -> Bool {
    var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)

    let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
            SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
        }
    }
    
    var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
    if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
      return false
    }

    // Working for Cellular and WIFI
    let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
    let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
    let ret = (isReachable && !needsConnection)

    return ret
  }
}
