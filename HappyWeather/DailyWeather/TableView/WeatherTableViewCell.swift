//
//  WeatherTableViewCell.swift
//  HappyWeather
//
//  Created by Heiko Rothermel on 4/3/22.
//

import UIKit

protocol WeatherTableViewCellDelegate: AnyObject {
    func didTapButton(with title: String)
//    func endedTextField(with title: String)
}

class WeatherTableViewCell: UITableViewCell {
    
    weak var delegate: WeatherTableViewCellDelegate?
    
    private let highTempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 17, weight: .bold)
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
    
    private let textFieldNote: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Notizen"
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        return textField
    }()
    
    private let testButton: UIButton = {
        let testButton = UIButton()
        testButton.backgroundColor = UIColor(red: 84 / 255, green: 166 / 255, blue: 148 / 255, alpha: 1)
        testButton.isUserInteractionEnabled = true
        return testButton
    }()


    
    static let identifier = "WeatherTableViewCell"
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(highTempLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(iconImageView)
        contentView.addSubview(textFieldNote)
        contentView.addSubview(testButton)
        testButton.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)
//        textFieldNote.addTarget(self, action: #selector(endedTextField(sender:)), for: .editingDidEnd)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var title: String = ""
    
    func configure(with model: Hourly) {
        
        self.title = "\(getDayForDate(Date(timeIntervalSince1970: Double(model.dt))))"
        testButton.setTitle("hello", for: .normal)
        
        
        
        self.highTempLabel.text = "\(Int(model.temp))°"
        self.timeLabel.text = "\(getDayForDate(Date(timeIntervalSince1970: Double(model.dt)))) Uhr"
        self.iconImageView.contentMode = .scaleAspectFit
        
        
        let icon = model.weather.first?.main.lowercased()  ?? ""
        if icon.contains("cloud") {
            self.iconImageView.image = UIImage(systemName: "cloud.fill")
        } else if icon.contains("rain") {
            self.iconImageView.image = UIImage(systemName: "cloud.rain.fill")
        } else if icon.contains("snow") {
            self.iconImageView.image = UIImage(systemName: "snow")
        } else {
            self.iconImageView.image = UIImage(systemName: "sun.max.fill")
        }
    }
    
    
    
    
    @objc func buttonClicked(sender: UIButton){
        delegate?.didTapButton(with: title)
    }

//    @objc func endedTextField(sender: UITextField){
//        delegate?.endedTextField(with: title)
//    }
    
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconImageView.frame = CGRect(x: contentView.frame.size.width - 50 - 5, y: 0, width: 50, height: 65)
        highTempLabel.frame = CGRect(x: contentView.frame.size.width - (iconImageView.frame.size.width * 2) - 10, y: 5, width: iconImageView.frame.size.width, height: 65)
        timeLabel.frame = CGRect(x: 10, y: 0, width: 100, height: 30)
        textFieldNote.frame = CGRect(x: 10, y: 35, width: contentView.frame.size.width - 25 - iconImageView.frame.size.width - highTempLabel.frame.size.width, height: timeLabel.frame.size.height)
        testButton.frame = CGRect(x: 110, y: 0, width: 80, height: 30)
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
