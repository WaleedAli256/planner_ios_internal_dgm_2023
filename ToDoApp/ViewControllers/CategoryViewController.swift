//
//  CategoryViewController.swift
//  ToDoApp
//
//  Created by mac on 31/03/2023.
//

import UIKit
import Firebase
import FirebaseFirestore

class CategoryViewController: UIViewController {
    
    @IBOutlet weak var profilPic: UIImageView!
    @IBOutlet weak var catColView: UICollectionView!
    
    var categories: [TaskCategory] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.catColView.delegate = self
        self.catColView.dataSource = self
        self.getCategories(userId: Utilities().getCurrentUser().id ?? "")
    }
    
    func getCategories (userId:String) {
        Utilities.show_ProgressHud(view: self.view)
        self.categories.removeAll()
        let db = Firestore.firestore()
        db.collection("category").whereField("userId", isEqualTo: userId)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    Utilities.hide_ProgressHud(view: self.view)
                } else {
                    Utilities.hide_ProgressHud(view: self.view)
                    for document in querySnapshot!.documents {
                        let dicCat = document.data()
                        let objCat = TaskCategory.init(fromDictionary: dicCat)
                        self.categories.append(objCat)
                    }
                    self.catColView.reloadData()
                }
            }
    }
    
}

extension CategoryViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = catColView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as? CategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        let cat = self.categories[indexPath.row]
        cell.catBGView.backgroundColor = UIColor(hexString: cat.colorCode ?? "")
        cell.catDesc.text = cat.description ?? ""
        cell.catName.text = cat.name ?? ""
        cell.catImage.image = UIImage(named: "icon-\(cat.image ?? 1)")
        
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
