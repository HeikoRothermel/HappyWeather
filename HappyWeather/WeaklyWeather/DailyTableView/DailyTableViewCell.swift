//
//  DailyTableViewCell.swift
//  HappyWeather
//
//  Created by Heiko Rothermel on 4/8/22.
//

import UIKit

class DailyTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var models = [Daily]()
    
    
    
    private var dailyCollectionView: UICollectionView = {
        let collectionView = UICollectionView()
        collectionView.layer.cornerRadius = 25
        collectionView.backgroundColor = .red
        return collectionView
    }()

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        dailyCollectionView.register(DailyCollectionViewCell.nib(), forCellWithReuseIdentifier: DailyCollectionViewCell.identifier)
        dailyCollectionView.delegate = self
        dailyCollectionView.dataSource = self
        
        contentView.addSubview(dailyCollectionView)

    }
    
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)

            // Configure the view for the selected state
        }

    
    
    
    
    
    static let identifier = "DailyTableViewCell"

    
    static func nib() -> UINib {
            return UINib(nibName: "DailyTableViewCell", bundle: nil)
        }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dailyCollectionView.frame = CGRect(x: 0, y:  0, width: contentView.frame.width, height: contentView.frame.size.height)

    }
    
    
    func configure(with models: [Daily]) {
        
        self.models = models
        dailyCollectionView.reloadData()
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: contentView.frame.size.width, height: contentView.frame.size.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DailyCollectionViewCell.identifier, for: indexPath) as? DailyCollectionViewCell
        cell!.configure(with: models[indexPath.row])
        return cell!
        
    }

}
