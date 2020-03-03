//
//  MapViewConfigurator.swift
//  RSR Pechhulp
//
//  Created by Julia Zamaitat on 03.03.20.
//  Copyright © 2020 Julia Zamaitat. All rights reserved.
//

import UIKit
 
// MARK: Connect View, Interactor, and Presenter
 
extension MapViewViewController: MapViewPresenterOutput {
//  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    router.passDataToNextScene(segue: segue)
//  }
}
 
extension MapViewInteractor: MapViewViewControllerOutput {
}
 
extension MapViewPresenter: MapViewInteractorOutput {
}
 
class MapViewConfigurator {
  // MARK: Object lifecycle
 
  
  static var sharedInstance: MapViewConfigurator = { MapViewConfigurator() }()
     

  // MARK: Configuration
 
  func configure(viewController: MapViewViewController) {
    let router = MapViewRouter()
    router.viewController = viewController
 
    let presenter = MapViewPresenter()
    presenter.output = viewController
 
    let interactor = MapViewInteractor()
    interactor.output = presenter
 
    viewController.output = interactor
    viewController.router = router
  }
}
 
