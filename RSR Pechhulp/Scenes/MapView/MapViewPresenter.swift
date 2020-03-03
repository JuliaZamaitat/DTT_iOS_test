//
//  MapViewPresenter.swift
//  RSR Pechhulp
//
//  Created by Julia Zamaitat on 03.03.20.
//  Copyright © 2020 Julia Zamaitat. All rights reserved.
//

import UIKit

protocol MapViewPresenterInput {
  func presentPhoneCall(response: MapView.PhoneCall.Response)
  func presentAlert(response: MapView.Connection.Response)
  func presentAuthorizationAlert(response: MapView.Authorization.Response)
  func presentLocation(response: MapView.Location.Response)
  func presentAddressAnnoation(response: MapView.Annotation.Response)
  func presentAnnotationView(response: MapView.MapView.Response)
}
 
protocol MapViewPresenterOutput: class {
  func openPhoneDialog(viewModel: MapView.PhoneCall.ViewModel)
  func showConnectionAlert(viewModel: MapView.Connection.ViewModel)
  func showAuthorizationAlert(viewModel: MapView.Authorization.ViewModel)
  func showLocation(viewModel: MapView.Location.ViewModel)
  func configureAddressAnnotation(viewModel: MapView.Annotation.ViewModel)
  func configureAnnotationView(viewModel: MapView.MapView.ViewModel)
}
 
class MapViewPresenter: MapViewPresenterInput {
  weak var output: MapViewPresenterOutput!
 
  // MARK: Presentation logic
 
  func presentPhoneCall(response: MapView.PhoneCall.Response) {
    // NOTE: Format the response from the Interactor and pass the result back to the View Controller
    
    let viewModel = MapView.PhoneCall.ViewModel(phoneURL: response.phoneURL as URL)
    output.openPhoneDialog(viewModel: viewModel)
  }
  
  
  func presentAlert(response: MapView.Connection.Response) {
    let viewModel = MapView.Connection.ViewModel(connected: response.connected)
    output.showConnectionAlert(viewModel: viewModel)
  }
  
  func presentAuthorizationAlert(response: MapView.Authorization.Response) {
   
    let viewModel = MapView.Authorization.ViewModel(authorizationStatus: response.authorizationStatus)
    output.showAuthorizationAlert(viewModel: viewModel)
  }
  
  func presentLocation(response: MapView.Location.Response){
    let viewModel = MapView.Location.ViewModel(userLocation: response.userLocation, region: response.region)
    output.showLocation(viewModel: viewModel)
  }
  
  func presentAddressAnnoation(response: MapView.Annotation.Response) {
    let viewModel = MapView.Annotation.ViewModel(placemark: response.placemark)
    output.configureAddressAnnotation(viewModel: viewModel)
  }
  
  func presentAnnotationView(response: MapView.MapView.Response) {
    
    let viewModel = MapView.MapView.ViewModel(annotationView: response.annotationView)
    output.configureAnnotationView(viewModel: viewModel)
  }
}
