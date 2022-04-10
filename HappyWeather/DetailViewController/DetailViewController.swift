//
//  DetailViewController.swift
//  HappyWeather
//
//  Created by Heiko Rothermel on 4/10/22.
//

import UIKit

class DetailViewController: UIViewController {

    private let labelTemp: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.backgroundColor = .white
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .left
        label.clipsToBounds = true
        label.backgroundColor = .clear
        return label
    }()
    
    
    var test = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        view.addSubview(labelTemp)
        
        labelTemp.text = test
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        labelTemp.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        
    }
    
    

}
