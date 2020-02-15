//
//  CLLocationExtension.swift
//  RSR Pechhulp
//
//  Created by Julia Zamaitat on 15.02.20.
//  Copyright © 2020 Julia Zamaitat. All rights reserved.
//

import MapKit

public extension CLLocation {
  func geocode(completion: @escaping (_ placemark: [CLPlacemark]?, _ error: Error?) -> Void)  {
      CLGeocoder().reverseGeocodeLocation(self, completionHandler: completion)
  }
}
