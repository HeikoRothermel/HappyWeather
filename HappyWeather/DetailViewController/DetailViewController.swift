//
//  DetailViewController.swift
//  HappyWeather
//
//  Created by Heiko Rothermel on 4/10/22.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate {
    
    
    

    
    private var detailImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 30
        image.layer.shadowColor = UIColor.black.cgColor
        image.layer.shadowOpacity = 0.125
        image.layer.shadowOffset = .zero
        image.layer.shadowRadius = 16
        return image
        }()
    
    private let detailTemp: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.backgroundColor = .white
        label.alpha = 0.7
        label.font = .systemFont(ofSize: 28, weight: .medium)
        label.textAlignment = .center
        label.clipsToBounds = true
        label.layer.cornerRadius = 20
        return label
    }()
    
    
    
    
    private let detailViewWhite: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 25
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.125
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 16
        view.backgroundColor = .white
        return view
    }()
    
    private let detailDescription: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .left
        label.clipsToBounds = true
        label.textColor = UIColor(red: 118 / 255, green: 113 / 255, blue: 115 / 255, alpha: 1)
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private let detailTop: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        label.clipsToBounds = true
        label.backgroundColor = .clear
        return label
    }()
    
    private let detailViewTurquoise: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 25
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.125
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 16
        view.backgroundColor = UIColor(red: 84 / 255, green: 166 / 255, blue: 148 / 255, alpha: 1)
        return view
    }()
    
    
    
    
    
    
    
    
    
    
    private let detailTableView: UITableView = {
        let tableView = UITableView()
        tableView.clipsToBounds = true
        tableView.showsVerticalScrollIndicator = false
        tableView.layer.cornerRadius = 25
        tableView.backgroundColor = UIColor(red: 84 / 255, green: 166 / 255, blue: 148 / 255, alpha: 1)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        return tableView
    }()
    
    
    
        
    var pressure = Int()
    var humidity = Int()
    var wind_speed = Float()
    var arrayDetails = ["Feuchtigkeit:","Windgeschwindigkeit:","Luftdruck:"]
    var arrayDetails2 = [Int]()
    
    var dt: Int = Int()
    var max = Float()
    var main = String()
    var _description = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(detailImage)
        detailImage.addSubview(detailTemp)
        
        view.addSubview(detailViewWhite)
        detailViewWhite.addSubview(detailViewTurquoise)
        detailViewWhite.addSubview(detailTop)
        detailViewWhite.addSubview(detailDescription)
        
        detailViewTurquoise.addSubview(detailTableView)
        
        detailTop.text = "Top Details"
        detailDescription.text = _description
        detailTemp.text = "\(Int(max))°"
        
        let image = main.lowercased()
        if image.contains("cloud") {
            self.detailImage.image = UIImage(named: "fotoCloud")
        } else if image.contains("rain") {
            self.detailImage.image = UIImage(named: "fotoRain")
        } else if image.contains("snow") {
            self.detailImage.image = UIImage(named: "fotoSnow")
        } else {
            self.detailImage.image = UIImage(named: "fotoSun")
        }
        
        arrayDetails2 = [humidity,Int(wind_speed),pressure]
        
        detailTableView.register(DetailTableViewCell.self, forCellReuseIdentifier: DetailTableViewCell.identifier)
        detailTableView.delegate = self
        detailTableView.dataSource = self
        
        
        detailTableView.reloadData()
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        detailImage.frame = CGRect(x: 0 * CGFloat(factorWidth), y: -20 * CGFloat(factorHeight), width: view.frame.size.width, height: view.frame.size.height / 2)
        detailTemp.frame = CGRect(x: detailImage.frame.size.width - 150 * CGFloat(factorWidth), y: detailImage.frame.size.height - 100 * CGFloat(factorHeight), width: 125 * CGFloat(factorWidth), height: 75 * CGFloat(factorHeight))
        
        
        detailViewWhite.frame = CGRect(x: 35 * CGFloat(factorWidth), y: (view.frame.size.height / 2) + 15 * CGFloat(factorHeight), width: view.frame.size.width - 70  * CGFloat(factorWidth), height: (view.frame.size.height / 2) - 70 * CGFloat(factorHeight))
        detailTop.frame = CGRect(x: 25 * CGFloat(factorWidth), y: 15 * CGFloat(factorHeight), width: detailViewWhite.frame.size.width - 50  * CGFloat(factorWidth), height: 40 * CGFloat(factorHeight))
        detailDescription.frame = CGRect(x: 25 * CGFloat(factorWidth), y: detailTop.frame.size.height + 15 * CGFloat(factorHeight), width: detailViewWhite.frame.size.width - 50  * CGFloat(factorWidth), height: 25 * CGFloat(factorHeight))
        detailViewTurquoise.frame = CGRect(x: 0 * CGFloat(factorWidth), y: 100 * CGFloat(factorHeight), width: detailViewWhite.frame.size.width , height: detailViewWhite.frame.size.height - 100 * CGFloat(factorHeight))
        
        
        detailTableView.frame = CGRect(x: 0 * CGFloat(factorWidth), y: 0 * CGFloat(factorHeight), width: detailViewTurquoise.frame.size.width , height: detailViewTurquoise.frame.size.height )
    }
    
}

extension DetailViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayDetails.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let arrayCount = arrayDetails.count
        let height = detailViewTurquoise.frame.size.height / CGFloat(arrayCount)
        return height
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.identifier, for: indexPath) as! DetailTableViewCell
        cell.configure(with: arrayDetails[indexPath.row], and: arrayDetails2[indexPath.row])
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
}
