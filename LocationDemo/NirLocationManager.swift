//
//  NirLocationManager.swift
//  LocationDemo
//
//  Created by Nirvana on 1/27/16.
//  Copyright © 2016 NSNirvana. All rights reserved.
//

import Foundation
import CoreLocation

protocol NirLocationManagerDelegate {
    func locationManager(manager: NirLocationManager, didGetCityName cityName: String, andCountryName countryName: String)
    func locationManager(manager: NirLocationManager, didGetCurrentLocation location: CLLocation?)
}

class NirLocationManager: NSObject {
    let locationManager = CLLocationManager()
    
    var delegate: NirLocationManagerDelegate? {
        didSet {
            initializeLocationManagerAndUpdateLocation()
        }
    }
    
    /**
     当被初次启用时 做初始化以及更新位置
     */
    func initializeLocationManagerAndUpdateLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.pausesLocationUpdatesAutomatically = true
        if CLLocationManager.authorizationStatus() != .AuthorizedAlways {
            locationManager.requestAlwaysAuthorization()
        } else {
            locationManager.startUpdatingLocation()
        }
    }
    
    /**
     重新加载当前位置
     */
    func reloadLocation() {
        locationManager.startUpdatingLocation()
    }
    
    /**
     根据经纬度获取中文城市名
     
     - parameter location: 传入的经纬度
     - parameter completeHandler: 提供城市名和国家名的完成闭包
     */
    private func getCityName(location:CLLocation, completeHandler:(cityName: String,countryName: String) -> ()) {
        let deviceLanguage = NSUserDefaults.standardUserDefaults().objectForKey("AppleLanguages") as! NSMutableArray
        NSUserDefaults.standardUserDefaults().setObject(NSArray(array: ["zh-hans"]), forKey: "AppleLanguages")
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, completionHandler: { (marks, error) -> Void in
            if error == nil && marks?.count>0 {
                let cityName = String(marks![0].locality!.characters.filter({ (character) -> Bool in
                    character != "市"
                }))
                let countryName = marks![0].country!
                
                completeHandler(cityName: cityName, countryName: countryName)
                
                NSUserDefaults.standardUserDefaults().setObject(deviceLanguage, forKey: "AppleLanguages")
            }
        })
    }
}

extension NirLocationManager: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.delegate?.locationManager(self, didGetCurrentLocation: locations.last)
        getCityName(locations.last!) { (cityName, countryName) -> () in
            self.delegate?.locationManager(self, didGetCityName: cityName, andCountryName: countryName)
        }
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways {
            print("Permission geted")
            locationManager.startUpdatingLocation()
        } else {
            print("Do not have permission to get location")
        }
    }
}