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
  
  @IBOutlet fileprivate weak var mapView: MKMapView!
  @IBOutlet fileprivate weak var addressAnnotation: UIView!
  @IBOutlet fileprivate weak var addressLabel: UILabel!
  @IBOutlet fileprivate weak var callNowView: UIView!
  @IBOutlet fileprivate weak var firstCallButton: UIButton!
  @IBOutlet fileprivate weak var cancelButton: UIButton!
  
  fileprivate let locationManager: CLLocationManager = CLLocationManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addressAnnotation.isHidden = true
    callNowView.isHidden = true
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    setupLocationManager()
    checkInternetAccess()
  }
}

// MARK: - Phone Call

extension MapViewController: PhoneCall {
  
  // Triggers confirmation view for call and hides annotation view
  @IBAction func firstCallButtonPressed(_ sender: Any) {
    hideOrShowAddressAndCallButton()
  }
  
  // Triggers the phone functionality of the phone and hides the confirmation view
  @IBAction func secondCallButtonPressed(_ sender: Any) {
    makePhoneCall(withPhoneNumber: "09007788990")
    hideOrShowAddressAndCallButton()
  }
  
  // Hides confirmation view for call and presents annotation view
  @IBAction func cancelButtonPressed(_ sender: Any) {
    hideOrShowAddressAndCallButton()
  }
  
  // Makes the call box, button and address annotation (in)visible depending on how the previous state was
  func hideOrShowAddressAndCallButton() {
    Helper.setView(callNowView, hidden: !callNowView.isHidden)
    Helper.setView(addressAnnotation, hidden: !addressAnnotation.isHidden)
    Helper.setView(firstCallButton, hidden: !firstCallButton.isHidden)
  }
  
  // Makes the device show the link to call with the specified number
  func makePhoneCall(withPhoneNumber number: String) {
    if let phoneURL = NSURL(string: ("tel://" + number)) {
      UIApplication.shared.open(phoneURL as URL, options: [:], completionHandler: nil)
    }
  }
}

// MARK: - Connectivity

extension MapViewController: Connectivity {
  
  var reachability: Reachability {
    Reachability.getInstance()
  }
  
  // Checks for internet connenction and alerts when not connected.
  func checkInternetAccess() {
    if !reachability.isConnectedToNetwork() {
      Helper.showAlert(from: self, title: "No Connection", message: "You are not connected to the internet. Please turn on your WiFi or mobile services.")
    }
  }
}

// MARK: - CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {
  
  // Sets up the delegate for the CLLocationManager object, sets the accuracy of the location data and checks the users permission to localize the device.
  func setupLocationManager() {
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    checkAndAskForAuthorization()
  }
  
  // Gets called after location was updated significantally and sets the map region to the current position.
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let userLocation: CLLocation = locations[0] as CLLocation
    let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
    let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    mapView.setRegion(region, animated: true)
    updateAddressAnnotation(forLocation: userLocation)
    drawLocationPin(at: userLocation)
  }
  
  // Adds the pin at the current location after it changed
  private func drawLocationPin(at location: CLLocation) {
    let myAnnotation: MKPointAnnotation = MKPointAnnotation()
    myAnnotation.coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
    self.mapView.addAnnotation(myAnnotation)
    addressAnnotation.isHidden = false
  }
  
  // Prints an error message if localisation failed.
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Error \(error)")
  }
  
  // Checks the authorization status and shows the location or an alert if not authorized
  func checkAndAskForAuthorization() {
    if CLLocationManager.locationServicesEnabled() {
      switch CLLocationManager.authorizationStatus() {
      case .notDetermined:
        locationManager.requestWhenInUseAuthorization()
      case .denied, .restricted:
        Helper.showAlert(from: self, title: "GPS turned off", message: "GPS access is restricted. In order to use tracking, please enable GPS in the Settings app under Privacy, Location Services.", actions: [Helper.openAppPrivacySettings()])
      case .authorizedAlways, .authorizedWhenInUse:
        locationManager.startMonitoringSignificantLocationChanges()
      default:
        break
      }
    } else { // If Authorization is disabled device-wide
      Helper.showAlert(from: self, title: "GPS disabled on Device", message: "Your GPS is disabled on this device. Please enable it in the Settings app under Privacy, Location Services.")
    }
  }
  
  // Listens to changes in authorization for localisation
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    checkAndAskForAuthorization()
  }
  
  // Updates the label for the address in the annotation box by calling the geocode method of CLLocation
  private func updateAddressAnnotation(forLocation location: CLLocation) {
    location.geocode { placemark, error in
      if let error = error as? CLError {
        print("CLError:", error)
      } else if let placemark = placemark?.first {
          self.configureAddressAnnotation(forPlacemark: placemark)
      }
    }
  }
  
  // Builds the string for the address label text
  private func configureAddressAnnotation(forPlacemark placemark: CLPlacemark) {
    DispatchQueue.main.async {
      if let street = placemark.thoroughfare,
        let number = placemark.subThoroughfare,
        let zip = placemark.postalCode,
        let city = placemark.locality {
        self.addressLabel.text = """
        \(street) \(number),
        \(zip), \(city)
        """
      }
    }
  }
  
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
  
  // Configures a new annotation view after trying to reuse an old one
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard annotation is MKPointAnnotation else { return nil }
    let annotationIdentifier = "AnnotationIdentifier"
    var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
    
    if annotationView == nil {
      annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
      guard let annotationView = annotationView else { return nil }
      configureView(forAnnotation: annotationView)
    } else {
      annotationView?.annotation = annotation
    }
    
    return annotationView
  }
  
  // Sets the blue pin as annotation pointer and centers the blue annotation box
  private func configureView(forAnnotation annotation: MKAnnotationView) {
    annotation.image = UIImage(named: "marker.png")
    addressAnnotation.isHidden = false
    addressAnnotation.frame = CGRect(x: -(addressAnnotation.frame.width  / 2) + 13, y: -(addressAnnotation.frame.height) - 5, width: addressAnnotation.frame.width, height: addressAnnotation.frame.height) //I don't know why this has to be so weirdly hardcoded to be centered, probably some margins that intervene (?)
    annotation.addSubview(addressAnnotation)
  }
}

