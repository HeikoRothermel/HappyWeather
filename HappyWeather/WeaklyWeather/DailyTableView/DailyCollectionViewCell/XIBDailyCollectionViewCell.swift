//
//  XIBDailyCollectionViewCell.swift
//  HappyWeather
//
//  Created by Heiko Rothermel on 4/8/22.
//

import UIKit

class XIBDailyCollectionViewCell: UICollectionViewCell {

        static let identifier = "XIBDailyCollectionViewCell"
        
        static func nib() -> UINib {
            return UINib(nibName: "XIBDailyCollectionViewCell", bundle: nil)
        }
    
    
        
//        @IBOutlet var iconImageView: UIImageView!
        @IBOutlet var tempLabel: UILabel!
//        @IBOutlet var relevantHour: UILabel!
        
        
        override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
        }

        
        func configure(with model: Hourly) {
//            self.tempLabel.text = "24°"
//            self.iconImageView.contentMode = .scaleAspectFit
//            self.iconImageView.image = UIImage(named:"sun")
//            let icon = model.weather.first?.main.lowercased()  ?? ""
//            if icon.contains("cloud") {
//                self.iconImageView.image = UIImage(named: "fotoCloud")
//            } else if icon.contains("rain") {
//                self.iconImageView.image = UIImage(named: "fotoRain")
//            } else if icon.contains("snow") {
//                self.iconImageView.image = UIImage(named: "fotoSnow")
//            } else {
//                self.iconImageView.image = UIImage(named: "fotoSun")
//            }
        }
        
//        func getDayForDate(_ date: Date?) -> String {
//                guard let inputDate = date else {
//                    return ""
//                }
//
//                let formatter = DateFormatter()
//                formatter.dateFormat = "H"
//                return formatter.string(from: inputDate)
//
//
//            }
        
    }
