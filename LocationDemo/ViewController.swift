//
//  ViewController.swift
//  LocationDemo
//
//  Created by Nirvana on 1/27/16.
//  Copyright © 2016 NSNirvana. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    let locationManager = NirLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }
}

extension ViewController: NirLocationManagerDelegate {
    func locationManager(manager: NirLocationManager, didGetCityName cityName: String, andCountryName countryName: String) {
        print(cityName)
        print(countryName)
    }
    func locationManager(manager: NirLocationManager, didGetCurrentLocation location: CLLocation?) {
        if let location = location {
            print(location)
        } else {
            print("Can not get current location")
        }
        
    }
}

