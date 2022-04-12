//
//  CustomCollectionViewCell.swift
//  HappyWeather
//
//  Created by Heiko Rothermel on 4/9/22.
//

import UIKit

//function needed for collectionview reasons: to connect button to image
protocol CustomCollectionViewCellDelegate: AnyObject {
    func didTapButton(with title: String)
}


class CustomCollectionViewCell: UICollectionViewCell {
    
    
    var parentViewController: UIViewController? = nil
    weak var delegate: CustomCollectionViewCellDelegate?
    
    static let identifier = "CustomCollectionViewCell"
    
    
    // dictionary for saving from data -> needed for DetailedOverviewDailyWeather
    typealias dailyMultipleValue = (max: Float, pressure:Int, humidity: Int, wind_speed: Float,  main: String, description: String)
    var dictDailyWeather = [Int: dailyMultipleValue]()
    
    
    
    //View with all different Images/Labels/StackViews
    private let viewWeather: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 25
        view.layer.shadowColor = UIColor.label.cgColor
        view.layer.shadowOpacity = 0.20
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 16
        view.backgroundColor = .systemBackground
        return view
    }()
    
    //Image
    private var imageWeather: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 20
        return image
    }()
    
    //Temperature
    private let labelTemperature: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.backgroundColor = .white
        label.alpha = 0.6
        label.font = .systemFont(ofSize: 28, weight: .medium)
        label.textAlignment = .center
        label.clipsToBounds = true
        label.layer.cornerRadius = 15
        return label
    }()
    
    //Label for Day/Date
    private let labelDay: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .left
        label.clipsToBounds = true
        label.backgroundColor = .clear
        return label
    }()
    
    //Label for more detailed description of weather
    private let labelDescription: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .left
        label.clipsToBounds = true
        return label
    }()
    
    // button to be pressed to get to  -> DetailedOverviewDailyWeather
    private let buttonDay: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        return button
    }()
    
    //StackView for Scrolling Points
    private let viewStackView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    //Scrolling Points
    private let dailyStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    
    private var timeOfDay = Int()
    
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        
        // add different Views/Lavels/Images/StackViews/Buttons View
        contentView.addSubview(viewWeather)
        viewWeather.addSubview(imageWeather)
        viewWeather.addSubview(labelDay)
        imageWeather.addSubview(labelTemperature)
        contentView.addSubview(buttonDay)
        
        viewWeather.addSubview(viewStackView)
        viewStackView.addSubview(dailyStackView)
        viewWeather.addSubview(labelDescription)
        
        
        //Function for button -> DetailedOverviewDailyWeather
        buttonDay.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //constraints
    override func layoutSubviews() {
        super.layoutSubviews()
        
        viewWeather.frame = CGRect(x: (contentView.frame.size.width - 344 * CGFloat(factorWidth)) / 2, y:  25 * CGFloat(factorHeight), width: 340 * CGFloat(factorWidth), height: contentView.frame.size.height - 50 * CGFloat(factorHeight))
        imageWeather.frame = CGRect(x: 0 * CGFloat(factorWidth), y:  0 * CGFloat(factorHeight), width: viewWeather.frame.size.width, height: viewWeather.frame.size.height - 90 * CGFloat(factorHeight))
        labelTemperature.frame = CGRect(x: imageWeather.frame.size.width - 130 * CGFloat(factorWidth), y: imageWeather.frame.size.height - 90 * CGFloat(factorHeight), width: 110 * CGFloat(factorWidth), height: 70 * CGFloat(factorHeight))
        labelDay.frame = CGRect(x: 20 * CGFloat(factorWidth), y:  imageWeather.frame.size.height + 2 * CGFloat(factorHeight), width: viewWeather.frame.size.width - 50 * CGFloat(factorWidth) , height: 38 * CGFloat(factorHeight))
        labelDescription.frame = CGRect(x: 20 * CGFloat(factorWidth), y:  imageWeather.frame.size.height + labelDay.frame.size.height, width: viewWeather.frame.size.width - 50 * CGFloat(factorWidth) , height: 20 * CGFloat(factorHeight))
        buttonDay.frame = CGRect(x: 0, y:  0, width: contentView.frame.size.width, height: contentView.frame.size.height)
        
        viewStackView.frame = CGRect(x: 130 * CGFloat(factorWidth), y:   imageWeather.frame.size.height + labelDay.frame.size.height + labelDescription.frame.size.height + 12 * CGFloat(factorHeight), width: viewWeather.frame.size.width - 260 * CGFloat(factorWidth) , height: 6.5 * CGFloat(factorHeight))
        dailyStackView.frame = CGRect(x: 0 * CGFloat(factorWidth), y:  0 * CGFloat(factorHeight), width: viewStackView.frame.size.width , height: viewStackView.frame.size.height)
        dailyStackView.spacing = 12 * CGFloat(factorWidth)
    }
    
    
    
    func configure(with model: Daily) {
        
        //get value for time to recognize cell
        self.timeOfDay = model.dt
        
        // set time/day
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
        
        // set temperature
        labelTemperature.text = "\(Int(model.temp.max))°"
        imageWeather.image = UIImage(systemName: "cloud.fill")
        
        // set Photo related to "main"
        let image  = model.weather.first?.main.lowercased()  ?? ""
        if image.contains("cloud") {
            self.imageWeather.image = UIImage(named: "fotoCloud")
        } else if image.contains("rain") {
            self.imageWeather.image = UIImage(named: "fotoRain")
        } else if image.contains("snow") {
            self.imageWeather.image = UIImage(named: "fotoSnow")
        } else {
            self.imageWeather.image = UIImage(named: "fotoSun")
        }
        
        // set detailed Weather information below day label
        labelDescription.text = model.weather.first?.description
        
        //coloring the ScrollView points
        let intPoint = Int(getDayForDate(Date(timeIntervalSince1970: TimeInterval(timeOfDay))))! - Int(getDayForDate(Date()))! + 1
        addPointsToStackView(coloredPoint: intPoint)
        
        // prepare data for -> DetailedOverviewDailyWeather
        dictDailyWeather = [timeOfDay: (model.temp.max, model.pressure, model.humidity, model.wind_speed, "\(model.weather.first!.main)", "\(model.weather.first!.description)")]
    }
    
    
    //function when transparent button is clicked
    @objc func buttonClicked(sender: UIButton){
        delegate?.didTapButton(with: String(timeOfDay))
        
        //adding data to -> DetailedOverviewDailyWeather
        let detailController = DetailViewController()
        
        detailController.dt = timeOfDay
        detailController.max = dictDailyWeather[timeOfDay]?.max ?? 0.0
        detailController.pressure = dictDailyWeather[timeOfDay]?.pressure ?? 0
        detailController.humidity = dictDailyWeather[timeOfDay]?.humidity ?? 0
        detailController.wind_speed = dictDailyWeather[timeOfDay]?.wind_speed ?? 0.0
        detailController.main = "\(dictDailyWeather[timeOfDay]?.main ?? "")"
        detailController._description = "\(dictDailyWeather[timeOfDay]?.description ?? "")"
        
        parentViewController!.present(detailController, animated: true, completion: nil)
        
    }
    
    // getting Hours out of dt
    func getHourForDate(_ date: Date?) -> String {
        
        guard let inputDate = date else {
            return ""
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "H"
        return formatter.string(from: inputDate)
    }
    
    //getting Date out of dt
    func getDateForDate(_ date: Date?) -> String {
        
        guard let inputDate = date else {
            return ""
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, dd.MM.yyyy"
        return formatter.string(from: inputDate)
        
    }
    
    // getting Day out of dt
    func getDayForDate(_ date: Date?) -> String {
        
        guard let inputDate = date else {
            return ""
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "DDD"
        return formatter.string(from: inputDate)
        
    }
    
    // function to set color the ScrollView points
    func addPointsToStackView(coloredPoint: Int) {
        
        
        while let oldPoints = dailyStackView.arrangedSubviews.first {
            dailyStackView.removeArrangedSubview(oldPoints)
            oldPoints.removeFromSuperview()
        }
        
        let numberOfPoints = 5
        for count in 1...numberOfPoints {
            let points = StackUIButton()
            if count == coloredPoint {
                points.tintColor = UIColor(red: 84 / 255, green: 166 / 255, blue: 148 / 255, alpha: 1)
            } else {
                points.tintColor = .label
            }
            dailyStackView.addArrangedSubview(points)
        }
    }
    
}
