//
//  DailyCollectionViewCell.swift
//  HappyWeather
//
//  Created by Heiko Rothermel on 4/8/22.
//

import UIKit

class DailyCollectionViewCell: UICollectionViewCell {
    
    
    static let identifier = "DailyCollectionViewCell"
    
    
    
    //    WeeklyView
        private let overviewWeeklyWeather: UIView = {
            let view = UIView()
            view.layer.cornerRadius = 25
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOpacity = 0.125
            view.layer.shadowOffset = .zero
            view.layer.shadowRadius = 16
            view.backgroundColor = .blue
            return view
        }()
        
        private let photoWeatherView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "fotoSnow")
            imageView.layer.cornerRadius = 25
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill
            return imageView
        }()
        
        private let weeklyTempLabel: UILabel = {
            let label = UILabel()
            label.layer.borderColor = CGColor(red: 84 / 255, green: 166 / 255, blue: 148 / 255, alpha: 1)
            label.backgroundColor = .white
            label.alpha = 0.5
            label.text = "15°"
            label.font = .systemFont(ofSize: 45, weight: .medium)
            label.textAlignment = .center
            label.layer.masksToBounds = true
            label.layer.borderWidth = 2
            label.layer.borderColor = CGColor(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 1)
            label.layer.cornerRadius = 10
            return label
        }()
    
    
    
    
    static func nib() -> UINib {
           return UINib(nibName: "DailyCollectionViewCell", bundle: nil)
       }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        contentView.addSubview(overviewWeeklyWeather)
        overviewWeeklyWeather.addSubview(photoWeatherView)
        overviewWeeklyWeather.addSubview(weeklyTempLabel)
        
    }
    
    
   
    
    
    
    

    
    func configure(with model: Daily) {
        
        weeklyTempLabel.text = "\(model.temp.max)"
        
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        overviewWeeklyWeather.frame = CGRect(x: 0, y:  0, width: contentView.frame.width, height: contentView.frame.size.height)
        photoWeatherView.frame = CGRect(x: 0, y:  0, width: overviewWeeklyWeather.frame.width , height: overviewWeeklyWeather.frame.size.height - 100)
        weeklyTempLabel.frame = CGRect(x: overviewWeeklyWeather.frame.width - 125, y: 25, width: 100 , height: 60)
        
    }
    
    
    
    
}
