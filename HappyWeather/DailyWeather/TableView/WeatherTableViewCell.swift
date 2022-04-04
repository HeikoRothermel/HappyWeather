//
//  WeatherTableViewCell.swift
//  HappyWeather
//
//  Created by Heiko Rothermel on 4/3/22.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    
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
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    static let identifier = "WeatherTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "WeatherTableViewCell", bundle: nil)
    }
    
    
    
    
    func configure(with model: Hourly) {
        
        contentView.addSubview(highTempLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(iconImageView)
        contentView.addSubview(textFieldNote)
        
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
    

    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconImageView.frame = CGRect(x: contentView.frame.size.width - 50 - 5, y: 0, width: 50, height: 65)
        highTempLabel.frame = CGRect(x: contentView.frame.size.width - (iconImageView.frame.size.width * 2) - 10, y: 5, width: iconImageView.frame.size.width, height: 65)
        timeLabel.frame = CGRect(x: 10, y: 0, width: 150, height: 30)
        textFieldNote.frame = CGRect(x: 10, y: 35, width: contentView.frame.size.width - 25 - iconImageView.frame.size.width - highTempLabel.frame.size.width, height: timeLabel.frame.size.height)
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
