//
//  WeatherTableViewCell.swift
//  HappyWeather
//
//  Created by Heiko Rothermel on 4/3/22.
//

import UIKit

protocol WeatherTableViewCellDelegate: AnyObject {
//    func didTapButton(with title: String)
    func didUseTF(with text: String)
}



class WeatherTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    weak var delegate: WeatherTableViewCellDelegate?
    
    
    private let greyBackgroundView: UIView = {
        let view = UIView()
//        view.backgroundColor = UIColor(red: 239 / 255, green: 239 / 255, blue: 244 / 255, alpha: 1)
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
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
        label.textColor = .black
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
    
//    private let testButton: UIButton = {
//        let testButton = UIButton()
//        testButton.backgroundColor = UIColor(red: 84 / 255, green: 166 / 255, blue: 148 / 255, alpha: 1)
//        testButton.isUserInteractionEnabled = true
//        return testButton
//    }()
    
    
    
    
    static let identifier = "WeatherTableViewCell"
    

    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        textFieldNote.delegate = self
        
        // To let Constraints-Issue of keyboard disappear
        let item = textFieldNote.inputAssistantItem
        item.leadingBarButtonGroups = []
        item.trailingBarButtonGroups = []
        
        contentView.addSubview(greyBackgroundView)
        greyBackgroundView.addSubview(timeLabel)
        greyBackgroundView.addSubview(iconImageView)
        greyBackgroundView.addSubview(highTempLabel)
        greyBackgroundView.addSubview(textFieldNote)
//        greyBackgroundView.addSubview(testButton)
        
//        testButton.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)
        textFieldNote.addTarget(self, action: #selector(fieldClicked(sender:)), for: .editingDidEnd)
        
        print("klappt2")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var timeOfDay = Int()
    
    func configure(with model: Hourly) {
        
        self.timeOfDay = model.dt
//        testButton.setTitle("hello", for: .normal)
        
        
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
        }
    }

    
//    @objc func buttonClicked(sender: UIButton){
//        delegate?.didTapButton(with: title)
//        print(title)
//    }
    

    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        greyBackgroundView.frame = CGRect(x: 20, y: 10, width: contentView.frame.size.width - 40, height: contentView.frame.size.height - 20)
        iconImageView.frame = CGRect(x: greyBackgroundView.frame.size.width - 50 - 25, y: 10, width: 60, height: 60)
        highTempLabel.frame = CGRect(x: greyBackgroundView.frame.size.width - 50 - 25, y: 12.5, width: 60, height: 60)
        timeLabel.frame = CGRect(x: 20, y: 12.5, width: 200, height: 25)
        textFieldNote.frame = CGRect(x: 20, y: 45, width: greyBackgroundView.frame.size.width - 60 - iconImageView.frame.size.width, height: timeLabel.frame.size.height)
//        testButton.frame = CGRect(x: 110, y: 0, width: 80, height: 30)
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


