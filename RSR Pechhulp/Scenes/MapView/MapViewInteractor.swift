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
  func presentConnectivityAlert(response: MapView.Connection.Response)
  func presentAuthorizationAlert(response: MapView.Authorization.Response)
  func presentLocation(response: MapView.Location.Response)
  func presentAddressAnnoation(response: MapView.Annotation.Response)
  func presentAnnotationView(response: MapView.MapView.Response)
  
}

class MapViewInteractor: MapViewInteractorInput {
  
  var output: MapViewInteractorOutput!
  
  // MARK: - Phone Call
  
  /**
    Prepares the URL for the phone call for the presenter
    
    - Parameter request: the phone number provided as String
   */
  func makePhoneCall(_ request: MapView.PhoneCall.Request) {
    if let phoneURL = NSURL(string: ("tel://" + request.phoneNumber)) {
      let response = MapView.PhoneCall.Response(phoneURL: phoneURL)
      output.presentPhoneCall(response: response)
    }
  }
  
  
  // MARK: - Connectivity
  
  /**
   Checks the internet connection and alerts the presenter if not connected
   
   - Parameter request: An object that contains information about the properties of the network that a connection uses, or that are available to your app.
  */
  func checkInternetAccess(_ request: MapView.Connection.Request) {
    if request.path.status == .satisfied {
      print("We're connected!")
    } else {
      DispatchQueue.main.async {
        let response = MapView.Connection.Response(connected: false)
        self.output.presentConnectivityAlert(response: response)
      }
    }
  }
  
  
  // MARK: - MapView
  
  /**
   Checks the authorization status and shows the location or an alert if not authorized
   
   - Parameter request: The object that you use to start and stop the delivery of location-related events to your app as CLLocationManager
  */
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
  
  
  /**
   Updates the location on the map
   
   - Parameter request: a collection of locations as CLLocation that include zhe latitude, longitude, and course information reported by the system.
  */
  func updateLocation(_ request: MapView.Location.Request) {
    let userLocation: CLLocation = request.locations[0] as CLLocation
    let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
    let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    
    let response = MapView.Location.Response(userLocation: userLocation, region: region)
    output.presentLocation(response: response)
  }
  
  
  /**
   Uses geocoding to get the address of the current location
   
   - Parameter request: a location as CLLocation that includes zhe latitude, longitude, and course information reported by the system.
  */
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
  
  
  /**
   Configures the annotation view for the map view
   
   - Parameter request: The mapView as MKMapView and the annotation as MKAnnotation
   
   - Returns: A reusable MK AnnotationView
  */
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
