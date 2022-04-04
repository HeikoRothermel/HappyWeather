//
//  ContentViewController.swift
//  HappyWeather
//
//  Created by Heiko Rothermel on 4/3/22.
//

import UIKit

class ContentViewController: UIViewController, UITableViewDelegate, WeatherTableViewCellDelegate {
    
    
    
    

    
//    @IBOutlet var myTableView: UITableView!
    
    
    private let myTableView: UITableView = {
        let myTableView = UITableView()
        return myTableView
    }()
    
    private let preview24h: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 84 / 255, green: 166 / 255, blue: 148 / 255, alpha: 1)
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.text = "24-Stunden-Vorschau"
        return label
    }()
   
    
    var hourlyModels = [Hourly]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(myTableView)
        view.addSubview(preview24h)
        
        myTableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: WeatherTableViewCell.identifier)
        myTableView.delegate = self
        myTableView.dataSource = self
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.requestWeatherForLocation()
        }
        
    }
    
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        myTableView.frame = CGRect(x: 0, y: 75, width: view.frame.width, height: view.frame.height - 75)
        preview24h.frame = CGRect(x: 0, y: 10, width: view.frame.size.width, height: view.frame.size.height - myTableView.frame.size.height - 10)
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
    
    
    func didTapButton(with title: String) {
//        print("\(title)")
        if title == "5" {
            print("yes")
        }
    }
}





extension ContentViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(hourlyModels.count, 24)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
        cell.configure(with: hourlyModels[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    
    
    
}

extension ViewController: WeatherTableViewCellDelegate {
    func didTapButton(with title: String) {
        print("(\(title)")
    }
}







