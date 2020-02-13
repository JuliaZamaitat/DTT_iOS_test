//
//  MainMenuView.swift
//  RSR Pechhulp
//
//  Created by Julia Zamaitat on 13.02.20.
//  Copyright © 2020 Julia Zamaitat. All rights reserved.
//

import UIKit

class MainMenuView: UIView {

  @IBOutlet weak var backgroundImageView: UIImageView!
  /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
  
  func loadBackgroundImageWithRegularSize(){
    backgroundImageView.image = UIImage(named: "img_background_ipad.png")
  }
}
