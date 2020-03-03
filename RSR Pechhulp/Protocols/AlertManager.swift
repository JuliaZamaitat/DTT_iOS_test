//
//  AlertManager.swift
//  RSR Pechhulp
//
//  Created by Julia Zamaitat on 03.03.20.
//  Copyright © 2020 Julia Zamaitat. All rights reserved.
//

import UIKit

public protocol AlertManager {
  
  func showAlert(title: String, message: String, actions: [UIAlertAction])
   
  func openAppPrivacySettings() -> UIAlertAction
  
}

