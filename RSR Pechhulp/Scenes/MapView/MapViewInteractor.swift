//
//  MapViewInteractor.swift
//  RSR Pechhulp
//
//  Created by Julia Zamaitat on 03.03.20.
//  Copyright © 2020 Julia Zamaitat. All rights reserved.
//

import UIKit

protocol MapViewInteractorInput {
  func makePhoneCall(_ request: MapView.Request)
}
 
protocol MapViewInteractorOutput{
  func presentPhoneCall(response: MapView.Response)
}
 
class MapViewInteractor: MapViewInteractorInput {
  var output: MapViewInteractorOutput!
  var worker: MapViewWorker!
 
  // MARK: Business logic
 
  func makePhoneCall(_ request: MapView.Request) {
    // NOTE: Create some Worker to do the work
 
//    worker = MapViewWorker()
//    worker.doSomeWork()
//
    // NOTE: Pass the result to the Presenter
    if let phoneURL = NSURL(string: ("tel://" + request.phoneNumber)) {
      let response = MapView.Response(phoneURL: phoneURL)
      output.presentPhoneCall(response: response)
    }
    
  }
  
}
