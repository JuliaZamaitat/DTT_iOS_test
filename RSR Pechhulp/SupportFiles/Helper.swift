//
//  Helper.swift
//  RSR Pechhulp
//
//  Created by Julia Zamaitat on 15.02.20.
//  Copyright © 2020 Julia Zamaitat. All rights reserved.
//

import UIKit

class Helper {
  
  // Shows a custom alert with custom or default actions
  static func showAlert(from controller: UIViewController, title: String, message: String, actions: [UIAlertAction] = []) {
    let alert = UIAlertController(title:title, message: message, preferredStyle: .alert)
    if !actions.isEmpty {
      for action in actions {
        alert.addAction(action)
      }
    } else {
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    }
    controller.present(alert, animated: true, completion: nil)
  }
  
  // Makes a view (in)visible with a smooth animation
  static func setView(_ view: UIView, hidden: Bool) {
    UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
      view.isHidden = hidden
    })
  }
  
  // Opens the privacy settings for localisation of the app on the device
  static func openAppPrivacySettings() -> UIAlertAction {
    let action = UIAlertAction(title: "Go to Settings now", style: .default, handler: { alert in
      guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
      UIApplication.shared.open(settingsUrl)
    }
    )
    return action
  }
}
