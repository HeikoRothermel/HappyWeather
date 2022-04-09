//
//  ViewController.swift
//  HappyWeather
//
//  Created by Heiko Rothermel on 4/2/22.
//

import UIKit
import FloatingPanel
import CoreLocation





class ViewController: UIViewController, FloatingPanelControllerDelegate, CLLocationManagerDelegate, UITableViewDelegate, UICollectionViewDelegate {
    
    var hourlyModels = [Hourly]()
    var dailyModels = [Daily]()
    var currentModels = [Current]()
//    var entriesHourly: [Hourly] = []
    
    
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
        tableView.showsVerticalScrollIndicator = false
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
    
    
    
    
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collView = UICollectionView(frame: .zero,collectionViewLayout: layout)
        collView.translatesAutoresizingMaskIntoConstraints = false
        collView.backgroundColor = .clear
        collView.isPagingEnabled = true
        collView.showsHorizontalScrollIndicator = false
        return collView
    }()
    
//    private let cityCollectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        let collView = UICollectionView(frame: .zero,collectionViewLayout: layout)
//        collView.translatesAutoresizingMaskIntoConstraints = false
//        collView.backgroundColor = .green
//        return collView
//    }()
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    
    var fpc: FloatingPanelController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print("Höhe: \(view.frame.size.height)")
        print("Breite: \(view.frame.size.width)")
        
        factorWidth = Float(view.frame.size.width / 414)
        factorHeight = Float(view.frame.size.height / 896)
//        overrideUserInterfaceStyle = .dark
        
        
        dailyTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
//        view.addSubview(headerHappyWeather)
        view.addSubview(overviewDailyNotes)
        overviewDailyNotes.addSubview(dailyHeaderLabel)
        overviewDailyNotes.addSubview(dailyTableView)
        overviewDailyNotes.addSubview(dailyInfoLabel)
        overviewDailyNotes.addSubview(alarmButton)
        
        
        view.addSubview(collectionView)
//        view.addSubview(cityCollectionView)
        
        
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
        
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
//        collectionView.register(UINib.init(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CustomCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
//        cityCollectionView.register(CityCollectionViewCell.self, forCellWithReuseIdentifier: CityCollectionViewCell.identifier)
////        cityCollectionView.register(UINib.init(nibName: "CityCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CityCollectionViewCell")
//        cityCollectionView.delegate = self
//        cityCollectionView.dataSource = self
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
                    
            
            
                    dictWeatherForEvents.removeAll()
                    for counter in result.hourly {
                        dictWeatherForEvents[counter.dt] = MultipleValue(temp: counter.temp, main: counter.weather.first!.main)
                    }
            
            DispatchQueue.main.async {
                self.dailyTableView.reloadData()
                self.collectionView.reloadData()
//                self.cityCollectionView.reloadData()
            }
            
               }
                task.resume()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        
        overviewDailyNotes.frame = CGRect(x: 35 * CGFloat(factorWidth), y: (view.frame.height / 2) + 20 * CGFloat(factorHeight), width: view.frame.width - 70 * CGFloat(factorWidth), height: (view.frame.size.height / 2) - 135 * CGFloat(factorHeight))
        dailyInfoLabel.frame = CGRect(x: 10 * CGFloat(factorWidth), y:  60 * CGFloat(factorHeight), width: overviewDailyNotes.frame.width - 20 * CGFloat(factorWidth), height: overviewDailyNotes.frame.height - 70 * CGFloat(factorHeight))
        dailyTableView.frame = dailyInfoLabel.frame
        dailyHeaderLabel.frame = CGRect(x: 15 * CGFloat(factorWidth), y:  20 * CGFloat(factorHeight), width: overviewDailyNotes.frame.width - 30 * CGFloat(factorWidth), height: 35 * CGFloat(factorHeight))
        alarmButton.frame = CGRect(x: overviewDailyNotes.frame.size.width -  75 * CGFloat(factorWidth), y:  15 * CGFloat(factorHeight), width: 60 * CGFloat(factorWidth), height: 60 * CGFloat(factorHeight))
        
        
        collectionView.frame = CGRect(x: 0 * CGFloat(factorWidth), y:  135 * CGFloat(factorHeight), width: view.frame.size.width, height: 325 * CGFloat(factorHeight))
//        cityCollectionView.frame = CGRect(x: 0 * CGFloat(factorWidth), y:  75 * CGFloat(factorHeight), width: view.frame.size.width, height: 75 * CGFloat(factorHeight))
        
        
        
          
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
        upDataDate()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var cells = Int()
        cells = arrayTimes.count
      return cells
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

            let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.identifier, for: indexPath) as? NoteTableViewCell
            cell!.configure(timeOfDay: indexPath.row)
            cell!.selectionStyle = UITableViewCell.SelectionStyle.none

        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        var cellheight = Float()
        
            cellheight = 100
        return CGFloat(cellheight)
    }
    
}



extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height = CGFloat()
        var width = CGFloat()

//        if collectionView == collectionView {
            height = 250  * CGFloat(factorHeight)
            width = view.frame.size.width
//        } else if collectionView == cityCollectionView {
//            height = 50  * CGFloat(factorHeight)
//            width = 250  * CGFloat(factorWidth)
//        }
        return CGSize(width: width , height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var number = Int()
        
//        if collectionView == collectionView {
            number = dailyModels.count
//        } else if collectionView == cityCollectionView {
//            number = shownCities.count
//        }
        return number
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//        let cell = UICollectionViewCell()
//        if collectionView == collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as! CustomCollectionViewCell
    //        cell.data = self.data[indexPath.row]
            cell.configure(with: dailyModels[indexPath.row])
            return cell
//        } else if collectionView == cityCollectionView {
//
//            let cell = cityCollectionView.dequeueReusableCell(withReuseIdentifier: CityCollectionViewCell.identifier, for: indexPath) as! CityCollectionViewCell
//    //        cell.data = self.data[indexPath.row]
//            cell.configure(cities: shownCities[indexPath.row])
//        }
//
//
//        return cell
    }
}



