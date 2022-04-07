//
//  NoteTableViewCell.swift
//  HappyWeather
//
//  Created by Heiko Rothermel on 4/5/22.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    static let identifier = "NoteTableViewCell"

    
    
    private let greyBackgroundView: UIView = {
        let view = UIView()
//        view.backgroundColor = UIColor(red: 242 / 255, green: 242 / 255, blue: 247 / 255, alpha: 1)
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
        label.font = .systemFont(ofSize: 20, weight: .bold)
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
        
        greyBackgroundView.frame = CGRect(x: 20, y: 10, width: contentView.frame.size.width - 40, height: contentView.frame.size.height - 15)
        iconImageView.frame = CGRect(x: greyBackgroundView.frame.size.width - 60 - 15, y: 17.5, width: 60, height: 60)
        highTempLabel.frame = CGRect(x: greyBackgroundView.frame.size.width - 60 - 15, y: 15, width: 60, height: 60)
        timeLabel.frame = CGRect(x: 15, y: 12.5, width: 200, height: 25)
        noteLabel.frame = CGRect(x: 15, y: 45, width: greyBackgroundView.frame.size.width - 45 - iconImageView.frame.size.width, height: timeLabel.frame.size.height)
        
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
