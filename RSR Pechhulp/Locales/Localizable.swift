//
//  Localizable.swift
//  RSR Pechhulp
//
//  Created by Julia Zamaitat on 03.03.20.
//  Copyright © 2020 Julia Zamaitat. All rights reserved.
//

import Foundation

enum Localizable {
  
  enum MainMenu: String, LocalizableDelegate {
    case welcomeTitle
  }
  
  enum AboutPage: String, LocalizableDelegate {
    case title
    case aboutTextPt1
    case aboutTextPt2
  }
  
  enum MapView: String, LocalizableDelegate {
    case callNow
    case callNowConfirmation
    case cancel
    case costDescription
    case costTitle
    case locationDescription
    case locationTitle
    case noInternetConnection
    case noInternetConnectionMessage
    case gpsTurnedOff
    case gpsTurnedOffMessage
    case gpsDenied
    case gpsDeniedMessage
    case goToSettings
  }
  
}
