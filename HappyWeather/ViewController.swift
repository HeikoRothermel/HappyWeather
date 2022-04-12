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
//    var currentModels = [Current]()
    
    
    
//    private let notesView: UIView = {
//        let view = UIView()
//        view.layer.cornerRadius = 25
//        view.layer.shadowColor = UIColor.label.cgColor
//        view.layer.shadowOpacity = 0.20
//        view.layer.shadowOffset = .zero
//        view.layer.shadowRadius = 16
//        view.backgroundColor = .systemBackground
//        return view
//    }()
    
    
    // CollectionView for daily Information -> Folder: DetailedOverviewDailyWeather
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
    
    
    
    
    // Label to show the current location
    private let citiesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.backgroundColor = .clear
        label.text = "Mein Standort"
        label.font = .systemFont(ofSize: 23, weight: .bold)
        return label
    }()
    
    
    
    
    // Objects for Notes/Events -> Folder: NotesTableViewCell
    private let overviewDailyNotes: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 25
        view.layer.shadowColor = UIColor.label.cgColor
        view.layer.shadowOpacity = 0.20
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 16
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private let dailyTableView: UITableView = {
        let tableView = UITableView()
        tableView.clipsToBounds = true
        tableView.showsVerticalScrollIndicator = false
        tableView.layer.cornerRadius = 25
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private let dailyInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "Nutze die 24-Stunden-Vorschau, um Ereignisse hinzuzufügen :)"
        label.numberOfLines = 0
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
    
    

    // Equipment for Localoization
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    //FloatingViewController -> Folder 24-Stunden-Vorschau
    var fpc: FloatingPanelController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Getting data from the previous session
        let defaults = UserDefaults.standard
        arrayTimes = defaults.array(forKey: "saveArray")  as? [Int] ?? [Int]()
        print(arrayTimes)
        
        let defaults4 = UserDefaults.standard
        dictForSavings = defaults4.object(forKey: "saveDict")  as? [String: String] ?? [String: String]()
        print(dictForSavings)
        
        for count in arrayTimes {
            if Int(Date().timeIntervalSince1970) < (count + 3600) {
                let main = dictForSavings["\(count)"]!.components(separatedBy: "-")[1]
                let temp = Float((dictForSavings["\(count)"]?.components(separatedBy: "-")[2] ?? "0.0"))
                let info = dictForSavings["\(count)"]!.components(separatedBy: "-")[0]
                dictEventsNoted[count] = "\(info)"
                dictWeatherForEvents[count] = (temp: Float(temp!), main: main )
            } else {
                if let index = arrayTimes.firstIndex(of: count) {
                    arrayTimes.remove(at: index)
                }
                dictForSavings.removeValue(forKey: "\(count)")
            }
        }
        checkIfNotesExist()
        
        
        //Definition of factors to have proper constraints for all phone sizes
        factorWidth = Float(view.frame.size.width / 414)
        factorHeight = Float(view.frame.size.height / 896)
        
        
        //Adding the Label for Location
        view.addSubview(citiesLabel)
        //Adding the CollectionView for daily Information
        view.addSubview(collectionView)
        //Adding the View for Notes/Events
        view.addSubview(overviewDailyNotes)
        overviewDailyNotes.addSubview(dailyHeaderLabel)
        overviewDailyNotes.addSubview(dailyTableView)
        overviewDailyNotes.addSubview(dailyInfoLabel)
        // FloatingPanel prepared and loaded
        loadingFloatingPanel()
        
        
        //Preparation of CollectionView for daily information...
        dailyTableView.register(NoteTableViewCell.self, forCellReuseIdentifier: NoteTableViewCell.identifier)
        dailyTableView.delegate = self
        dailyTableView.dataSource = self
        // ... and TableView for Notes/Events
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    
    // start functions
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.backgroundColor = .systemBackground
        setupLocation()
        updateData()
        
    }
    
    
    //Constraints
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //Adding constraints for Label for Location
        citiesLabel.frame = CGRect(x: 35 * CGFloat(factorWidth), y:  60 * CGFloat(factorHeight), width: view.frame.size.width - 125 * CGFloat(factorWidth) , height: 50 * CGFloat(factorHeight))
        //Adding constraints for CollectionView for daily Information
        collectionView.frame = CGRect(x: 0 * CGFloat(factorWidth), y:  115 * CGFloat(factorHeight), width: view.frame.size.width, height: 380 * CGFloat(factorHeight))
        //Adding constraints for View for Notes/Events
        overviewDailyNotes.frame = CGRect(x: 35 * CGFloat(factorWidth), y: (view.frame.height / 2) + 60 * CGFloat(factorHeight), width: view.frame.width - 70 * CGFloat(factorWidth), height: (view.frame.size.height / 2) - 170 * CGFloat(factorHeight))
        dailyInfoLabel.frame = CGRect(x: 5 * CGFloat(factorWidth), y:  60 * CGFloat(factorHeight), width: overviewDailyNotes.frame.width - 10 * CGFloat(factorWidth), height: overviewDailyNotes.frame.height - 70 * CGFloat(factorHeight))
        dailyTableView.frame = dailyInfoLabel.frame
        dailyHeaderLabel.frame = CGRect(x: 15 * CGFloat(factorWidth), y:  20 * CGFloat(factorHeight), width: overviewDailyNotes.frame.width - 30 * CGFloat(factorWidth), height: 35 * CGFloat(factorHeight))
        
        //Style for Table View without seperator
        dailyTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    
    //get Latitude and Longitude: I
    func setupLocation() {
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    
    }
    //get Latitude and Longitude: II
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            getLongAndLat()
        }
        
    }
    //get Latitude and Longitude: III
    func getLongAndLat() {
        
        guard let currentLocation = currentLocation else {
            return
        }
        long = currentLocation.coordinate.longitude
        lat = currentLocation.coordinate.latitude
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(long)&units=metric&lang=de&appid=7e5da986d80232efd714c8abf2a1db1b") else {
            return
        }
        urlToUse = url
        
        getCityForLocation()
        
    }
    
    
    // get name of the City
    func getCityForLocation() {
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: lat, longitude:  long)
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, _) -> Void in
            
            placemarks?.forEach { (placemark) in
                if let city = placemark.locality {
                    self.citiesLabel.text = "Mein Standort - \(city)"
                    
                }
                
            }
        })
    }
    
    
    // Function to get data from OpenWeather
    func updateData() {
        
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
            
        }
        task.resume()
        
    }
    
    
    // FloatingPanel prepared and loaded
    func loadingFloatingPanel() {
        
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
        
    }
    // Function to update after moving FloatingPanel
    func floatingPanelWillBeginDragging(_ vc: FloatingPanelController) {
        
        view.endEditing(true)
        checkIfNotesExist()
        updateData()
        
    }
    
    // Testing if a time was saved in the Array for Notes
    func checkIfNotesExist() {
        
        if arrayTimes.count > 0 {
            dailyInfoLabel.isHidden = true
        } else {
            dailyInfoLabel.isHidden = false
        }
        
    }
    
    
    // Reload data after Scrolling the CollectionView
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if collectionView == collectionView {
            collectionView.reloadData()
        }
    }
    

    
    
}


// Layout of Floating Panel
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















// Extension to prepare TableView for Notes/Events
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


// Extension to prepare Collection View for Daily Weather
extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    // Defining Size of CollectionViewCell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height = CGFloat()
        var width = CGFloat()
        height = 380  * CGFloat(factorHeight)
        width = view.frame.size.width
        return CGSize(width: width , height: height)
        
    }
    
    //Defining Number of Collection Cells: Aufgabe -> 5 Tage
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var number = Int()
        number = min(dailyModels.count,5)
        return number
        
    }
    
    //Defining how cell is configured -> Daily Weather Forecast
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as! CustomCollectionViewCell
        cell.configure(with: dailyModels[indexPath.row])
        cell.delegate = self
        cell.parentViewController = self
        return cell
        
    }
    
}



