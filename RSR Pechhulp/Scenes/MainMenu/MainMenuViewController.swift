//
//  MainMenuViewController.swift
//  RSR Pechhulp
//
//  Created by Julia Zamaitat on 13.02.20.
//  Copyright © 2020 Julia Zamaitat. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {
  
  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBOutlet weak var navigationBarItem: UINavigationItem!
  var sizeClass: UIUserInterfaceSizeClass?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    sizeClass = traitCollection.horizontalSizeClass
    setupNavigationBar()
    setupBackgroundImage()
  }
  
  // MARK: - Styles
  
  // Sets up the navigation bar with the correct background and title color.
  private func setupNavigationBar(){
    guard let navigationController = navigationController else { return }
    navigationController.navigationBar.setBackgroundImage(UIImage(named: "navig_bar_back.png")?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0 ,right: 0), resizingMode: .stretch), for: .default)
    navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    navigationBarItem.title = Localizable.MainMenu.welcomeTitle.localized
    if sizeClass == .regular {
      navigationItem.rightBarButtonItem = nil
    }
  }
  
  // Changes background image if the device is regular width
  private func setupBackgroundImage(){
    if sizeClass == .regular {
      backgroundImageView.image = UIImage(named: "img_background_ipad.png")
    }
  }
  
  // MARK: - Navigation
  
  // Unwind segue that takes the user back to the main menu
  @IBAction func backToMainMenu(_ segue: UIStoryboardSegue) {}
  
}
