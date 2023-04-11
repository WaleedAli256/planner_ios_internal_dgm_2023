//
//  CategoryViewController.swift
//  ToDoApp
//
//  Created by mac on 31/03/2023.
//

import UIKit

class CategoryViewController: UIViewController {

    @IBOutlet weak var profilPic: UIImageView!
    @IBOutlet weak var catColView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.catColView.delegate = self
        self.catColView.dataSource = self
    }
}

extension CategoryViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = catColView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as? CategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
            let frameCV = catColView.frame//размер collectionView
            let cellWidth = (frameCV.width / CGFloat(2)) - 10 // countOfCells == 2
            let cellHeight = cellWidth
            
        if cellWidth < 190 {
            return CGSize(width: cellWidth, height: cellHeight)
        }else{
            return CGSize(width: 190, height: 190)
        }

    }
}
