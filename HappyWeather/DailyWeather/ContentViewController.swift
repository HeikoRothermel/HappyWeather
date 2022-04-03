//
//  ContentViewController.swift
//  HappyWeather
//
//  Created by Heiko Rothermel on 4/3/22.
//

import UIKit
import CoreLocation

class ContentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    @IBOutlet var myButton: UIButton!
    @IBOutlet var myTableView: UITableView!
    
    var models = [Daily]()
    
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)
        myTableView.delegate = self
        myTableView.dataSource = self
        
        //             Update user interface
                DispatchQueue.main.async {
                    self.myTableView.reloadData()

        //            self.myTableView.tableHeaderView = self.createTableHeader()
                }
        
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
        

        DispatchQueue.main.async {
            self.myTableView.reloadData()
            
//            self.table.tableHeaderView = self.createTableHeader()
        }
            
            
            
        }
        task.resume()
       
        
        
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
        cell.configure(with: models[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    
    
    
    @IBAction func PrintSemthing(_ sender: UIButton) {
        print("hello")
//        setupLocation()
        
    }
    
}



struct WeatherResponse: Codable {
    
//
    let timezone: String
    let daily: [Daily]
    let current: Current
    let hourly: [Hourly]
    
    
}

struct Hourly: Codable {
    var temp: Float
    let dt: Int
    struct Weather: Codable {
        let main: String
    }
    let weather: [Weather]
}





struct Current: Codable {
    let temp: Float
    struct Weather: Codable {
        let main: String
    }
    let weather: [Weather]
    
}

struct Daily: Codable {
    let dt: Int
    let clouds: Int
    let wind_gust: Float
    let pop: Float
    let uvi: Float
    struct Temp: Codable {

        let eve: Float
        let morn: Float
        let max: Float
        let min: Float

    }
    let temp: Temp
    
    struct Weather: Codable {

        let main: String

    }
    let weather: [Weather]
    
}
