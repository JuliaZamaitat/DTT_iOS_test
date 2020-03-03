//
//  UIViewExtension.swift
//  RSR Pechhulp
//
//  Created by Julia Zamaitat on 03.03.20.
//  Copyright © 2020 Julia Zamaitat. All rights reserved.
//

import UIKit

public extension UIView {
  
  // Makes a view (in)visible with a smooth animation
  func setView(hidden: Bool) {
    UIView.transition(with: self, duration: 0.5, options: .transitionCrossDissolve, animations: {
       self.isHidden = hidden
     })
   }
}
