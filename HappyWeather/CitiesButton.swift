//
//  CitiesButton.swift
//  HappyWeather
//
//  Created by Heiko Rothermel on 4/11/22.
//

import UIKit

class CitiesButton: UIButton {

    
    override init(frame:CGRect) {
        super.init(frame: frame)
        setupButton()
        self.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)
    }
    
    required init?(coder acoder: NSCoder) {
        super.init(coder: acoder)
        setupButton()
        self.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)
    }
    
    func setupButton() {
        setTitleColor(.black, for: .normal)
        tintColor = UIColor(red: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 1)
        titleLabel!.font = UIFont(name: "", size: 15)
    }
    
    @objc func buttonClicked(sender: UIButton){
        print("\(sender.titleLabel!.text ?? "")")
        }
    
    
}
