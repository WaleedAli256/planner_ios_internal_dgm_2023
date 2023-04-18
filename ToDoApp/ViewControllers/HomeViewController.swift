//
//  HomeViewController.swift
//  ToDoApp
//
//  Created by mac on 07/04/2023.
//

import UIKit

class HomeViewController: UIViewController, CustomSegmentedControlDelegate {
    
    @IBOutlet weak var colView: UICollectionView!
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var interfaceSegmented: CustomSegmentedControl!{
        didSet{
            interfaceSegmented.setButtonTitles(buttonTitles: ["Daily","Weekly","Monthly","Yearly"])
            interfaceSegmented.selectorViewColor = UIColor(named: "primary-color")!
            interfaceSegmented.selectorTextColor = UIColor(named: "TextColor")!
        }
    }
    
    let dailyDays = ["Yesterday","Today","Tommorow"]
    
    let weeklyDays = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"]
    
    let monthlyDays = ["01","02","03","04","05","06","07","08","09","10","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30"]
    
    var selectedTab = 0
    var checked = Set<IndexPath>()
    var centerCell: HomeCollectionViewCell?
    var tableCenterCell: HomeTableViewCell?
    var selectedTableIndex = -1
    var selectedCollectionIndex = -1

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblView.delegate = self
        self.tblView.dataSource = self

        self.colView.delegate = self
        self.colView.dataSource = self
        
        self.colView.clipsToBounds = true
        self.colView.layer.cornerRadius = 4
        self.interfaceSegmented.delegate = self
        HomeTableViewCell.onDoneBlock = { collectionIndex, tableIndex, sucess in
            
            self.selectedTableIndex = tableIndex
            self.selectedCollectionIndex = collectionIndex
            print(collectionIndex)
            print(tableIndex)
            self.tblView.reloadData()
        }
    }
    
    func change(to index: Int) {
        self.selectedTab = index
        self.colView.reloadData()
    }

}


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.selectedTab == 0 {
            return self.dailyDays.count
        } else if self.selectedTab == 1 {
            return self.weeklyDays.count
        } else {
            return self.monthlyDays.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = colView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as? HomeCollectionViewCell else {
            return UICollectionViewCell()
        }
        var value = ""
        if self.selectedTab == 0 {
            value = self.dailyDays[indexPath.row]
        } else if self.selectedTab == 1 {
            value = self.weeklyDays[indexPath.row]
        } else {
            value = self.monthlyDays[indexPath.row]
        }
        cell.dayLbl.text = value
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        DispatchQueue.main.async {
            let centerPoint = CGPoint(x: self.colView.frame.width/2 + collectionView.contentOffset.x, y: self.colView.frame.height/2 + collectionView.contentOffset.y)
            self.centerCell = self.colView.cellForItem(at: indexPath) as? HomeCollectionViewCell
            
            self.centerCell?.transformCellToLarge()
            for cell in collectionView.visibleCells {
                (cell as? HomeCollectionViewCell)?.transformCellToStandard()
            }
            self.centerCell?.transformCellToLarge()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.selectedTab == 0 {
            let width  = (collectionView.frame.width)/3
            return CGSize(width: width, height: collectionView.frame.height)
        } else if self.selectedTab == 1 {
            let width  = (collectionView.frame.width)/7
            return CGSize(width: width, height: collectionView.frame.height)
        } else {
            let width  = (collectionView.frame.width)/9
            return CGSize(width: width, height: collectionView.frame.height)
        }
    }
}

extension HomeViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as! HomeTableViewCell
        
        cell.index = indexPath
        cell.selectedTableIndex = selectedTableIndex
        cell.selectedCollectionIndex = selectedCollectionIndex
        cell.colView.reloadData()
        if selectedTableIndex == indexPath.row{
            cell.tasksStackView.isHidden = false
            cell.transformCellToLarge()
            cell.colView.reloadData()
        }else{
            cell.transformCellToStandard()
            cell.tasksStackView.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
