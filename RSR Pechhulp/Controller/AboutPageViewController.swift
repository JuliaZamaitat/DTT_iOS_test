//
//  AboutPageViewController.swift
//  RSR Pechhulp
//
//  Created by Julia Zamaitat on 13.02.20.
//  Copyright © 2020 Julia Zamaitat. All rights reserved.
//

import UIKit


class AboutPageViewController: UIViewController {

  @IBOutlet var aboutPageView: AboutPage!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    aboutPageView.configureTextLabel()
  }
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
