//
//  CategoryIconViewController.swift
//  ToDoApp
//
//  Created by mac on 01/05/2023.
//

import UIKit

protocol CategoryIconViewControllerDelegate: AnyObject {
    func uploadCatgoryIcon(_ iconName: Int)
}

class CategoryIconViewController: BaseViewController {
    
    @IBOutlet weak var collview: UICollectionView!
    @IBOutlet weak var btnUpdate: UIButton!
    var selectedIndex = -1
    var delegate: CategoryIconViewControllerDelegate?
    var iconName: String = ""
    var fromEditOrUpdat: String!
    var catIconNames = ["cat-icon-1","cat-icon-2","cat-icon-3","cat-icon-4","cat-icon-5","cat-icon-6","cat-icon-7","cat-icon-8","cat-icon-9","cat-icon-10","cat-icon-11","cat-icon-12","cat-icon-13","cat-icon-14","cat-icon-15","cat-icon-16","cat-icon-17","cat-icon-18","cat-icon-19","cat-icon-20","cat-icon-21","cat-icon-22","cat-icon-23","cat-icon-24","cat-icon-25","cat-icon-26","cat-icon-27","cat-icon-28","cat-icon-29","cat-icon-30","cat-icon-31","cat-icon-32","cat-icon-33","cat-icon-34","cat-icon-35","cat-icon-36"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavBar("Select Icon")
        self.collview.delegate = self
        self.collview.dataSource = self
        self.btnUpdate.setTitle(fromEditOrUpdat, for: .normal)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func updateAction(_ sender: UIButton) {
        if delegate != nil {
            if self.selectedIndex == -1 {
                self.showAlert(title: "icon Selection", message: "Please select an icon")
            } else {
                self.delegate?.uploadCatgoryIcon((self.selectedIndex + 1))
                self.navigationController?.popViewController(animated: true)
            }

        }
    }
    
}

extension CategoryIconViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.catIconNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collview.dequeueReusableCell(withReuseIdentifier: "CategoryIconsCollectionViewCell", for: indexPath) as? CategoryIconsCollectionViewCell else {
            return UICollectionViewCell()
        }
        if selectedIndex == indexPath.row {
            cell.imgIcon.image = UIImage(named: self.catIconNames[indexPath.row])?.withTintColor(UIColor.white)
            self.iconName = String(self.catIconNames[indexPath.row])
            cell.bgCellView.backgroundColor = UIColor(named: "primary-color")
        }else{
            cell.imgIcon.image = UIImage(named: self.catIconNames[indexPath.row])?.withTintColor(UIColor(hexString: "#757575"))
//            self.iconName = String(self.catIconNames[indexPath.row])
            cell.bgCellView.backgroundColor = .clear
        }
//        cell.imgIcon.image = UIImage(named: self.catIconNames[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if selectedIndex == indexPath.row{
            selectedIndex = -1
        }else{
            self.selectedIndex = indexPath.row
        }
        self.collview.reloadData()
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        return CGSize(width: 30, height: 30)
//    }

    
}
