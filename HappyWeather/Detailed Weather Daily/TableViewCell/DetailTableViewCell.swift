//
//  DetailTableViewCell.swift
//  HappyWeather
//
//  Created by Heiko Rothermel on 4/12/22.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    
    static let identifier = "DetailTableViewCell"
    
    
    //header
    private let detailHeader: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.backgroundColor =  .clear
        return label
    }()
    
    //detail
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = UIColor(red: 221 / 255, green: 221 / 255, blue: 225 / 255, alpha: 1)
        label.backgroundColor =  .clear
        return label
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //add background color
        contentView.backgroundColor = UIColor(red: 84 / 255, green: 166 / 255, blue: 148 / 255, alpha: 1)
        
        // add Label to cell
        contentView.addSubview(detailHeader)
        contentView.addSubview(detailLabel)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(with arrayDetails: String, and arrayDetail2: Int) {
        
        // get header data
        detailHeader.text = arrayDetails
        
        
        //get data for detail label
        if arrayDetails == "Feuchtigkeit:" {
            switch arrayDetail2 {
            case 1..<40:
                detailLabel.text = "Niedrig- \(arrayDetail2)%"
            case 41..<60:
                detailLabel.text = "Normal - \(arrayDetail2)%"
            case 61..<80:
                detailLabel.text = "Hoch - \(arrayDetail2)%"
            default:
                detailLabel.text = "Sehr hoch - \(arrayDetail2)%"
            }
        } else if arrayDetails == "Windgeschwindigkeit:" {
            switch arrayDetail2 {
            case 1..<10:
                detailLabel.text = "Leichte Brise - \(arrayDetail2)km/h"
            case 11..<20:
                detailLabel.text = "Schwache Brise - \(arrayDetail2)km/h"
            case 21..<30:
                detailLabel.text = "Mäßige Brise - \(arrayDetail2)km/h"
            case 31..<40:
                detailLabel.text = "Frische Brise - \(arrayDetail2)km/h"
            case 41..<50:
                detailLabel.text = "Starker Wind - \(arrayDetail2)km/h"
            case 51..<60:
                detailLabel.text = "Steifer Wind - \(arrayDetail2)km/h"
            case 61..<70:
                detailLabel.text = "Stürmischer Wind - \(arrayDetail2)km/h"
            case 71..<80:
                detailLabel.text = "Sturm - \(arrayDetail2)km/h"
            default:
                detailLabel.text = "Schwerer Sturm - \(arrayDetail2) m/h"
            }
        } else if arrayDetails == "Luftdruck:" {
            switch arrayDetail2 {
            case 0..<899:
                detailLabel.text = "Niedrig - \(arrayDetail2)hPa"
            case 900..<1099:
                detailLabel.text = "Durchschnittlich - \(arrayDetail2)hPa"
            case 1100..<1300:
                detailLabel.text = "Erhöht - \(arrayDetail2)hPa"
            default:
                detailLabel.text = "Extrem hoch - \(arrayDetail2)hPa"
            }
        }
        
        
    }
    
    
    //constraints
    override func layoutSubviews() {
        super.layoutSubviews()
        
        detailHeader.frame = CGRect(x: 25 * CGFloat(factorWidth), y: 15 * CGFloat(factorHeight), width: contentView.frame.size.width - 50 * CGFloat(factorWidth), height: (contentView.frame.size.height / 2) - 20 * CGFloat(factorHeight))
        detailLabel.frame = CGRect(x: 25 * CGFloat(factorWidth), y: 20 * CGFloat(factorHeight) + detailHeader.frame.size.height, width: contentView.frame.size.width - 50 * CGFloat(factorWidth), height: (contentView.frame.size.height / 2) - 20 * CGFloat(factorHeight))
        
    }
    
}
