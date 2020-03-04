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
  func presentConnectivityAlert(response: MapView.Connection.Response)
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
  
  // MARK: - Presentation logic
  
  
  /**
  Prepares the phone number for the right format and opens the phone dialoge of the system
   
    - Parameter response: the phone URL as NSURL
   */
  func presentPhoneCall(response: MapView.PhoneCall.Response) {
    let viewModel = MapView.PhoneCall.ViewModel(phoneURL: response.phoneURL as URL)
    output.openPhoneDialog(viewModel: viewModel)
  }
  
  
  /**
  Presents an alert when no internet connection is available
  
   - Parameter response: a Bool indicating whether the device is connected to internet or not
  */
  func presentConnectivityAlert(response: MapView.Connection.Response) {
    let viewModel = MapView.Connection.ViewModel(connected: response.connected)
    output.showConnectionAlert(viewModel: viewModel)
  }
  
  
  /**
  Presents  the alert when authorization is restricted or denied
  
   - Parameter response: a String containing the authorization status
  */
  func presentAuthorizationAlert(response: MapView.Authorization.Response) {
    let viewModel = MapView.Authorization.ViewModel(authorizationStatus: response.authorizationStatus)
    output.showAuthorizationAlert(viewModel: viewModel)
  }
  
  
  /**
  Shows the current location on the map view
  
   - Parameter response: the current user location as CLLocation and region as MKCoordinateRegion
  */
  func presentLocation(response: MapView.Location.Response){
    let viewModel = MapView.Location.ViewModel(userLocation: response.userLocation, region: response.region)
    output.showLocation(viewModel: viewModel)
  }
  
  
  /**
  Configures the address annotation on the map
  
   - Parameter response: the placemark which is a user-friendly description of a geographic coordinate, often containing the name of the place, its address, and other relevant information.
  */
  func presentAddressAnnoation(response: MapView.Annotation.Response) {
    let viewModel = MapView.Annotation.ViewModel(placemark: response.placemark)
    output.configureAddressAnnotation(viewModel: viewModel)
  }
  
  
  /**
  Shows the annotation view on the map
  
   - Parameter response: the annotation view of the map
  */
  func presentAnnotationView(response: MapView.MapView.Response) {
    let viewModel = MapView.MapView.ViewModel(annotationView: response.annotationView)
    output.configureAnnotationView(viewModel: viewModel)
  }
}
