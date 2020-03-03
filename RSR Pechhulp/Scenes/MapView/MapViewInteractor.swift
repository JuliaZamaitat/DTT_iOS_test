//
//  MapViewInteractor.swift
//  RSR Pechhulp
//
//  Created by Julia Zamaitat on 03.03.20.
//  Copyright © 2020 Julia Zamaitat. All rights reserved.
//

import UIKit
import MapKit

protocol MapViewInteractorInput {
  func makePhoneCall(_ request: MapView.PhoneCall.Request)
  func checkInternetAccess(_ request: MapView.Connection.Request)
  func checkAndAskForAuthorization(_ request: MapView.Authorization.Request)
  func updateLocation(_ request: MapView.Location.Request)
  func geocodeLocation(_ request: MapView.Annotation.Request)
  func configureAnnotationView(_ request: MapView.MapView.Request) -> MKAnnotationView?
}
 
protocol MapViewInteractorOutput{
  func presentPhoneCall(response: MapView.PhoneCall.Response)
  func presentAlert(response: MapView.Connection.Response)
  func presentAuthorizationAlert(response: MapView.Authorization.Response)
  func presentLocation(response: MapView.Location.Response)
  func presentAddressAnnoation(response: MapView.Annotation.Response)
  func presentAnnotationView(response: MapView.MapView.Response)
 
}
 
class MapViewInteractor: MapViewInteractorInput {
  var output: MapViewInteractorOutput!
  var worker: MapViewWorker!
 
  // MARK: Business logic
 
  func makePhoneCall(_ request: MapView.PhoneCall.Request) {
    // NOTE: Create some Worker to do the work
 
//    worker = MapViewWorker()
//    worker.doSomeWork()
//
    // NOTE: Pass the result to the Presenter
    if let phoneURL = NSURL(string: ("tel://" + request.phoneNumber)) {
      let response = MapView.PhoneCall.Response(phoneURL: phoneURL)
      output.presentPhoneCall(response: response)
    }
  }
  
  func checkInternetAccess(_ request: MapView.Connection.Request) {
    let connected = request.reachability.isConnectedToNetwork()
    if !connected {
      let response = MapView.Connection.Response(connected: connected)
      output.presentAlert(response: response)
    }
  }
  
  // Checks the authorization status and shows the location or an alert if not authorized
  func checkAndAskForAuthorization(_ request: MapView.Authorization.Request) {
    if CLLocationManager.locationServicesEnabled() {
      switch CLLocationManager.authorizationStatus() {
      case .notDetermined:
        request.locationManager.requestWhenInUseAuthorization()
      case .denied, .restricted:
        let response = MapView.Authorization.Response(authorizationStatus: "denied")
        output.presentAuthorizationAlert(response: response)
      case .authorizedAlways, .authorizedWhenInUse:
        request.locationManager.startMonitoringSignificantLocationChanges()
      default:
        break
      }
    } else { // If Authorization is disabled device-wide
      let response = MapView.Authorization.Response(authorizationStatus: "disabled")
      output.presentAuthorizationAlert(response: response)
     
    }
  }
  
  func updateLocation(_ request: MapView.Location.Request) {
    let userLocation: CLLocation = request.locations[0] as CLLocation
    let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
    let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    
    let response = MapView.Location.Response(userLocation: userLocation, region: region)
    output.presentLocation(response: response)
  }
  
  func geocodeLocation(_ request: MapView.Annotation.Request) {
    request.location.geocode { placemark, error in
      if let error = error as? CLError {
        print("CLError:", error)
      } else if let placemark = placemark?.first {
        let response = MapView.Annotation.Response(placemark: placemark)
        self.output.presentAddressAnnoation(response: response)
          
      }
    }
  }
  
  func configureAnnotationView(_ request: MapView.MapView.Request) -> MKAnnotationView? {
    let annotationIdentifier = "AnnotationIdentifier"
    var annotationView = request.mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
    
    if annotationView == nil {
      annotationView = MKAnnotationView(annotation: request.annotation, reuseIdentifier: annotationIdentifier)
      guard let annotationView = annotationView else { return nil }
      
      let response = MapView.MapView.Response(annotationView: annotationView)
      output.presentAnnotationView(response: response)
    }else {
      annotationView?.annotation = request.annotation
    }
    return annotationView
  }
  
}
