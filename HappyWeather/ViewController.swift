//
//  ViewController.swift
//  HappyWeather
//
//  Created by Heiko Rothermel on 4/2/22.
//

import UIKit
import FloatingPanel
import CoreLocation





class ViewController: UIViewController, FloatingPanelControllerDelegate, CLLocationManagerDelegate, UITableViewDelegate, UICollectionViewDelegate, CustomCollectionViewCellDelegate, UIScrollViewDelegate {
    
    func didTapButton(with title: String) {
    }
    
    
    var hourlyModels = [Hourly]()
    var dailyModels = [Daily]()
    var currentModels = [Current]()
    
    var cities = ["","Mein Standort", "Berlin", "Hamburg", "🔍"]
    

    
    private let buttonActualization: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor(red: 84 / 255, green: 166 / 255, blue: 148 / 255, alpha: 1)
        button.setImage(UIImage(systemName: "arrow.2.circlepath.circle.fill"), for: .normal)
        button.isHidden = false
        button.layer.cornerRadius = 15
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.125
        button.layer.shadowOffset = .zero
        button.layer.shadowRadius = 16
        button.backgroundColor = .white
        return button
    }()
    
    
// DailyView
    private let overviewDailyNotes: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 25
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
        tableView.layer.cornerRadius = 25
        return tableView
    }()
    
    private let dailyInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Füge deine Ereignisse hinzu :)"
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textAlignment = .center
        label.clipsToBounds = true
        label.layer.cornerRadius = 25
        return label
    }()
    
    
    private let dailyHeaderLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 84 / 255, green: 166 / 255, blue: 148 / 255, alpha: 1)
        label.text = "Übersicht deiner Events:"
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 22, weight: .bold)
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
    
    
    private let citiesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 5 * CGFloat(factorWidth)
        return stackView
    }()
    
    private let citiesScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    
    var fpc: FloatingPanelController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.resetStandardUserDefaults()
        
        

        let defaults = UserDefaults.standard
        arrayTimes = defaults.array(forKey: "saveArray")  as? [Int] ?? [Int]()
        print(arrayTimes)

        let defaults4 = UserDefaults.standard
        dictForSavings = defaults4.object(forKey: "saveDict")  as? [String: String] ?? [String: String]()
        print(dictForSavings)
        
        
        
        
        
        for count in arrayTimes {
            let main = dictForSavings["\(count)"]!.components(separatedBy: "-")[1]
            let temp = Float((dictForSavings["\(count)"]?.components(separatedBy: "-")[2] ?? "0.0"))
            let info = dictForSavings["\(count)"]!.components(separatedBy: "-")[0]
            
            
            dictEventsNoted[count] = "\(info)"
            dictWeatherForEvents[count] = (temp: Float(temp!), main: main )
        }
        
//        overrideUserInterfaceStyle = .dark
        
        factorWidth = Float(view.frame.size.width / 414)
        factorHeight = Float(view.frame.size.height / 896)
        
        
        dailyTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        view.addSubview(overviewDailyNotes)
        overviewDailyNotes.addSubview(dailyHeaderLabel)
        overviewDailyNotes.addSubview(dailyTableView)
        overviewDailyNotes.addSubview(dailyInfoLabel)
        overviewDailyNotes.addSubview(alarmButton)
        
        view.addSubview(citiesScrollView)
        citiesScrollView.addSubview(citiesStackView)
        
        view.addSubview(collectionView)
        
        view.addSubview(buttonActualization)
        
        alarmButton.addTarget(self, action: #selector(alarmButtonClicked(sender:)), for: .touchUpInside)
        buttonActualization.addTarget(self, action: #selector(actualizeData(sender:)), for: .touchUpInside)
        
        
        addCitiesToStackView(coloredCity: 2)
        
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
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        
        overviewDailyNotes.frame = CGRect(x: 35 * CGFloat(factorWidth), y: (view.frame.height / 2) + 60 * CGFloat(factorHeight), width: view.frame.width - 70 * CGFloat(factorWidth), height: (view.frame.size.height / 2) - 170 * CGFloat(factorHeight))
        dailyInfoLabel.frame = CGRect(x: 5 * CGFloat(factorWidth), y:  60 * CGFloat(factorHeight), width: overviewDailyNotes.frame.width - 10 * CGFloat(factorWidth), height: overviewDailyNotes.frame.height - 70 * CGFloat(factorHeight))
        dailyTableView.frame = dailyInfoLabel.frame
        dailyHeaderLabel.frame = CGRect(x: 15 * CGFloat(factorWidth), y:  20 * CGFloat(factorHeight), width: overviewDailyNotes.frame.width - 30 * CGFloat(factorWidth), height: 35 * CGFloat(factorHeight))
        alarmButton.frame = CGRect(x: overviewDailyNotes.frame.size.width -  75 * CGFloat(factorWidth), y:  15 * CGFloat(factorHeight), width: 60 * CGFloat(factorWidth), height: 60 * CGFloat(factorHeight))
        
        collectionView.frame = CGRect(x: 0 * CGFloat(factorWidth), y:  115 * CGFloat(factorHeight), width: view.frame.size.width, height: 380 * CGFloat(factorHeight))
        
        buttonActualization.frame = CGRect(x: 50 * CGFloat(factorWidth), y:  50 * CGFloat(factorHeight), width: 50 * CGFloat(factorWidth), height: 50 * CGFloat(factorHeight))
        
        citiesScrollView.frame = CGRect(x: 35 * CGFloat(factorWidth), y:  55 * CGFloat(factorHeight), width: view.frame.size.width - 70 * CGFloat(factorWidth) , height: 75 * CGFloat(factorHeight))
        
        citiesStackView.translatesAutoresizingMaskIntoConstraints = false
        citiesStackView.topAnchor.constraint(equalTo: citiesScrollView.topAnchor).isActive = true
        citiesStackView.leadingAnchor.constraint(equalTo: citiesScrollView.leadingAnchor).isActive = true
        citiesStackView.trailingAnchor.constraint(equalTo: citiesScrollView.trailingAnchor).isActive = true
        citiesStackView.heightAnchor.constraint(equalTo: citiesScrollView.heightAnchor).isActive = true
        
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
            }
            print(json?.current.temp ?? "")
            
               }
                task.resume()
    }
    
    func floatingPanelWillBeginDragging(_ vc: FloatingPanelController) {
        if arrayTimes.count > 0 {
            dailyInfoLabel.isHidden = true
//            alarmButton.isHidden = false
        } else {
            dailyInfoLabel.isHidden = false
//            alarmButton.isHidden = true
        }
        
        view.endEditing(true)
        
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if collectionView == collectionView {
            collectionView.reloadData()
        }
    }
    
    @objc func alarmButtonClicked(sender: UIButton){
        
        alarmButton.tintColor = UIColor(red: 84 / 255, green: 166 / 255, blue: 148 / 255, alpha: 1)
    
    }
    
    @objc func actualizeData(sender: UIButton) {
        
        setupLocation()
        upDataDate()
        
    }
    
   
    func addCitiesToStackView(coloredCity: Int) {
        
        
        while let oldCities = citiesStackView.arrangedSubviews.first {
            citiesStackView.removeArrangedSubview(oldCities)
            oldCities.removeFromSuperview()
        }
        
        let numberOfCities = cities.count
        for count in 1...numberOfCities {
            
            let citiesToShow = CitiesButton()
            citiesToShow.setTitle("\(cities[count - 1])", for: .normal)
            if count == coloredCity {
                citiesToShow.setTitleColor(UIColor(red: 84 / 255, green: 166 / 255, blue: 148 / 255, alpha: 1), for: .normal)
                citiesToShow.titleLabel!.font = UIFont.boldSystemFont(ofSize: 17)
            } else {
                citiesToShow.setTitleColor(UIColor(red: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 1), for: .normal)
                citiesToShow.titleLabel!.font = UIFont.systemFont(ofSize: 15)
            }
            citiesStackView.addArrangedSubview(citiesToShow)
        }
    }
    
}
    
class MyFloatingPanelLayout: FloatingPanelLayout {
    
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .tip
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .full: FloatingPanelLayoutAnchor(absoluteInset: 50.0 * CGFloat(factorHeight), edge: .top, referenceGuide: .superview),
            .tip: FloatingPanelLayoutAnchor(absoluteInset: 75.0 * CGFloat(factorHeight), edge: .bottom, referenceGuide: .superview),
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
        cellheight = Float(100 * CGFloat(factorHeight))
        return CGFloat(cellheight)
        
    }
    
}



extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height = CGFloat()
        var width = CGFloat()
        height = 380  * CGFloat(factorHeight)
        width = view.frame.size.width
        return CGSize(width: width , height: height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var number = Int()
        number = dailyModels.count
        return number
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as! CustomCollectionViewCell
        cell.configure(with: dailyModels[indexPath.row])
        cell.delegate = self
        cell.parentViewController = self
        return cell
        
    }
    
}



