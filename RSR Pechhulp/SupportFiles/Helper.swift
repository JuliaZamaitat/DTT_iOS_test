//
//  Helper.swift
//  RSR Pechhulp
//
//  Created by Julia Zamaitat on 15.02.20.
//  Copyright © 2020 Julia Zamaitat. All rights reserved.
//

import Foundation
import UIKit

class Helper {
 
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
 
 static func setView(_ view: UIView, hidden: Bool) {
   UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
       view.isHidden = hidden
   })
  }
}


