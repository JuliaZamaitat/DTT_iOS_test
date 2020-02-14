//
//  MapViewController.swift
//  RSR Pechhulp
//
//  Created by Julia Zamaitat on 14.02.20.
//  Copyright © 2020 Julia Zamaitat. All rights reserved.
//
//  Resource used: http://swiftdeveloperblog.com/mapview-display-users-current-location-and-drop-a-pin/

import UIKit
import MapKit

class MapViewController: UIViewController {

  @IBOutlet weak var mapView: MKMapView!
  fileprivate let locationManager: CLLocationManager = CLLocationManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    setupLocationManager()
  }
}

// MARK: - CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {
  
  //Sets up the delegate for the CLLocationManager object, sets the accuracy of the location data and checks the users permission to localize the device.
  func setupLocationManager() {
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    checkAndAskForAuthorization()
  }
  
  //Gets called after location was updated significantally and sets the map region to the current position.
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let userLocation: CLLocation = locations[0] as CLLocation
    let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
    let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    mapView.setRegion(region, animated: true)
    drawLocationPin(at: userLocation)
  }
  
  //Draws the pin at the current location after it changed
  func drawLocationPin(at location: CLLocation) {
    let myAnnotation: MKPointAnnotation = MKPointAnnotation()
    myAnnotation.coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
    myAnnotation.title = "Current location"
    mapView.addAnnotation(myAnnotation)
  }
  
  //Prints an error message if localisation failed.
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
     print("Error \(error)")
  }
  
  //Listens to changes in authorization for localisation
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
     checkAndAskForAuthorization()
  }
  
  //Checks the authorization status and shows an alert or get's the user location.
  func checkAndAskForAuthorization() {
    if CLLocationManager.locationServicesEnabled() {
      switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
         locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
          showAlert()
        case .authorizedAlways, .authorizedWhenInUse:
          locationManager.startMonitoringSignificantLocationChanges()
        default:
          break
      }
    }
  }
  
  //Shows an alert that GPS is turned off and takes the user to the settings.
  func showAlert(){
    let alert = UIAlertController(title: "GPS turned off", message: "GPS access is restricted. In order to use tracking, please enable GPS in the Settings app under Privacy, Location Services.", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Go to Settings now", style: .default, handler: { ( alert: UIAlertAction) in
      guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settingsUrl) {
          UIApplication.shared.open(settingsUrl)
        }
    }))
    self.present(alert, animated: true, completion: nil)
  }
}
