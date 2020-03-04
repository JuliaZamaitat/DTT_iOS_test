//
//  AlertManager.swift
//  RSR Pechhulp
//
//  Created by Julia Zamaitat on 03.03.20.
//  Copyright © 2020 Julia Zamaitat. All rights reserved.
//

import UIKit

public protocol AlertManager {
  
  
  /** Shows an alert based on the provided parameters
    
    - Parameters:
        - title: A string containing the title of the alert
        - message: A string containing a descriptive message of the alert
        - actions: a collection of actiosn that can be taken when the user taps a button in an alert.
  */
  func showAlert(title: String, message: String, actions: [UIAlertAction])
   
  
  /** Opens the privacy settings for localisation of the app on the device
     
     - Returns: the action which opens the privacy settings
   */
  func openAppPrivacySettings() -> UIAlertAction
  
}

