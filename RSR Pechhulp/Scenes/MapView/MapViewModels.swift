//
//  MapViewModels.swift
//  RSR Pechhulp
//
//  Created by Julia Zamaitat on 03.03.20.
//  Copyright © 2020 Julia Zamaitat. All rights reserved.
//

import UIKit
import MapKit
import Network

enum MapView {
  
  enum PhoneCall {
  
    struct Request {
      var phoneNumber: String
    }
    
    struct Response {
      var phoneURL: NSURL
    }
    
    struct ViewModel {
      var phoneURL: URL
    }
  }
  
  
  enum Connection {
  
    struct Request {
      var netStatus: NetStatus
    }
    
    struct Response {
      var connected: Bool
    }
    
    struct ViewModel {
      var connected: Bool
    }
  }
  
  enum Authorization {
  
    struct Request {
      var locationManager: CLLocationManager
    }
    
    struct Response {
      var authorizationStatus: String
    }
    
    struct ViewModel {
      var authorizationStatus: String
    }
  }
  
  enum Location {
  
    struct Request {
      var locations: [CLLocation]
    }
    
    struct Response {
      var userLocation: CLLocation
      var region: MKCoordinateRegion
    }
    
    struct ViewModel {
      var userLocation: CLLocation
      var region: MKCoordinateRegion
    }
    
    
  }
  
  enum Annotation {
  
    struct Request {
     var location: CLLocation
    }
    
    struct Response {
      var placemark: CLPlacemark
    }
    
    struct ViewModel {
      var placemark: CLPlacemark
    }
  }
  
  enum MapView {
  
    struct Request {
     var mapView: MKMapView
     var annotation: MKAnnotation
    }
    
    struct Response {
      var annotationView: MKAnnotationView
    }
    
    struct ViewModel {
       var annotationView: MKAnnotationView
    }
  }
  
}
