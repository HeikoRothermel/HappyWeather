//
//  stackUIButton.swift
//  HappyWeather
//
//  Created by Heiko Rothermel on 4/10/22.
//

import UIKit

class StackUIButton: UIButton {
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder acoder: NSCoder) {
        super.init(coder: acoder)
        setupButton()
    }
    
    func setupButton() {
        setTitleColor(.black, for: .normal)
        setImage(UIImage(systemName: "circle.fill"), for: .normal)
        tintColor = .label
        contentMode = .scaleAspectFit
    }
    
    
}
