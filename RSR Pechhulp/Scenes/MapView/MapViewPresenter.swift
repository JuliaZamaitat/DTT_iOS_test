//
//  MapViewPresenter.swift
//  RSR Pechhulp
//
//  Created by Julia Zamaitat on 03.03.20.
//  Copyright © 2020 Julia Zamaitat. All rights reserved.
//

import UIKit

protocol MapViewPresenterInput {
  func presentPhoneCall(response: MapView.Response)
}
 
protocol MapViewPresenterOutput: class {
 func makePhoneCall(viewModel: MapView.ViewModel)
}
 
class MapViewPresenter: MapViewPresenterInput {
  weak var output: MapViewPresenterOutput!
 
  // MARK: Presentation logic
 
  func presentPhoneCall(response: MapView.Response) {
    // NOTE: Format the response from the Interactor and pass the result back to the View Controller
    
    let viewModel = MapView.ViewModel(phoneURL: response.phoneURL as URL)
    
    output.makePhoneCall(viewModel: viewModel)
  }
}
