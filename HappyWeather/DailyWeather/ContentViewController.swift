//
//  ContentViewController.swift
//  HappyWeather
//
//  Created by Heiko Rothermel on 4/3/22.
//

import UIKit

class ContentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet var myTableView: UITableView!
    
    
    var hourlyModels = [Hourly]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)
        myTableView.delegate = self
        myTableView.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.requestWeatherForLocation()
        }
        
    }
    
    
    
    func requestWeatherForLocation() {
        
        
        
        
        
        let task = URLSession.shared.dataTask(with: urlToUse!) { data, _, error in
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
        
        let entries = result.hourly
        
        self.hourlyModels.append(contentsOf: entries)
        for itm in result.hourly {
            print("Value: \(result.timezone) \n \(itm.dt) ,\(itm.weather.first?.main ?? "")")
        }
        DispatchQueue.main.async {
            self.myTableView.reloadData()
        }
       }
        task.resume()
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(hourlyModels.count, 24)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
        cell.configure(with: hourlyModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
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
    var feels_like: Float
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
