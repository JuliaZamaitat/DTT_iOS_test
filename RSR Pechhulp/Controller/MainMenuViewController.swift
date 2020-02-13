//
//  MainMenuViewController.swift
//  RSR Pechhulp
//
//  Created by Julia Zamaitat on 13.02.20.
//  Copyright © 2020 Julia Zamaitat. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {

  @IBOutlet var mainMenuView: MainMenuView!
  var sizeClass: UIUserInterfaceSizeClass?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    sizeClass = traitCollection.horizontalSizeClass
    setupNavigationBar()
    setupBackgroundImage()
  }

  // Sets up the navigation bar with the correct background and title color.
  private func setupNavigationBar(){
    guard let navigationController = navigationController else { return }
    navigationController.navigationBar.setBackgroundImage(UIImage(named: "navig_bar_back.png")?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0 ,right: 0), resizingMode: .stretch), for: .default)
    navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    if sizeClass == .regular {
      navigationItem.rightBarButtonItem = nil
    }
  }
  
  private func setupBackgroundImage(){
    if sizeClass == .regular {
      mainMenuView.loadBackgroundImageWithRegularSize()
    }
  }
    
    
  
  
    
  // MARK: - Navigation

  @IBAction func backToMainMenu(_ segue: UIStoryboardSegue) {}

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
  
  
    
 
}
