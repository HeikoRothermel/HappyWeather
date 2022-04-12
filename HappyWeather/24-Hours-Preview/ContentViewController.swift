//
//  ContentViewController.swift
//  HappyWeather
//
//  Created by Heiko Rothermel on 4/3/22.
//

import UIKit

class ContentViewController: UIViewController, UITableViewDelegate, WeatherTableViewCellDelegate {
    
    
    func didUseTF(with text: String) {
    }
    
    // Defining of TableView: 24
    private let hoursTableView: UITableView = {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .systemBackground
        return tableView
    }()
    
    //Defining of top label -> "24-Stunden-Vorschau"
    private let preview24h: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 84 / 255, green: 166 / 255, blue: 148 / 255, alpha: 1)
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.text = "24-Stunden-Vorschau"
        label.textColor = .white
        return label
    }()
    
    
    var hourlyModels = [Hourly]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 84 / 255, green: 166 / 255, blue: 148 / 255, alpha: 1)
        
        //Adding of top label table view
        view.addSubview(hoursTableView)
        view.addSubview(preview24h)
        
        //Preparing of Table View
        hoursTableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: WeatherTableViewCell.identifier)
        hoursTableView.delegate = self
        hoursTableView.dataSource = self
    }
    
    
    // start functions
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // call function to load/request Data
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.requestWeatherForLocation()
        }
        
    }
    
    
    //Constraints
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //Style for Table View without seperator
        hoursTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        //Adding constraints for both objects
        hoursTableView.frame = CGRect(x: 0, y: 75 * CGFloat(factorHeight), width: view.frame.width, height: view.frame.height - 75 * CGFloat(factorHeight))
        preview24h.frame = CGRect(x: 0, y: 10 * CGFloat(factorHeight), width: view.frame.size.width, height: view.frame.size.height - hoursTableView.frame.size.height - 25 * CGFloat(factorHeight))
        
    }
    
    
    //get hourly Weather Details
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
            DispatchQueue.main.async {
                self.hoursTableView.reloadData()
            }
        }
        task.resume()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
}






// Extension to prepare TableView for Hourly Weather
extension ContentViewController: UITableViewDataSource {
    
    //Defining Number of Cells: 24 Cells for 24 hours
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(hourlyModels.count, 24)
    }
    
    //Defining how cell is configured -> Hourly Weather Forecast
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
        cell.configure(with: hourlyModels[indexPath.row])
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.delegate = self
        return cell
    }
    
    //Defining of cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100 * CGFloat(factorHeight)
    }
    
}
