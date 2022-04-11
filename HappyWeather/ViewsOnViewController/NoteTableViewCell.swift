//
//  NoteTableViewCell.swift
//  HappyWeather
//
//  Created by Heiko Rothermel on 4/9/22.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    static let identifier = "NoteTableViewCell"
    
    private let greyBackgroundView: UIView = {
        let view = UIView()
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
        label.textColor = UIColor(red: 84 / 255, green: 166 / 255, blue: 148 / 255, alpha: 1)
        return label
    }()
    
    private let noteLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = UIColor(red: 84 / 255, green: 166 / 255, blue: 148 / 255, alpha: 1)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(greyBackgroundView)
        greyBackgroundView.addSubview(timeLabel)
        greyBackgroundView.addSubview(iconImageView)
        greyBackgroundView.addSubview(highTempLabel)
        greyBackgroundView.addSubview(noteLabel)
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func configure(timeOfDay: Int) {
        
        var today = Int()
        today = Int(Date().timeIntervalSince1970) - (Int(getDayForDate(Date()))! + 1)  * 3600
        if arrayTimes[timeOfDay] - today < (3600 * 24) {
            timeLabel.text = "Heute, \(getDayForDate(Date(timeIntervalSince1970: TimeInterval(arrayTimes[timeOfDay])))) Uhr:"
        } else if arrayTimes[timeOfDay] - today < (3600 * 48) {
            self.timeLabel.text = "Morgen, \(getDayForDate(Date(timeIntervalSince1970: TimeInterval(arrayTimes[timeOfDay])))) Uhr:"
        } else if arrayTimes[timeOfDay] - today < (3600 * 72) {
            self.timeLabel.text = "Übermorgen, \(getDayForDate(Date(timeIntervalSince1970: TimeInterval(arrayTimes[timeOfDay])))) Uhr:"
        } else {
            self.timeLabel.text = "Überübermorgen, \(getDayForDate(Date(timeIntervalSince1970: TimeInterval(arrayTimes[timeOfDay])))) Uhr:"
        }
        
        noteLabel.text = "\(dictEventsNoted[arrayTimes[timeOfDay]] ?? "Nichts")"
        
        highTempLabel.text = "\(Int(dictWeatherForEvents[arrayTimes[timeOfDay]]?.temp ?? 0))°"
        iconImageView.image = UIImage(systemName: "cloud.fill")
        
        let icon = dictWeatherForEvents[arrayTimes[timeOfDay]]!.main.lowercased()
        print(highTempLabel.text!)
        print(dictWeatherForEvents[arrayTimes[timeOfDay]]!)
        
        if icon.contains("cloud") {
            self.iconImageView.image = UIImage(systemName: "cloud.fill")
        } else if icon.contains("rain") {
            self.iconImageView.image = UIImage(systemName: "cloud.rain.fill")
        } else if icon.contains("snow") {
            self.iconImageView.image = UIImage(systemName: "cloud.snow.fill")
        } else {
            self.iconImageView.image = UIImage(systemName: "sun.max.fill")
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        greyBackgroundView.frame = CGRect(x: 15 * CGFloat(factorWidth), y: 10 * CGFloat(factorHeight), width: contentView.frame.size.width - 30 * CGFloat(factorWidth), height: contentView.frame.size.height - 15 * CGFloat(factorHeight))
        iconImageView.frame = CGRect(x: greyBackgroundView.frame.size.width - 75 * CGFloat(factorWidth), y: 17.5 * CGFloat(factorHeight), width: 60 * CGFloat(factorWidth), height: 60 * CGFloat(factorHeight))
        highTempLabel.frame = CGRect(x: greyBackgroundView.frame.size.width - 75 * CGFloat(factorWidth), y: 15 * CGFloat(factorHeight), width: 60 * CGFloat(factorWidth), height: 60 * CGFloat(factorHeight))
        timeLabel.frame = CGRect(x: 15 * CGFloat(factorWidth), y: 12.5 * CGFloat(factorHeight), width: 200 * CGFloat(factorWidth), height: 25 * CGFloat(factorHeight))
        noteLabel.frame = CGRect(x: 15 * CGFloat(factorWidth), y: 45 * CGFloat(factorHeight), width: greyBackgroundView.frame.size.width - 45 * CGFloat(factorWidth) - iconImageView.frame.size.width, height: timeLabel.frame.size.height)
        
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
