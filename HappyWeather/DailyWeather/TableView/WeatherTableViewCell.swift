//
//  WeatherTableViewCell.swift
//  HappyWeather
//
//  Created by Heiko Rothermel on 4/3/22.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var highTempLabel: UILabel!
    @IBOutlet var lowTempLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!

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
        self.highTempLabel.textAlignment = .center
        self.lowTempLabel.textAlignment = .center
        
        self.lowTempLabel.text = "\(Int(model.temp))°"
        self.highTempLabel.text = "\(Int(model.feels_like))°"
        self.timeLabel.text = "\(getDayForDate(Date(timeIntervalSince1970: Double(model.dt)))) Uhr"
        self.iconImageView.contentMode = .scaleAspectFit
        
        
        let icon = model.weather.first?.main.lowercased()  ?? ""
        if icon.contains("cloud") {
            self.iconImageView.image = UIImage(named: "cloud")
        } else if icon.contains("rain") {
            self.iconImageView.image = UIImage(named: "rain")
        } else if icon.contains("snow") {
            self.iconImageView.image = UIImage(named: "snow")
        } else {
            self.iconImageView.image = UIImage(named: "sun")
        }
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
