//
//  MapViewViewController.swift
//  RSR Pechhulp
//
//  Created by Julia Zamaitat on 03.03.20.
//  Copyright © 2020 Julia Zamaitat. All rights reserved.
//

import UIKit
import MapKit

protocol MapViewViewControllerInput {
  func makePhoneCall(viewModel: MapView.ViewModel)
}

protocol MapViewViewControllerOutput {
  func makePhoneCall(_ request: MapView.Request)
}

class MapViewViewController: UIViewController, MapViewViewControllerInput {
  
  
  @IBOutlet fileprivate weak var mapView: MKMapView!
  @IBOutlet fileprivate weak var addressAnnotation: UIView!
  @IBOutlet fileprivate weak var addressLabel: UILabel!
  @IBOutlet fileprivate weak var callNowView: UIView!
  @IBOutlet fileprivate weak var firstCallButton: UIButton!
  @IBOutlet fileprivate weak var cancelButton: UIButton!

  var output: MapViewViewControllerOutput!
  var router: MapViewRouter!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    MapViewConfigurator.sharedInstance.configure(viewController: self)
  }
  
  
  @IBAction func firstCallButtonPressed(_ sender: Any) {
    hideOrShowAddressAndCallButton()
  }
  
  // Triggers the phone functionality of the phone and hides the confirmation view
  @IBAction func secondCallButtonPressed(_ sender: Any) {
    let phoneNumber = "09007788990miau"
    let request = MapView.Request(phoneNumber: phoneNumber)
    output.makePhoneCall(request)
  }
  
  // Hides confirmation view for call and presents annotation view
  @IBAction func cancelButtonPressed(_ sender: Any) {
    hideOrShowAddressAndCallButton()
  }
  
  
  // MARK: View lifecycle
  
    override func viewDidLoad() {
        super.viewDidLoad()
      addressAnnotation.isHidden = true
      callNowView.isHidden = true
      

        // Do any additional setup after loading the view.
    }
  
  
    
  // MARK: Display logic
  
  // Makes the call box, button and address annotation (in)visible depending on how the previous state was
  func hideOrShowAddressAndCallButton(){
    Helper.setView(callNowView, hidden: !callNowView.isHidden)
    Helper.setView(addressAnnotation, hidden: !addressAnnotation.isHidden)
    Helper.setView(firstCallButton, hidden: !firstCallButton.isHidden)
    
    //NOTE: Display the result from the Presenter
    // nameTextField.text = viewModel.name
  }
  
  
  // Makes the call box, button and address annotation (in)visible depending on how the previous state was
  func makePhoneCall(viewModel: MapView.ViewModel){
    UIApplication.shared.open(viewModel.phoneURL, options: [:], completionHandler: nil)
    hideOrShowAddressAndCallButton()
    
    //NOTE: Display the result from the Presenter
    // nameTextField.text = viewModel.name
  
  
  }

}
