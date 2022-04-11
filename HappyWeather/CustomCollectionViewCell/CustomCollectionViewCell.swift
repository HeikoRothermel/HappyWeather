//
//  CustomCollectionViewCell.swift
//  HappyWeather
//
//  Created by Heiko Rothermel on 4/9/22.
//

import UIKit

protocol CustomCollectionViewCellDelegate: AnyObject {
    func didTapButton(with title: String)
}


class CustomCollectionViewCell: UICollectionViewCell {
    
    var parentViewController: UIViewController? = nil
    
    weak var delegate: CustomCollectionViewCellDelegate?
    
    static let identifier = "CustomCollectionViewCell"
    
//    typealias dailyMultipleValue = (sunrise: Int, sunset: Int, moonrise: Int, moonset: Int, moon_phase: Float, day: Float, min: Float, max: Float, night: Float, eve: Float, morn: Float, pressure:Int, humidity: Int, dew_point: Float, wind_speed: Float, wind_deg: Int, wind_gust: Float, id: Int, main: String, description: String, icon: String, clouds: Int, pop: Float, uvi: Float)
    typealias dailyMultipleValue = (main: String, description: String)
    var dictDailyWeather = [Int: dailyMultipleValue]()
    
    
    
    
    private let viewWeather: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 25
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
        label.alpha = 0.6
        label.font = .systemFont(ofSize: 28, weight: .medium)
        label.textAlignment = .center
        label.clipsToBounds = true
        label.layer.cornerRadius = 10
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
    
    private let labelDescription: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 118 / 255, green: 113 / 255, blue: 115 / 255, alpha: 1)
        label.backgroundColor = .white
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .left
        label.clipsToBounds = true
        return label
    }()
    
    private let buttonDay: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        return button
    }()
    
    private let viewStackView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let dailyStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        return stackView
    }()
    
    
    
    
    
    private var timeOfDay = Int()
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        contentView.addSubview(viewWeather)
        viewWeather.addSubview(imageWeather)
        viewWeather.addSubview(labelDay)
        imageWeather.addSubview(labelWeather)
        contentView.addSubview(buttonDay)
        
        viewWeather.addSubview(viewStackView)
        viewStackView.addSubview(dailyStackView)
        viewWeather.addSubview(labelDescription)
        
        
        
        buttonDay.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        viewWeather.frame = CGRect(x: (contentView.frame.size.width - 344 * CGFloat(factorWidth)) / 2, y:  25 * CGFloat(factorHeight), width: 340 * CGFloat(factorWidth), height: contentView.frame.size.height - 50 * CGFloat(factorHeight))
        imageWeather.frame = CGRect(x: 0 * CGFloat(factorWidth), y:  0 * CGFloat(factorHeight), width: viewWeather.frame.size.width, height: viewWeather.frame.size.height - 90 * CGFloat(factorHeight))
        labelWeather.frame = CGRect(x: imageWeather.frame.size.width - 130 * CGFloat(factorWidth), y: imageWeather.frame.size.height - 90 * CGFloat(factorHeight), width: 110 * CGFloat(factorWidth), height: 70 * CGFloat(factorHeight))
        labelDay.frame = CGRect(x: 20 * CGFloat(factorWidth), y:  imageWeather.frame.size.height + 2 * CGFloat(factorHeight), width: viewWeather.frame.size.width - 50 * CGFloat(factorWidth) , height: 38 * CGFloat(factorHeight))
        labelDescription.frame = CGRect(x: 20 * CGFloat(factorWidth), y:  imageWeather.frame.size.height + labelDay.frame.size.height, width: viewWeather.frame.size.width - 50 * CGFloat(factorWidth) , height: 20 * CGFloat(factorHeight))
        buttonDay.frame = CGRect(x: 0, y:  0, width: contentView.frame.size.width, height: contentView.frame.size.height)
        
        viewStackView.frame = CGRect(x: 125 * CGFloat(factorWidth), y:   imageWeather.frame.size.height + labelDay.frame.size.height + labelDescription.frame.size.height + 12 * CGFloat(factorHeight), width: viewWeather.frame.size.width - 250 * CGFloat(factorWidth) , height: 6.5 * CGFloat(factorHeight))
        dailyStackView.frame = CGRect(x: 0 * CGFloat(factorWidth), y:  0 * CGFloat(factorHeight), width: viewStackView.frame.size.width , height: viewStackView.frame.size.height)
        dailyStackView.spacing = 5 * CGFloat(factorWidth)
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
        
        labelDescription.text = model.weather.first?.description
        
        let intPoint = Int(getDayForDate(Date(timeIntervalSince1970: TimeInterval(timeOfDay))))! - Int(getDayForDate(Date()))! + 1
        addPointsToStackView(coloredPoint: intPoint)
        
        dictDailyWeather = [timeOfDay: ("\(model.weather.first!.main)", "\(model.weather.first!.description)")]
    }
    
    @objc func buttonClicked(sender: UIButton){
        delegate?.didTapButton(with: String(timeOfDay))
        
        let detailController = DetailViewController()
        detailController.test = "\(timeOfDay)"
        detailController.test2 = "\(dictDailyWeather[timeOfDay]?.description ?? "")"
        
        parentViewController!.present(detailController, animated: true, completion: nil)
        
        
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
    
    func getDayForDate(_ date: Date?) -> String {
        
        guard let inputDate = date else {
            return ""
        }
        
        let formatter = DateFormatter()
            formatter.dateFormat = "DDD"
            return formatter.string(from: inputDate)
        
    }
    
    
    func addPointsToStackView(coloredPoint: Int) {
        
        
        while let oldPoints = dailyStackView.arrangedSubviews.first {
            dailyStackView.removeArrangedSubview(oldPoints)
            oldPoints.removeFromSuperview()
        }
        
        let numberOfPoints = 8
        for count in 1...numberOfPoints {
            let points = StackUIButton()
            if count == coloredPoint {
                points.tintColor = UIColor(red: 84 / 255, green: 166 / 255, blue: 148 / 255, alpha: 1)
            } else {
                points.tintColor = UIColor(red: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 1)
            }
            dailyStackView.addArrangedSubview(points)
        }
    }
    
}
