//
//  AboutPageViewController.swift
//  RSR Pechhulp
//
//  Created by Julia Zamaitat on 13.02.20.
//  Copyright © 2020 Julia Zamaitat. All rights reserved.
//

import UIKit

class AboutPageViewController: UIViewController {
  
  @IBOutlet weak var textView: UITextView!
  override func viewDidLoad() {
    super.viewDidLoad()
    configureTextLabel()
  }
  
  private func configureTextLabel() {
    textView.text = """
    Met de hulp van RSR blijft u mobiel. RSR is dé leverancier van hulpmiddelen in de regio Noordoost-Nederland. Gedegen kennis en jarenlange ervaring zit in ons DNA verweven en leidt tot het beste advies.\n
    Wilt u meer weten over onze producten en diensten, kijk dan op www.rsr.nl of bezoek onze showrooms in Silvolde en Nieuwleusen. We zijn iedere werkdag geopend van 8.00 tot 17.00 uur. Hier kunt u diverse hulpmiddelen uitproberen en rustig bekijken wat goed bij uw situatie aansluit. Samen met u zoeken we naar hulpmiddelen dat bij u past. RSR maakt mensen mobiel.
    """
  }
}
