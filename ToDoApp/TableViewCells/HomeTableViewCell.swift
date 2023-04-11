//
//  HomeTableViewCell.swift
//  ToDoApp
//
//  Created by mac on 30/03/2023.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var colView: UICollectionView!
    @IBOutlet weak var tasksStackView: UIStackView!
    
    var didTapCategory:(() -> Void)?
    var checked = Set<IndexPath>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.colView.delegate = self
        self.colView.dataSource = self
        
        self.loadTaskView(tag: 1)
    }
    
    private func loadTaskView(tag : Int){
        let cView = TasksView()
        cView.tag = tag
        self.tasksStackView.addArrangedSubview(cView)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

extension HomeTableViewCell: UICollectionViewDelegate,UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCategoryCell", for: indexPath) as? HomeCategoryCell else {
            return UICollectionViewCell()
        }
        cell.bgView.clipsToBounds = true
        cell.bgView.layer.cornerRadius = 4
        
        cell.seletedCatView.isHidden = !self.checked.contains(indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let onTapCell = self.didTapCategory {
            onTapCell()
        }
        if self.checked.contains(indexPath) {
            self.checked.remove(indexPath)
        } else {
            self.checked.insert(indexPath)
        }
        collectionView.reloadData()
    }
}

class HomeCategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var catLbl: UILabel!
    @IBOutlet weak var seletedCatView: UIView!
        
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
