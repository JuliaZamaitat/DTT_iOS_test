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
  @IBOutlet weak var addressAnnotation: UIView!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var callNowView: UIView!
  @IBOutlet weak var firstCallButton: UIButton!
  @IBOutlet weak var cancelButton: UIButton!
  
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
  
  // MARK: - Connectivity
  
  func checkInternetAccess() {
    if !Reachability.getInstance().isConnectedToNetwork() {
      Helper.showAlert(from: self, title: "No Connection", message: "You are not connected to the internet. Please turn on your WiFi or mobile services.")
    }
  }
  
  
  // MARK: - Phone Call
  
  @IBAction func firstCallButtonPressed(_ sender: Any) {
     hideOrShowAddressAndCallButton()
  }
  @IBAction func secondCallButtonPressed(_ sender: Any) {
    makePhoneCall(withPhoneNumber: "09007788990")
  }
  
  func makePhoneCall(withPhoneNumber number: String) {
    if let phoneURL = NSURL(string: ("tel://" + number)) {
      UIApplication.shared.open(phoneURL as URL, options: [:], completionHandler: nil)
      hideOrShowAddressAndCallButton()
    }
  }
  
  @IBAction func cancelButtonPressed(_ sender: Any) {
    hideOrShowAddressAndCallButton()
  }
  
  func hideOrShowAddressAndCallButton() {
    Helper.setView(callNowView, hidden: !callNowView.isHidden)
    Helper.setView(addressAnnotation, hidden: !addressAnnotation.isHidden)
    Helper.setView(firstCallButton, hidden: !firstCallButton.isHidden)
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
    updateAddressAnnotation(forLocation: userLocation)
    let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
    let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    mapView.setRegion(region, animated: true)
    drawLocationPin(at: userLocation)
  }
  
  //Draws the pin at the current location after it changed
  func drawLocationPin(at location: CLLocation) {
    let myAnnotation: MKPointAnnotation = MKPointAnnotation()
    myAnnotation.coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
    self.mapView.addAnnotation(myAnnotation)
    addressAnnotation.isHidden = false
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
          let action = UIAlertAction(title: "Go to Settings now", style: .default, handler: { ( alert: UIAlertAction) in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
              if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
              }
          })
          Helper.showAlert(from: self, title: "GPS turned off", message: "GPS access is restricted. In order to use tracking, please enable GPS in the Settings app under Privacy, Location Services.", actions: [action])
        case .authorizedAlways, .authorizedWhenInUse:
          locationManager.startMonitoringSignificantLocationChanges()
        default:
          break
      }
    } else {
      Helper.showAlert(from: self, title: "GPS disabled on Device", message: "Your GPS is disabled on this device. Please enable it in the Settings app under Privacy, Location Services.")
    }
  }
  
  //Updates the label for the address by calling the geocode method of CLLocation
  func updateAddressAnnotation(forLocation location: CLLocation) {
    location.geocode { placemark, error in
      if let error = error as? CLError {
        print("CLError:", error)
    } else if let placemark = placemark?.first {
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
  }
}


// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
  
  //Configures the annotation to display the blue marker and blue box above it and returns a MKAnnotationView or nil
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    let annotationIdentifier = "AnnotationIdentifier"
    var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
    if annotationView == nil {
      annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
      guard let annotationView = annotationView else { return nil }
      annotationView.image = UIImage(named: "marker.png")
      addressAnnotation.isHidden = false
      addressAnnotation.frame = CGRect(x: -(addressAnnotation.frame.width  / 2) + 13, y: -(addressAnnotation.frame.height) - 5, width: addressAnnotation.frame.width, height: addressAnnotation.frame.height) //I don't know why this has to be so weirdly hardcoded to be centered, probably some margins that intervene (?)
      annotationView.addSubview(addressAnnotation)
    } else {
        annotationView?.annotation = annotation
      }
    return annotationView
  }
}

// MARK: - CLLocation

extension CLLocation {
  func geocode(completion: @escaping (_ placemark: [CLPlacemark]?, _ error: Error?) -> Void)  {
      CLGeocoder().reverseGeocodeLocation(self, completionHandler: completion)
  }
}
