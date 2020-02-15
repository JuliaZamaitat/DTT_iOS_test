//
//  Connectivity.swift
//  RSR Pechhulp
//
//  Created by Julia Zamaitat on 15.02.20.
//  Copyright © 2020 Julia Zamaitat. All rights reserved.
//

public protocol Connectivity {
  var reachability: Reachability { get }
  func checkInternetAccess()
}
