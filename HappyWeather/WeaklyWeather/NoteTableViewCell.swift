//
//  NoteTableViewCell.swift
//  HappyWeather
//
//  Created by Heiko Rothermel on 4/5/22.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    static let identifier = "NoteTableViewCell"

    
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
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = UIColor(red: 84 / 255, green: 166 / 255, blue: 148 / 255, alpha: 1)
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let greyBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 239 / 255, green: 239 / 255, blue: 244 / 255, alpha: 1)
        view.layer.cornerRadius = 20
        return view
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

    
    func configure(uhrzeit: Int) {
        print(uhrzeit)
        print([arrayTimes])
        timeLabel.text = "\(getDayForDate(Date(timeIntervalSince1970: TimeInterval(arrayTimes[uhrzeit])))) Uhr"
        noteLabel.text = "\(dict[arrayTimes[uhrzeit]] ?? "Nichts")"
        
        highTempLabel.text = "25"
        iconImageView.image = UIImage(systemName: "cloud.fill")
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        greyBackgroundView.frame = CGRect(x: 20, y: 7.5, width: contentView.frame.size.width - 40, height: contentView.frame.size.height - 15)
        iconImageView.frame = CGRect(x: greyBackgroundView.frame.size.width - 60 - 15, y: 12.5, width: 60, height: 60)
        highTempLabel.frame = CGRect(x: greyBackgroundView.frame.size.width - 60 - 15, y: 15, width: 60, height: 60)
        timeLabel.frame = CGRect(x: 15, y: 15, width: 100, height: 25)
        noteLabel.frame = CGRect(x: 15, y: 47.5, width: greyBackgroundView.frame.size.width - 45 - iconImageView.frame.size.width, height: timeLabel.frame.size.height)
        
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
