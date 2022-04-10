//
//  DetailViewController.swift
//  HappyWeather
//
//  Created by Heiko Rothermel on 4/10/22.
//

import UIKit

class DetailViewController: UIViewController {

    private let labelTemp: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.backgroundColor = .white
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .left
        label.clipsToBounds = true
        return label
    }()
    private let labelTemp2: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.backgroundColor = .white
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .left
        label.clipsToBounds = true
        return label
    }()
    
    var test = ""
    var test2 = ""
    
        var sunrise = Int()
        var sunset = Int()
        var moonrise = Int()
        var moonset = Int()
        var moon_phase = Float()
        var day = Float()
        var min = Float()
        var max = Float()
        var night = Float()
        var eve = Float()
        var morn = Float()
        var pressure = Int()
        var humidity = Int()
        var dew_point = Float()
        var wind_speed = Float()
        var wind_deg = Int()
        var wind_gust = Float()
        var id = Int()
        var main = String()
        var _description = String()
        var icon = String()
        var clouds = Int()
        var pop = Float()
        var uvi = Float()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(labelTemp)
        view.addSubview(labelTemp2)
        
        labelTemp.text = test
        labelTemp2.text = test2
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        labelTemp.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height / 2)
        labelTemp2.frame = CGRect(x: 0, y: 500, width: view.frame.size.width, height: view.frame.size.height / 2)
    }
    
}
