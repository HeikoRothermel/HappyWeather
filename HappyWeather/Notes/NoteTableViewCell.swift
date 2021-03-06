//
//  NoteTableViewCell.swift
//  HappyWeather
//
//  Created by Heiko Rothermel on 4/9/22.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    
    static let identifier = "NoteTableViewCell"
    
    
    // creating label/image
    private let greyBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.label.cgColor
        view.layer.shadowOpacity = 0.22
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 10
        return view
    }()
    
    //temperature
    private let highTempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    //time
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    //note coming from 24-Stunden-Vorschau
    private let noteLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor(red: 118 / 255, green: 113 / 255, blue: 115 / 255, alpha: 1)
        return label
    }()
    
    //image
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = UIColor(red: 84 / 255, green: 166 / 255, blue: 148 / 255, alpha: 1)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //adding elements to view
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
        
        //setting of time
        var today = Int()
        today = Int(Date().timeIntervalSince1970) - (Int(getDayForDate(Date()))! + 1)  * 3600
        if arrayTimes[timeOfDay] - today < (3600 * 24) {
            timeLabel.text = "Heute, \(getDayForDate(Date(timeIntervalSince1970: TimeInterval(arrayTimes[timeOfDay])))) Uhr:"
        } else if arrayTimes[timeOfDay] - today < (3600 * 48) {
            self.timeLabel.text = "Morgen, \(getDayForDate(Date(timeIntervalSince1970: TimeInterval(arrayTimes[timeOfDay])))) Uhr:"
        } else if arrayTimes[timeOfDay] - today < (3600 * 72) {
            self.timeLabel.text = "??bermorgen, \(getDayForDate(Date(timeIntervalSince1970: TimeInterval(arrayTimes[timeOfDay])))) Uhr:"
        } else {
            self.timeLabel.text = "??ber??bermorgen, \(getDayForDate(Date(timeIntervalSince1970: TimeInterval(arrayTimes[timeOfDay])))) Uhr:"
        }
        
        //setting of note
        noteLabel.text = "\(dictEventsNoted[arrayTimes[timeOfDay]] ?? "Nichts")"
        
        // setting of temperature
        highTempLabel.text = "\(Int(dictWeatherForEvents[arrayTimes[timeOfDay]]?.temp ?? 0))??"
        
        //setting of image
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
    
    //constraints
    override func layoutSubviews() {
        super.layoutSubviews()
        
        greyBackgroundView.frame = CGRect(x: 15 * CGFloat(factorWidth), y: 10 * CGFloat(factorHeight), width: contentView.frame.size.width - 30 * CGFloat(factorWidth), height: contentView.frame.size.height - 15 * CGFloat(factorHeight))
        iconImageView.frame = CGRect(x: greyBackgroundView.frame.size.width - 75 * CGFloat(factorWidth), y: 17.5 * CGFloat(factorHeight), width: 60 * CGFloat(factorWidth), height: 60 * CGFloat(factorHeight))
        highTempLabel.frame = CGRect(x: greyBackgroundView.frame.size.width - 75 * CGFloat(factorWidth), y: 17.5 * CGFloat(factorHeight), width: 60 * CGFloat(factorWidth), height: 60 * CGFloat(factorHeight))
        timeLabel.frame = CGRect(x: 15 * CGFloat(factorWidth), y: 12.5 * CGFloat(factorHeight), width: 200 * CGFloat(factorWidth), height: 25 * CGFloat(factorHeight))
        noteLabel.frame = CGRect(x: 15 * CGFloat(factorWidth), y: 45 * CGFloat(factorHeight), width: greyBackgroundView.frame.size.width - 45 * CGFloat(factorWidth) - iconImageView.frame.size.width, height: timeLabel.frame.size.height)
        
    }
    
    //getting the time of Day
    func getDayForDate(_ date: Date?) -> String {
        
        guard let inputDate = date else {
            return ""
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "H"
        return formatter.string(from: inputDate)
        
    }
    
}
