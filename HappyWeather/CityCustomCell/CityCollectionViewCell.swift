//
//  CityCollectionViewCell.swift
//  HappyWeather
//
//  Created by Heiko Rothermel on 4/9/22.
//

import UIKit

class CityCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CityCollectionViewCell"
//    static func nib() -> UINib {
//               return UINib(nibName: "CityCollectionViewCell", bundle: nil)
//           }
    
    private let buttonCity: UIButton = {
        let button = UIButton()
                button.backgroundColor = .white
        button.alpha = 0.5
        button.clipsToBounds = true
        button.layer.cornerRadius = 15
        return button
    }()
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        contentView.addSubview(buttonCity)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        buttonCity.frame = CGRect(x: 0 * CGFloat(factorWidth), y:  0 * CGFloat(factorHeight), width: contentView.frame.size.width, height: contentView.frame.size.height)
    }
    
    
    
    func configure(cities: String) {
        
        buttonCity.setTitle("\(cities)", for: .normal)
        
    }
}
