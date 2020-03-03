//
//  MapViewModels.swift
//  RSR Pechhulp
//
//  Created by Julia Zamaitat on 03.03.20.
//  Copyright © 2020 Julia Zamaitat. All rights reserved.
//

import UIKit

enum MapView {
  
  struct Request {
    var phoneNumber: String
  }
  
  struct Response {
    var phoneURL: NSURL
  }
  
  struct ViewModel {
    var phoneURL: URL
  }
}
