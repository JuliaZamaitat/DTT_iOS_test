//
//  MapViewConfigurator.swift
//  RSR Pechhulp
//
//  Created by Julia Zamaitat on 03.03.20.
//  Copyright © 2020 Julia Zamaitat. All rights reserved.
//

import UIKit
 
// MARK: Connect View, Interactor, and Presenter
 
extension MapViewViewController: MapViewPresenterOutput { }
 
extension MapViewInteractor: MapViewViewControllerOutput { }
 
extension MapViewPresenter: MapViewInteractorOutput { }
 
class MapViewConfigurator {
 
  static var sharedInstance: MapViewConfigurator = { MapViewConfigurator() }()
     
  // MARK: - Configuration
 
  ///Wires the Controller, Interactor and Presenter
  func configure(viewController: MapViewViewController) {
    let presenter = MapViewPresenter()
    presenter.output = viewController
 
    let interactor = MapViewInteractor()
    interactor.output = presenter
 
    viewController.output = interactor
  }
}
 
