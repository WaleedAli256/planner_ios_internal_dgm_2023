//
//  HomeCollectionViewCell.swift
//  ToDoApp
//
//  Created by mac on 30/03/2023.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dayLbl: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func transformCellToLarge() {
        UIView.animate(withDuration: 0.1) {
            self.dayLbl.textColor = .white
            self.dayLbl.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        }
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    func transformCellToStandard() {
        UIView.animate(withDuration: 0.1) {
            self.dayLbl.textColor = UIColor(named: "low-color")!
            self.dayLbl.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        }
    }
}
