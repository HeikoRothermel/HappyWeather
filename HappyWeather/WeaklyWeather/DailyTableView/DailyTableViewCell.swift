//
//  DailyTableViewCell.swift
//  HappyWeather
//
//  Created by Heiko Rothermel on 4/8/22.
//

import UIKit

class DailyTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var models = [Hourly]()
    
    
    
    var dailyCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.layer.cornerRadius = 25
        collectionView.layer.borderWidth = 3
        collectionView.layer.borderColor = CGColor(red: 84 / 255, green: 166 / 255, blue: 148 / 255, alpha: 1)
        collectionView.backgroundColor = .red
        return collectionView
    }()
    
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        dailyCollectionView.register(DailyCollectionViewCell.nib(), forCellWithReuseIdentifier: DailyCollectionViewCell.identifier)
        dailyCollectionView.delegate = self
        dailyCollectionView.dataSource = self

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)

        contentView.addSubview(dailyCollectionView)
            // Configure the view for the selected state
        }
    
    
    static let identifier = "DailyTableViewCell"
    
    static func nib() -> UINib {
            return UINib(nibName: "DailyTableViewCell", bundle: nil)
        }
    
    
    
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)


//        dailyCollectionView.register(DailyCollectionViewCell.self, forCellWithReuseIdentifier: DailyCollectionViewCell.identifier)
//        dailyCollectionView.delegate = self
//        dailyCollectionView.dataSource = self


    }
    
    required init?(coder: NSCoder) {
       
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dailyCollectionView.frame = CGRect(x: 5, y:  5, width: contentView.frame.width - 10, height: contentView.frame.size.height - 10)
    }
    
    
    
    
    
    func configure(with models: [Hourly]) {
        
        self.models = models
        dailyCollectionView.reloadData()
    }
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(models.count)
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DailyCollectionViewCell.identifier, for: indexPath) as! DailyCollectionViewCell
        cell.configure(with: models[indexPath.row])
        return cell
        
    }

}
