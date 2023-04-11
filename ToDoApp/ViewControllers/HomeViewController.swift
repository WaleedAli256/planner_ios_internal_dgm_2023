//
//  HomeViewController.swift
//  ToDoApp
//
//  Created by mac on 07/04/2023.
//

import UIKit

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var dailyBtn: UIButton!
    @IBOutlet weak var weeklyBtn: UIButton!
    @IBOutlet weak var monthlyBtn: UIButton!
    @IBOutlet weak var yearlyBtn: UIButton!
    
    @IBOutlet weak var colView: UICollectionView!
    @IBOutlet weak var tblView: UITableView!
    
    let dailyDays = ["Yesterday","Today","Tommorow"]
    
    let weeklyDays = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"]
    
    let monthlyDays = ["01","02","03","04","05","06","07","08","09","10","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30"]
    
    var selectedTab = 0
    var checked = Set<IndexPath>()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblView.delegate = self
        self.tblView.dataSource = self

        self.colView.delegate = self
        self.colView.dataSource = self
        
        self.colView.clipsToBounds = true
        self.colView.layer.cornerRadius = 4
        
    }
    
    @IBAction func dailyAction(_ sender: UIButton) {
        self.selectedTab = 0
        self.dailyBtn.tag = 1
        self.weeklyBtn.tag = 0
        self.monthlyBtn.tag = 0
        self.yearlyBtn.tag = 0
        self.colView.reloadData()
    }
    
    @IBAction func weeklyAction(_ sender: UIButton) {
        self.selectedTab = 1
        self.dailyBtn.tag = 0
        self.weeklyBtn.tag = 1
        self.monthlyBtn.tag = 0
        self.yearlyBtn.tag = 0
        self.colView.reloadData()
    }
    
    @IBAction func monthlyAction(_ sender: UIButton) {
        self.selectedTab = 2
        self.dailyBtn.tag = 0
        self.weeklyBtn.tag = 0
        self.monthlyBtn.tag = 1
        self.yearlyBtn.tag = 0
        self.colView.reloadData()
    }
    
    @IBAction func yearlyAction(_ sender: UIButton) {
        self.selectedTab = 3
        self.dailyBtn.tag = 0
        self.weeklyBtn.tag = 0
        self.monthlyBtn.tag = 0
        self.yearlyBtn.tag = 1
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tblView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as? HomeTableViewCell else {
            return UITableViewCell()
        }
        cell.tasksStackView.isHidden = !self.checked.contains(indexPath)
        cell.didTapCategory = {
            if self.checked.contains(indexPath) {
                self.checked.remove(indexPath)
            } else {
                self.checked.insert(indexPath)
            }
            tableView.reloadRows(at:[indexPath], with:.fade)
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
