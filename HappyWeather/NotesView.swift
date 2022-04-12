//
//  NotesView.swift
//  HappyWeather
//
//  Created by Heiko Rothermel on 4/12/22.
//

import UIKit

class NotesView: UIView, UITableViewDelegate {
    

    static let identifier = "NotesView"
    
    private let dailyTableView: UITableView = {
        let tableView = UITableView()
        tableView.clipsToBounds = true
        tableView.showsVerticalScrollIndicator = false
        tableView.layer.cornerRadius = 25
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private let dailyInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "Nutze die 24-Stunden-Vorschau, um Ereignisse hinzuzufügen :)"
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textAlignment = .center
        label.clipsToBounds = true
        label.layer.cornerRadius = 25
        return label
    }()
    
    
    private let dailyHeaderLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 84 / 255, green: 166 / 255, blue: 148 / 255, alpha: 1)
        label.text = "Übersicht deiner Events:"
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        
        
       
        
        dailyTableView.register(NoteTableViewCell.self, forCellReuseIdentifier: NoteTableViewCell.identifier)
        dailyTableView.delegate = self
        dailyTableView.dataSource = self
        dailyTableView.reloadData()
        
        checkIfNotesExit()
        
        print("1")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        
        print("2")
        fatalError("init(coder:) has not been implemented")
        
    }
    
    private func setup() {
        
        addSubview(dailyInfoLabel)
        addSubview(dailyHeaderLabel)
        addSubview(dailyTableView)
        
        print("3")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        print("4")
        
        
        dailyInfoLabel.frame = CGRect(x: 5 * CGFloat(factorWidth), y:  60 * CGFloat(factorHeight), width: 344  * CGFloat(factorWidth) - 10 * CGFloat(factorWidth), height: 278 * CGFloat(factorHeight) - 70 * CGFloat(factorHeight))
        dailyTableView.frame = dailyInfoLabel.frame
        dailyHeaderLabel.frame = CGRect(x: 15 * CGFloat(factorWidth), y:  20 * CGFloat(factorHeight), width: 344  * CGFloat(factorWidth) - 30 * CGFloat(factorWidth), height: 35 * CGFloat(factorHeight))
    }
    
    func checkIfNotesExit() {
        print("10")
        
        
        
        if arrayTimes.count > 0 {
            dailyInfoLabel.isHidden = true
        } else {
            dailyInfoLabel.isHidden = false
        }
        
//        dailyTableView.register(NoteTableViewCell.self, forCellReuseIdentifier: NoteTableViewCell.identifier)
//        dailyTableView.delegate = self
//        dailyTableView.dataSource = self
//        dailyTableView.reloadData()
        
        DispatchQueue.main.async {
            self.dailyTableView.reloadData()
        }
        
    }
}

extension NotesView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        var cells = Int()
        cells = arrayTimes.count
        print("5, \(cells)")
        return cells
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("6")
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.identifier, for: indexPath) as? NoteTableViewCell
        cell!.configure(timeOfDay: indexPath.row)
        cell!.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell!
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        print("7")
        var cellheight = Float()
        cellheight = Float(100 * CGFloat(factorHeight))
        return CGFloat(cellheight)
        
    }
    
}
