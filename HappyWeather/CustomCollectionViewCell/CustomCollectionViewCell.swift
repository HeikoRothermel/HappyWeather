//
//  CustomCollectionViewCell.swift
//  HappyWeather
//
//  Created by Heiko Rothermel on 4/9/22.
//

import UIKit


class CustomCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CustomCollectionViewCell"
    
//    static func nib() -> UINib {
//               return UINib(nibName: "CustomCollectionViewCell", bundle: nil)
//           }
    private let viewWeather: UIView = {
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
    
    private var imageWeather: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 20
        return image
        }()
    
    private let labelWeather: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.backgroundColor = .white
        label.alpha = 0.5
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
        label.clipsToBounds = true
        label.layer.cornerRadius = 15
        return label
    }()
    
    private let labelDay: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.backgroundColor = .white
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .left
        label.clipsToBounds = true
        label.backgroundColor = .clear
        return label
    }()
    
//    private let buttonDay: UIButton = {
//        let button = UIButton()
//        label.textColor = .black
//        label.backgroundColor = .white
//        label.font = .systemFont(ofSize: 20, weight: .medium)
//        label.textAlignment = .left
//        label.clipsToBounds = true
//        label.backgroundColor = .clear
//        return label
//    }()
    
    
    private var timeOfDay = Int()
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        contentView.addSubview(viewWeather)
        viewWeather.addSubview(imageWeather)
        viewWeather.addSubview(labelDay)
        imageWeather.addSubview(labelWeather)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        viewWeather.frame = CGRect(x: (contentView.frame.size.width - 250 * CGFloat(factorWidth)) / 2, y:  0 * CGFloat(factorHeight), width: 250 * CGFloat(factorWidth), height: contentView.frame.size.height)
        imageWeather.frame = CGRect(x: 0 * CGFloat(factorWidth), y:  0 * CGFloat(factorHeight), width: viewWeather.frame.size.width, height: viewWeather.frame.size.height - 75 * CGFloat(factorHeight))
        labelWeather.frame = CGRect(x: imageWeather.frame.size.width - 100 * CGFloat(factorWidth), y:  20 * CGFloat(factorHeight), width: 80 * CGFloat(factorWidth), height: 40 * CGFloat(factorHeight))
        labelDay.frame = CGRect(x: 10 * CGFloat(factorWidth), y:  imageWeather.frame.size.height, width: viewWeather.frame.size.width - 20 * CGFloat(factorWidth) , height: viewWeather.frame.size.height - imageWeather.frame.size.height - 20 * CGFloat(factorHeight))
    }
    
    
    
    func configure(with model: Daily) {
        
        self.timeOfDay = model.dt
        var today = Int()
        today = Int(Date().timeIntervalSince1970) - (Int(getHourForDate(Date()))! + 1)  * 3600
        if timeOfDay - today < (3600 * 24) {
            self.labelDay.text = "Heute"
        } else if timeOfDay - today < (3600 * 48) {
            self.labelDay.text = "Morgen"
        } else if timeOfDay - today < (3600 * 72) {
            self.labelDay.text = "Übermorgen"
        } else {
            self.labelDay.text = "\(getDateForDate(Date(timeIntervalSince1970: TimeInterval(timeOfDay))))"
        }
        
        labelWeather.text = "\(Int(model.temp.max))°"
        imageWeather.image = UIImage(systemName: "cloud.fill")
        
        let icon  = model.weather.first?.main.lowercased()  ?? ""
        if icon.contains("cloud") {
            self.imageWeather.image = UIImage(named: "fotoCloud")
        } else if icon.contains("rain") {
            self.imageWeather.image = UIImage(named: "fotoRain")
        } else if icon.contains("snow") {
            self.imageWeather.image = UIImage(named: "fotoSnow")
        } else {
            self.imageWeather.image = UIImage(named: "fotoSun")
        }
        
    }
    
    func getHourForDate(_ date: Date?) -> String {
        
        guard let inputDate = date else {
            return ""
        }
        
        let formatter = DateFormatter()
            formatter.dateFormat = "H"
            return formatter.string(from: inputDate)
        }
    
    func getDateForDate(_ date: Date?) -> String {
        
        guard let inputDate = date else {
            return ""
        }
        
        let formatter = DateFormatter()
            formatter.dateFormat = "EEEE, dd.MM.yyyy"
            return formatter.string(from: inputDate)
        
    }
    
}






