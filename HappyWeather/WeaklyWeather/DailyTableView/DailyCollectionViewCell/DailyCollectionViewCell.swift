//
//  DailyCollectionViewCell.swift
//  HappyWeather
//
//  Created by Heiko Rothermel on 4/8/22.
//

import UIKit

class DailyCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "DailyCollectionViewCell"
    
    static func nib() -> UINib {
            return UINib(nibName: "DailyCollectionViewCell", bundle: nil)
        }
    
    //    WeeklyView
//        private let overviewWeeklyWeather: UIView = {
//            let view = UIView()
//            view.layer.cornerRadius = 25
//            view.layer.shadowColor = UIColor.black.cgColor
//            view.layer.shadowOpacity = 0.125
//            view.layer.shadowOffset = .zero
//            view.layer.shadowRadius = 16
//            view.backgroundColor = .green
//            view.layer.borderWidth = 3
//            view.layer.borderColor = CGColor(red: 84 / 255, green: 166 / 255, blue: 148 / 255, alpha: 1)
//            return view
//        }()
        
        private let photoWeatherView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "fotoSnow")
            imageView.layer.cornerRadius = 25
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill
            imageView.layer.borderWidth = 3
            imageView.layer.borderColor = CGColor(red: 84 / 255, green: 166 / 255, blue: 148 / 255, alpha: 1)
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
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

//        contentView.addSubview(overviewWeeklyWeather)
        contentView.addSubview(photoWeatherView)
        contentView.addSubview(photoWeatherView)
    }
    
    
    override init (frame: CGRect) {
        super.init(frame: frame)
//        contentView.addSubview(overviewWeeklyWeather)
        contentView.addSubview(weeklyTempLabel)
        contentView.addSubview(photoWeatherView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
   
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
//        overviewWeeklyWeather.frame = CGRect(x: 5, y:  5, width: contentView.frame.width - 10, height: contentView.frame.size.height - 10)
        photoWeatherView.frame = CGRect(x: 0, y:  0, width: contentView.frame.width , height: contentView.frame.size.height)
//        weeklyTempLabel.frame = CGRect(x: overviewWeeklyWeather.frame.width - 125, y: 25, width: 100 , height: 60)
        weeklyTempLabel.frame = CGRect(x: 0, y: 0, width: 50 , height: 50)
    }
    
    
    

    
    func configure(with model: Hourly) {
        
        weeklyTempLabel.text = "15"
//        print(model.temp)
        self.photoWeatherView.image = UIImage(systemName: "sun.max.fill")
    }
    
    
    
    
    
    
    
}
