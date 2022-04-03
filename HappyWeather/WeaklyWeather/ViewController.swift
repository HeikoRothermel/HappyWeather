//
//  ViewController.swift
//  HappyWeather
//
//  Created by Heiko Rothermel on 4/2/22.
//

import UIKit
import FloatingPanel
import CoreLocation




class ViewController: UIViewController, FloatingPanelControllerDelegate, CLLocationManagerDelegate {

    @IBOutlet var myRemovePanel: UIButton!
    @IBOutlet var myShowPanel: UIButton!
    let fpc = FloatingPanelController()
    
    var models = [Daily]()
    
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        let fpc = FloatingPanelController()
        fpc.delegate = self
        guard let contentVC = storyboard?.instantiateViewController(identifier: "FloatingPanelControler_content") as? ContentViewController else {
            return
        }
//        fpc.show(contentVC, sender: nil)
        fpc.set(contentViewController: contentVC)
        fpc.addPanel(toParent: self)
        fpc.move(to: .tip, animated: true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLocation()
    }
    
    
    // Location
    func setupLocation() {
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            requestWeatherForLocation()
        }
        
    }
    
    func requestWeatherForLocation() {
        
        guard let currentLocation = currentLocation else {
            return
        }
        
        let long = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude
        print("\(lat) | \(long)")
        
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(long)&units=metric&lang=de&appid=7e5da986d80232efd714c8abf2a1db1b") else {
            return
        }
       let task = URLSession.shared.dataTask(with: url) { data, _, error in
          
            //Validation
            guard let data = data, error == nil else {
                print("something went wrong")
                return
            }
            
            

        
        
            var json: WeatherResponse?
                    do {
                        
                        json = try JSONDecoder().decode(WeatherResponse.self, from: data)
                        
                    }
                    catch {
                        print("error: \(error)")
                        
                    }
                    
                    guard let result = json else {
                        return
                    }
            
            print(result.timezone)
        
        let entries = result.daily
        
        self.models.append(contentsOf: entries)
        
        
            
        for itm in json!.daily {
            print("Value: \(json?.timezone ?? "No timezone") \n \(itm.dt), \(itm.clouds), \(itm.uvi), \(itm.pop), \(itm.wind_gust),\(itm.temp.max),\(itm.weather.first?.main ?? "")")
        }
        

            
            
            
            
        }
        task.resume()
       
        
        
    }
    
    
    
    @IBAction func removePanel(_ sender: UIButton) {
        fpc.move(to: .half, animated: true)
//        fpc.hide()
    }
    
    @IBAction func showPanel(_ sender: UIButton) {
        fpc.show()
    }
    
}

