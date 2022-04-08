//
//  XIBDailyTableViewCell.swift
//  HappyWeather
//
//  Created by Heiko Rothermel on 4/8/22.
//

import UIKit

class XIBDailyTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    static let identifier = "XIBDailyTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "XIBDailyTableViewCell", bundle: nil)
    }

    @IBOutlet var collectionView: UICollectionView!
    
    var models = [Hourly]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.register(XIBDailyCollectionViewCell.nib(), forCellWithReuseIdentifier: XIBDailyCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    
    func configure(with models: [Hourly]) {
        self.models = models
        self.collectionView.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 250, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: XIBDailyCollectionViewCell.identifier, for: indexPath) as! XIBDailyCollectionViewCell
        cell.configure(with: models[indexPath.row])
        return cell
    }
    
}
