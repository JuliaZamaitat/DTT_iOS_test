//
//  MapViewViewController.swift
//  RSR Pechhulp
//
//  Created by Julia Zamaitat on 03.03.20.
//  Copyright © 2020 Julia Zamaitat. All rights reserved.
//

import UIKit
import MapKit
import Network

protocol MapViewViewControllerInput {
  func openPhoneDialog(viewModel: MapView.PhoneCall.ViewModel)
  func showConnectionAlert(viewModel: MapView.Connection.ViewModel)
  func showAuthorizationAlert(viewModel: MapView.Authorization.ViewModel)
  func showLocation(viewModel: MapView.Location.ViewModel)
  func configureAddressAnnotation(viewModel: MapView.Annotation.ViewModel)
  func configureAnnotationView(viewModel: MapView.MapView.ViewModel)
}

protocol MapViewViewControllerOutput {
  func makePhoneCall(_ request: MapView.PhoneCall.Request)
  func checkInternetAccess(_ request: MapView.Connection.Request)
  func checkAndAskForAuthorization(_ request: MapView.Authorization.Request)
  func updateLocation(_ request: MapView.Location.Request)
  func geocodeLocation(_ request: MapView.Annotation.Request)
  func configureAnnotationView(_ request: MapView.MapView.Request) -> MKAnnotationView?
}

class MapViewViewController: UIViewController, MapViewViewControllerInput {
  
  
  @IBOutlet fileprivate weak var mapView: MKMapView!
  @IBOutlet fileprivate weak var addressAnnotation: UIView!
  @IBOutlet fileprivate weak var addressLabel: UILabel!
  @IBOutlet fileprivate weak var callNowView: UIView!
  @IBOutlet fileprivate weak var firstCallButton: UIButton!
  @IBOutlet fileprivate weak var cancelButton: UIButton!
  @IBOutlet fileprivate weak var secondCallButton: UIButton!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var descriptionTitle: UILabel!
  @IBOutlet weak var locationTitle: UILabel!
  @IBOutlet weak var locationDescription: UILabel!
  
  fileprivate lazy var locationManager: CLLocationManager = {
    return CLLocationManager()
  }()
  
  var output: MapViewViewControllerOutput!
  
  let monitor = NWPathMonitor()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    MapViewConfigurator.sharedInstance.configure(viewController: self)
  }
  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addressAnnotation.isHidden = true
    callNowView.isHidden = true
    configureLocalizations()
    configureNetworkHandler()
    setupLocationManager()
    NotificationCenter.default.addObserver(self, selector: #selector(setupLocationManager), name: UIApplication.willEnterForegroundNotification, object: nil)
  }
  
  func configureLocalizations(){
    firstCallButton.setTitle(Localizable.MapView.callNow.localized, for: .normal)
    secondCallButton.setTitle(Localizable.MapView.callNowConfirmation.localized, for: .normal)
    cancelButton.setTitle(Localizable.MapView.cancel.localized, for: .normal)
    descriptionLabel.text = Localizable.MapView.costDescription.localized
    descriptionTitle.text = Localizable.MapView.costTitle.localized
    locationTitle.text = Localizable.MapView.locationTitle.localized
    locationDescription.text = Localizable.MapView.locationDescription.localized
  }
}

// MARK: - Phone Call

extension MapViewViewController {
  
  // Triggers confirmation view for call and hides annotation view
  @IBAction func firstCallButtonPressed(_ sender: Any) {
    hideOrShowAddressAndCallButton()
  }
  
  // Triggers the phone functionality of the phone and hides the confirmation view
  @IBAction func secondCallButtonPressed(_ sender: Any) {
    let phoneNumber = "09007788990"
    let request = MapView.PhoneCall.Request(phoneNumber: phoneNumber)
    output.makePhoneCall(request)
  }
  
  // Hides confirmation view for call and presents annotation view
  @IBAction func cancelButtonPressed(_ sender: Any) {
    hideOrShowAddressAndCallButton()
  }
  
  // Makes the call box, button and address annotation (in)visible depending on how the previous state was
  func hideOrShowAddressAndCallButton(){
    callNowView.setView(hidden: !callNowView.isHidden)
    addressAnnotation.setView(hidden: !addressAnnotation.isHidden)
    firstCallButton.setView(hidden: !firstCallButton.isHidden)
  }
  
  
  // Makes the call box, button and address annotation (in)visible depending on how the previous state was
  func openPhoneDialog(viewModel: MapView.PhoneCall.ViewModel){
    UIApplication.shared.open(viewModel.phoneURL, options: [:], completionHandler: nil)
    hideOrShowAddressAndCallButton()
  }
  
}

// MARK: - Connectivity

extension MapViewViewController {
  
  func configureNetworkHandler() {
    monitor.pathUpdateHandler = { path in
      let request = MapView.Connection.Request(path: path)
      self.output.checkInternetAccess(request)
    }
    let queue = DispatchQueue(label: "Monitor")
    monitor.start(queue: queue)
  }
  
  func showConnectionAlert(viewModel: MapView.Connection.ViewModel) {
    if !viewModel.connected {
      showAlert(title: "No Connection", message: "You are not connected to the internet. Please turn on your WiFi or mobile services.")
    }
  }
  
}


// MARK: - CLLocationManagerDelegate

extension MapViewViewController: CLLocationManagerDelegate {
  
  // Sets up the delegate for the CLLocationManager object, sets the accuracy of the location data and checks the users permission to localize the device.
  @objc func setupLocationManager() {
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    let request = MapView.Authorization.Request(locationManager: locationManager)
    output.checkAndAskForAuthorization(request)
  }

  
  // Gets called after location was updated significantally and sets the map region to the current position.
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let request = MapView.Location.Request(locations: locations)
    output.updateLocation(request)
  }
  
  func showLocation(viewModel: MapView.Location.ViewModel) {
    mapView.setRegion(viewModel.region, animated: true)
    updateAddressAnnotation(forLocation: viewModel.userLocation)
    drawLocationPin(at: viewModel.userLocation)
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
  
  // Listens to changes in authorization for localisation
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    let request = MapView.Authorization.Request(locationManager: locationManager)
    output.checkAndAskForAuthorization(request)
  }
  
  
  // Updates the label for the address in the annotation box by calling the geocode method of CLLocation
  private func updateAddressAnnotation(forLocation location: CLLocation) {
    let request = MapView.Annotation.Request(location: location)
    output.geocodeLocation(request)
  }
  
  // Builds the string for the address label text
  func configureAddressAnnotation(viewModel: MapView.Annotation.ViewModel) {
    DispatchQueue.main.async {
      let placemark = viewModel.placemark
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
  
  
  func showAuthorizationAlert(viewModel: MapView.Authorization.ViewModel) {
    if viewModel.authorizationStatus == "denied" {
        showAlert(title: "GPS turned off", message: "GPS access is restricted. In order to use tracking, please enable GPS in the Settings app under Privacy, Location Services.", actions: [openAppPrivacySettings()])
      } else {
        showAlert(title: "GPS disabled on Device", message: "Your GPS is disabled on this device. Please enable it in the Settings app under Privacy, Location Services.")
      }
    
    
}
}

// MARK: - MKMapViewDelegate

extension MapViewViewController: MKMapViewDelegate {
  
  // Configures a new annotation view after trying to reuse an old one
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard annotation is MKPointAnnotation else { return nil }
    
    let request = MapView.MapView.Request(mapView: mapView, annotation: annotation)
    return output.configureAnnotationView(request)
  }
  
  // Sets the blue pin as annotation pointer and centers the blue annotation box
  func configureAnnotationView(viewModel: MapView.MapView.ViewModel) {
    let annotation = viewModel.annotationView
    annotation.image = UIImage(named: "marker.png")
    addressAnnotation.isHidden = false
    addressAnnotation.frame = CGRect(x: -(addressAnnotation.frame.width  / 2) + 13, y: -(addressAnnotation.frame.height) - 5, width: addressAnnotation.frame.width, height: addressAnnotation.frame.height) //I don't know why this has to be so weirdly hardcoded to be centered, probably some margins that intervene (?)
    annotation.addSubview(addressAnnotation)
  }
}


// MARK: - AlertManager

extension MapViewViewController: AlertManager {
  
  func showAlert(title: String, message: String, actions: [UIAlertAction] = []) {
    let alert = UIAlertController(title:title, message: message, preferredStyle: .alert)
    if !actions.isEmpty {
      for action in actions {
        alert.addAction(action)
      }
    } else {
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    }
    self.present(alert, animated: true, completion: nil)
  }
  
  
  // Opens the privacy settings for localisation of the app on the device
  func openAppPrivacySettings() -> UIAlertAction {
    let action = UIAlertAction(title: "Go to Settings now", style: .default, handler: { alert in
      guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
      UIApplication.shared.open(settingsUrl)
      self.dismiss(animated: true, completion: nil)
    }
    )
    return action
  }
}



