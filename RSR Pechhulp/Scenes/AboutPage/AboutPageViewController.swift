//
//  AboutPageViewController.swift
//  RSR Pechhulp
//
//  Created by Julia Zamaitat on 03.03.20.
//  Copyright © 2020 Julia Zamaitat. All rights reserved.
//

import UIKit

class AboutPageViewController: UIViewController {

    
    @IBOutlet weak var textView: UITextView!
  
    @IBOutlet weak var navigationBar: UINavigationItem!
  
    override func viewDidLoad() {
      super.viewDidLoad()
      configureTextLabel()
    }
    
    private func configureTextLabel() {
      textView.text = Localizable.AboutPage.aboutTextPt1.localized + "\n\n" + Localizable.AboutPage.aboutTextPt2.localized
      navigationBar.title = Localizable.AboutPage.title.localized
    }
}
