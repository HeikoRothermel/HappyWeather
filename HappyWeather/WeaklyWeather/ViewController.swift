//
//  ViewController.swift
//  HappyWeather
//
//  Created by Heiko Rothermel on 4/2/22.
//

import UIKit
import FloatingPanel
import CoreLocation


class ViewController: UIViewController, FloatingPanelControllerDelegate, CLLocationManagerDelegate, UITableViewDelegate {
    

    

    
    var hourlyModels = [Hourly]()
    var dailyModels = [Daily]()
    var currentModels = [Current]()
    var entriesHourly: [Hourly] = []
    
    
    
    
// DailyView
    private let overviewDailyNotes: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 25
//        view.layer.borderWidth = 3
//        view.layer.borderColor = CGColor(red: 84 / 255, green: 166 / 255, blue: 148 / 255, alpha: 1)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.125
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 16
        view.backgroundColor = .white
        return view
    }()
    
    
    private let dailyTableView: UITableView = {
        let tableView = UITableView()
        tableView.clipsToBounds = true
        return tableView
    }()
    
    private let dailyInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Füge neue Ereignisse hinzu, \n um dein Wetter direkt zu sehen..."
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textAlignment = .center
        label.clipsToBounds = true
        return label
    }()
    
    
    private let dailyHeaderLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 84 / 255, green: 166 / 255, blue: 148 / 255, alpha: 1)
        label.text = "Übersicht deiner Events:"
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let alarmButton: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor(red: 239 / 255, green: 239 / 255, blue: 244 / 255, alpha: 1)
        button.setImage(UIImage(systemName: "alarm"), for: .normal)
        button.isHidden = true
        return button
    }()
    
    
    
    
    
    //    WeeklyView
        private let overviewTableViewForCollectionView: UITableView = {
            let tableView = UITableView()
            tableView.layer.cornerRadius = 25
            tableView.layer.shadowColor = UIColor.black.cgColor
            tableView.layer.shadowOpacity = 0.125
            tableView.layer.shadowOffset = .zero
            tableView.layer.shadowRadius = 16
            tableView.backgroundColor = .clear
            tableView.layer.borderWidth = 3
            tableView.layer.borderColor = CGColor(red: 84 / 255, green: 166 / 255, blue: 148 / 255, alpha: 1)
            return tableView
        }()
    

    
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    
    var fpc: FloatingPanelController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        overrideUserInterfaceStyle = .dark
        
        
        dailyTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
//        view.addSubview(headerHappyWeather)
        view.addSubview(overviewDailyNotes)
        overviewDailyNotes.addSubview(dailyHeaderLabel)
        overviewDailyNotes.addSubview(dailyTableView)
        overviewDailyNotes.addSubview(dailyInfoLabel)
        overviewDailyNotes.addSubview(alarmButton)
        
        
        view.addSubview(overviewTableViewForCollectionView)
        
        alarmButton.addTarget(self, action: #selector(alarmButtonClicked(sender:)), for: .touchUpInside)
        
        let fpc = FloatingPanelController()
        fpc.delegate = self
        fpc.layout = MyFloatingPanelLayout()
        guard let contentVC = storyboard?.instantiateViewController(identifier: "FloatingPanelControler_content") as? ContentViewController else {
            return
        }
        let appearance = SurfaceAppearance()
        let shadow = SurfaceAppearance.Shadow()
        shadow.color = UIColor.black
        shadow.offset = CGSize(width: 0, height: 16)
        shadow.radius = 16
        shadow.spread = 8
        appearance.shadows = [shadow]
        appearance.cornerRadius = 40
        appearance.backgroundColor = .white
        fpc.surfaceView.appearance = appearance
        fpc.set(contentViewController: contentVC)
        fpc.addPanel(toParent: self)
        
        
        
        dailyTableView.register(NoteTableViewCell.self, forCellReuseIdentifier: NoteTableViewCell.identifier)
        dailyTableView.delegate = self
        dailyTableView.dataSource = self
        
        overviewTableViewForCollectionView.register(DailyTableViewCell.self, forCellReuseIdentifier: DailyTableViewCell.identifier)
        overviewTableViewForCollectionView.delegate = self
        overviewTableViewForCollectionView.dataSource = self
        
        upDataDate()
    }
    
    func upDataDate() {
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

                let entriesHourly = result.hourly
                self.hourlyModels.append(contentsOf: entriesHourly)
                    
                    let entriesDaily = result.daily
                    self.dailyModels.append(contentsOf: entriesDaily)
                    
            
            DispatchQueue.main.async {
                self.overviewTableViewForCollectionView.reloadData()
                self.dailyTableView.reloadData()
            }
            
                    dictWeatherForEvents.removeAll()
                    for counter in result.hourly {
                        dictWeatherForEvents[counter.dt] = MultipleValue(temp: counter.temp, main: counter.weather.first!.main)
                    }
            
               }
                task.resume()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        
        overviewDailyNotes.frame = CGRect(x: 60, y: (view.frame.height / 2) + 85, width: view.frame.width - 120, height: (view.frame.size.height / 2) - 200)
        dailyInfoLabel.frame = CGRect(x: 10, y:  60, width: overviewDailyNotes.frame.width - 20, height: overviewDailyNotes.frame.height - 70)
        dailyTableView.frame = dailyInfoLabel.frame
        dailyHeaderLabel.frame = CGRect(x: 15, y:  20, width: overviewDailyNotes.frame.width - 30, height: 35)
        alarmButton.frame = CGRect(x: overviewDailyNotes.frame.size.width -  75, y:  15, width: 60, height: 60)
        
        
        
        overviewTableViewForCollectionView.frame = CGRect(x: 0, y:  150, width: view.frame.width, height: (view.frame.size.height / 2) - 100)
          
    }
   

    
    func floatingPanelWillBeginDragging(_ vc: FloatingPanelController) {
        if arrayTimes.count > 0 {
            dailyInfoLabel.isHidden = true
            alarmButton.isHidden = false
        } else {
            dailyInfoLabel.isHidden = false
            alarmButton.isHidden = true
        }
        
        
        
        upDataDate()
       
                    
                    
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
        long = currentLocation.coordinate.longitude
        lat = currentLocation.coordinate.latitude
        print("\(lat) | \(long)")
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(long)&units=metric&lang=de&appid=7e5da986d80232efd714c8abf2a1db1b") else {
            return
        }
        urlToUse = url
        
        
        upDataDate()
        
    }
    
    
    

    
        @objc func alarmButtonClicked(sender: UIButton){
            alarmButton.tintColor = UIColor(red: 84 / 255, green: 166 / 255, blue: 148 / 255, alpha: 1)
        }
    
    
}
    
class MyFloatingPanelLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .tip
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .full: FloatingPanelLayoutAnchor(absoluteInset: 50.0, edge: .top, referenceGuide: .superview),
            .tip: FloatingPanelLayoutAnchor(absoluteInset: 75.0, edge: .bottom, referenceGuide: .superview),
        ]
    }
}


extension ViewController: UITableViewDataSource {
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var cells = Int()
        if tableView == overviewTableViewForCollectionView {
            cells = 1
        } else if tableView == dailyTableView {
            cells = arrayTimes.count
        }
        
        return cells
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()

        if tableView == overviewTableViewForCollectionView {
            let cell = tableView.dequeueReusableCell(withIdentifier: DailyTableViewCell.identifier, for: indexPath) as? DailyTableViewCell
            cell!.configure(with: entriesHourly)
            cell!.selectionStyle = UITableViewCell.SelectionStyle.none
       } else if tableView == dailyTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.identifier, for: indexPath) as? NoteTableViewCell
            cell!.configure(timeOfDay: indexPath.row)
            cell!.selectionStyle = UITableViewCell.SelectionStyle.none
       }
        
        return cell
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var cellheight = Float()

        if tableView == overviewTableViewForCollectionView {
            cellheight = 100
        } else if tableView == dailyTableView {
            cellheight = 100
        }

        return CGFloat(cellheight)
    }
    
    
    
    
}





