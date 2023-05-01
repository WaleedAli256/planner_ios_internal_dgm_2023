//
//  AddCategoryViewController.swift
//  ToDoApp
//
//  Created by mac on 01/05/2023.
//

import UIKit

class AddCategoryViewController: UIViewController {

    @IBOutlet weak var colview: UICollectionView!
    @IBOutlet weak var lblUploadIcon: UILabel!
    @IBOutlet weak var lblCatName: UILabel!
    @IBOutlet weak var lblCatDescrip: UILabel!
    
    var colorsArray = ["#5486E9","#F2AD10","#FFB489","#E784D1","#81DF8A","#51BBA2","#971919"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.colview.delegate = self
        self.colview.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func btnUploadAction(_ sender: UIButton) {
    }
    @IBAction func btnCreateCatAction(_ sender: UIButton) {
    }
}


extension AddCategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.colorsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = colview.dequeueReusableCell(withReuseIdentifier: "ColorCollectionViewCell", for: indexPath) as? ColorCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.colorView.backgroundColor = UIColor(hexString: self.colorsArray[indexPath.row])
        return cell
    }
    
}
