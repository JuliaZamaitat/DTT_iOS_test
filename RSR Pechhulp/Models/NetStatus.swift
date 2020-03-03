//
//  NetStatus.swift
//  RSR Pechhulp
//
//  Created by Julia Zamaitat on 03.03.20.
//  Copyright © 2020 Julia Zamaitat. All rights reserved.
//

import Network

class NetStatus {
  static let shared = NetStatus()
  private init(){}
  
  deinit {
      stopMonitoring()
  }
  
  var monitor: NWPathMonitor?
  
  var isMonitoring = false
  
  var netStatusChangeHandler: (() -> Void)?

  var isConnected: Bool {
      guard let monitor = monitor else { return false }
      return monitor.currentPath.status == .satisfied
  }
  
  func startMonitoring() {
      guard !isMonitoring else { return }
      print("starting monitoring")
      monitor = NWPathMonitor()
      let queue = DispatchQueue(label: "NetStatus_Monitor")
      monitor?.start(queue: queue)
   
      monitor?.pathUpdateHandler = { _ in
          self.netStatusChangeHandler?()
      }
   
      isMonitoring = true
     
  }
  

  func stopMonitoring() {
      guard isMonitoring, let monitor = monitor else { return }
      monitor.cancel()
      self.monitor = nil
      isMonitoring = false
  }
  
  
}
