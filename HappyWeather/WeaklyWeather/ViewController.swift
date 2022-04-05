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
    @IBOutlet weak var noteTextField: UITextField!
    
    
    private let overviewDailyNotes: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 84 / 255, green: 166 / 255, blue: 148 / 255, alpha: 1)
        return view
    }()
    
    
    private let myTableView: UITableView = {
        let myTableView = UITableView()
        return myTableView
    }()
    
    private let dailyTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Test"
        label.backgroundColor = .white
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    private let dailyNoteLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "TestTest"
        label.backgroundColor = .white
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    
    var fpc: FloatingPanelController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(overviewDailyNotes)
        overviewDailyNotes.addSubview(dailyTimeLabel)
        overviewDailyNotes.addSubview(dailyNoteLabel)
        
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        overviewDailyNotes.frame = CGRect(x: 15, y: view.frame.height / 2, width: view.frame.width - 30, height: (view.frame.height / 2) - 15)
        dailyTimeLabel.frame = CGRect(x: 5, y:  5, width: (overviewDailyNotes.frame.width / 2) - 10, height: overviewDailyNotes.frame.height - 10)
        dailyNoteLabel.frame = CGRect(x: (overviewDailyNotes.frame.width / 2) + 5, y:  5, width: (overviewDailyNotes.frame.width / 2) - 10, height: overviewDailyNotes.frame.height - 10)
    }
   

    
    func floatingPanelWillBeginDragging(_ vc: FloatingPanelController) {
        if arrayTimes.count > 0 {
            dailyTimeLabel.text = "\(arrayTimes[0])"
            dailyNoteLabel.text = "\(dict[Int(exactly: arrayTimes[0])!]!)"
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
        long = currentLocation.coordinate.longitude
        lat = currentLocation.coordinate.latitude
        print("\(lat) | \(long)")
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(long)&units=metric&lang=de&appid=7e5da986d80232efd714c8abf2a1db1b") else {
            return
        }
        urlToUse = url
    }
    
    
    
    @IBAction func TestLoc(_ sender: UIButton) {
        print("\(lat) | \(long)")
    }
    
    @IBAction func TapTextField(_ sender: UITextField) {
//        print("mmmm")
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


