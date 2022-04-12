//
//  WeatherTableViewCell.swift
//  HappyWeather
//
//  Created by Heiko Rothermel on 4/3/22.
//

import UIKit

protocol WeatherTableViewCellDelegate: AnyObject {
    func didUseTF(with text: String)
}

class WeatherTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    weak var delegate: WeatherTableViewCellDelegate?
    
    
    private let greyBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.label.cgColor
        view.layer.shadowOpacity = 0.15
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 10
        return view
    }()
    
    private let highTempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = UIColor(red: 84 / 255, green: 166 / 255, blue: 148 / 255, alpha: 1)
        return imageView
    }()
    
    let textFieldNote: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Notizen"
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        return textField
    }()
    
    
    static let identifier = "WeatherTableViewCell"
    
    
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        textFieldNote.delegate = self
        
        let item = textFieldNote.inputAssistantItem
        item.leadingBarButtonGroups = []
        item.trailingBarButtonGroups = []
        
        contentView.addSubview(greyBackgroundView)
        greyBackgroundView.addSubview(timeLabel)
        greyBackgroundView.addSubview(iconImageView)
        greyBackgroundView.addSubview(highTempLabel)
        greyBackgroundView.addSubview(textFieldNote)
        
        textFieldNote.addTarget(self, action: #selector(fieldClicked(sender:)), for: .editingDidEnd)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var timeOfDay = Int()
    
    func configure(with model: Hourly) {
        
        self.timeOfDay = model.dt
        
        self.highTempLabel.text = "\(Int(model.temp))°"
        
        var today = Int()
        today = Int(Date().timeIntervalSince1970) - (Int(getDayForDate(Date()))! + 1)  * 3600
        if timeOfDay - today < (3600 * 24) {
            self.timeLabel.text = "Heute, \(getDayForDate(Date(timeIntervalSince1970: TimeInterval(timeOfDay)))) Uhr:"
        } else if timeOfDay - today < (3600 * 48) {
            self.timeLabel.text = "Morgen, \(getDayForDate(Date(timeIntervalSince1970: TimeInterval(timeOfDay)))) Uhr:"
        } else if timeOfDay - today < (3600 * 72) {
            self.timeLabel.text = "Übermorgen, \(getDayForDate(Date(timeIntervalSince1970: TimeInterval(timeOfDay)))) Uhr:"
        } else if timeOfDay - today < (3600 * 48) {
            self.timeLabel.text = "Überübermorgen, \(getDayForDate(Date(timeIntervalSince1970: TimeInterval(timeOfDay)))) Uhr:"
        }
        
        
        self.iconImageView.contentMode = .scaleAspectFit
        
        
        let icon = model.weather.first?.main.lowercased()  ?? ""
        if icon.contains("cloud") {
            self.iconImageView.image = UIImage(systemName: "cloud.fill")
        } else if icon.contains("rain") {
            self.iconImageView.image = UIImage(systemName: "cloud.rain.fill")
        } else if icon.contains("snow") {
            self.iconImageView.image = UIImage(systemName: "cloud.snow.fill")
        } else {
            self.iconImageView.image = UIImage(systemName: "sun.max.fill")
        }
        
        if arrayTimes.contains(timeOfDay) {
            textFieldNote.text = "\(dictEventsNoted[timeOfDay] ?? "")"
        } else {
            textFieldNote.text = ""
        }
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textFieldNote.text = nil
    }
    
    
    @objc func fieldClicked(sender: UITextField){
        
        delegate?.didUseTF(with: String(timeOfDay))
        
        if let index = arrayTimes.firstIndex(of: timeOfDay) {
            arrayTimes.remove(at: index)
        }
        
        if self.textFieldNote.text != "" {
            
            dictEventsNoted[timeOfDay] = self.textFieldNote.text ?? ""
            arrayTimes += [timeOfDay]
            arrayTimes.sort()
            
            dictForSavings["\(timeOfDay)"] = "\(dictEventsNoted[timeOfDay] ?? "")-\(dictWeatherForEvents[timeOfDay]?.main ?? "")-\(dictWeatherForEvents[timeOfDay]?.temp ?? 0.0)"
            
            let defaults = UserDefaults.standard
            defaults.set(arrayTimes, forKey: "saveArray")
            
            UserDefaults.standard.set(dictForSavings, forKey: "saveDict")
            _ = UserDefaults.standard.value(forKey: "saveDict")
            
        } else {
            if let index = arrayTimes.firstIndex(of: timeOfDay) {
                arrayTimes.remove(at: index)
            }
            dictForSavings.removeValue(forKey: "\(timeOfDay)")
            
            let defaults = UserDefaults.standard
            defaults.set(arrayTimes, forKey: "saveArray")
            
            UserDefaults.standard.set(dictForSavings, forKey: "saveDict")
            _ = UserDefaults.standard.value(forKey: "saveDict")
        }
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        greyBackgroundView.frame = CGRect(x: 20 * CGFloat(factorWidth), y: 10 * CGFloat(factorHeight), width: contentView.frame.size.width - 40 * CGFloat(factorWidth), height: contentView.frame.size.height - 20 * CGFloat(factorHeight))
        iconImageView.frame = CGRect(x: greyBackgroundView.frame.size.width - 75 * CGFloat(factorWidth), y: 10 * CGFloat(factorHeight), width: 60 * CGFloat(factorWidth), height: 60 * CGFloat(factorHeight))
        highTempLabel.frame = CGRect(x: greyBackgroundView.frame.size.width - 75 * CGFloat(factorWidth), y: 12.5 * CGFloat(factorHeight), width: 60 * CGFloat(factorWidth), height: 60 * CGFloat(factorHeight))
        timeLabel.frame = CGRect(x: 20 * CGFloat(factorWidth), y: 12.5 * CGFloat(factorHeight), width: 200 * CGFloat(factorWidth), height: 25 * CGFloat(factorHeight))
        textFieldNote.frame = CGRect(x: 20 * CGFloat(factorWidth), y: 45 * CGFloat(factorHeight), width: greyBackgroundView.frame.size.width - 60 * CGFloat(factorWidth) - iconImageView.frame.size.width, height: timeLabel.frame.size.height)
    }
    
    func getDayForDate(_ date: Date?) -> String {
        
        guard let inputDate = date else {
            return ""
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "H"
        return formatter.string(from: inputDate)
    }
    
}


