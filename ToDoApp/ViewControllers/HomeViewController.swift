//
//  HomeViewController.swift
//  ToDoApp
//
//  Created by mac on 07/04/2023.
//

import UIKit
import Firebase
import FirebaseFirestore

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
    
    let dailyTime = ["12 AM", "1 AM", "2 AM", "3 AM", "4 AM", "5 AM", "7 AM", "8 AM", "9 AM", "10 AM", "11 AM", "12 PM", "1 PM", "2 PM", "3 PM", "4 PM", "5 PM", "6 PM", "7 PM", "8 PM", "9 PM", "10 PM", "11 PM"]
    
    let dailyDays = ["Yesterday","Today","Tommorow"]
    
    let weeklyDays = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"]
    
    let monthlyDays = ["01","02","03","04","05","06","07","08","09","10", "11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30"]
    
    var selectedTab = 0
    var centerCell: HomeCollectionViewCell?
    var tableCenterCell: HomeTableViewCell?
    var selectedTableIndex = -1
    var selectedCollectionIndex = -1
    
    var dailySelected = 1
    var weeklySelected = -1
    var monthlySelected = -1
    var yearlySelected = -1
    
    var allTasks: [Task] = []
    
    var selectedDayTasks:[Task] = []
//    var updateValues = true

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.delegate = self
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getAllTasks(userId: Utilities().getCurrentUser().id ?? "")
    }
    
    func getAllTasks(userId:String) {
        Utilities.show_ProgressHud(view: self.view)
        self.allTasks.removeAll()
        let db = Firestore.firestore()
        db.collection("tasks").whereField("userId", isEqualTo: userId)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    Utilities.hide_ProgressHud(view: self.view)
                } else {
                    Utilities.hide_ProgressHud(view: self.view)
                    for document in querySnapshot!.documents {
                        let dicCat = document.data()
                        let objCat = Task.init(fromDictionary: dicCat)
                        self.allTasks.append(objCat)
                        self.selectedDayTasks = []
                    }
                    self.getTasks()
                    self.tblView.reloadData()
                }
            }
    }
    func change(to index: Int) {
        self.selectedTab = index
        self.colView.reloadData()
    }
    
    func filterDailyTasks(day:Int, task:Task) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy h:mm a"

        var taskDate = Date()
        if let date = dateFormatter.date(from: task.date ?? "") {
            taskDate = date
            print(date)
        } else {
            print("Invalid date format")
            return
        }
        
        let calendar = Calendar.current
        
        if day == 0 {
            if calendar.isDateInYesterday(taskDate) {
                print("Given date is yesterday")
                self.selectedDayTasks.append(task)
            }
        } else if day == 1 {
            if calendar.isDateInToday(taskDate) {
                print("Given date is today")
                self.selectedDayTasks.append(task)
            }
        } else {
            if calendar.isDateInTomorrow(taskDate) {
                print("Given date is tomorrow")
                self.selectedDayTasks.append(task)
            }
        }
    }
    
    func filterWeeklyTasks(day:Int, task:Task) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy h:mm a"

        var taskDate = Date()
        if let date = dateFormatter.date(from: task.date ?? "") {
            taskDate = date
            print(date)
        } else {
            print("Invalid date format")
            return
        }
        
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: taskDate)

        if day == 1 && weekday == 2 {
            self.selectedDayTasks.append(task)
        }
        
        if day == 2 && weekday == 3 {
            self.selectedDayTasks.append(task)
        }
        
        if day == 3 && weekday == 4 {
            self.selectedDayTasks.append(task)
        }
        
        if day == 4 && weekday == 5 {
            self.selectedDayTasks.append(task)
        }
        
        if day == 5 && weekday == 6 {
            self.selectedDayTasks.append(task)
        }
        
        if day == 6 && weekday == 7 {
            self.selectedDayTasks.append(task)
        }
        
        if day == 7 && weekday == 1 {
            self.selectedDayTasks.append(task)
        }
    }
    
    func filterMonthlyTasks(day:Int, task:Task) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy h:mm a"

        var taskDate = Date()
        if let date = dateFormatter.date(from: task.date ?? "") {
            taskDate = date
            print(date)
        } else {
            print("Invalid date format")
            return
        }
        
        let calendar = Calendar.current
        let taskDay = calendar.component(.day, from: taskDate)

        if day == taskDay {
            self.selectedDayTasks.append(task)
        }
        print("Day: \(day)")
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
        cell.transformCellToStandard()
        if self.selectedTab == 0 {
            if indexPath.row == self.dailySelected {
                cell.transformCellToLarge()
            } else {
                cell.transformCellToStandard()
            }
            
        }  else if self.selectedTab == 1 {
            if indexPath.row == self.weeklySelected {
                cell.transformCellToLarge()
            } else {
                cell.transformCellToStandard()
            }
        }  else if self.selectedTab == 2 {
            if indexPath.row == self.monthlySelected {
                cell.transformCellToLarge()
            } else {
                cell.transformCellToStandard()
            }
        }  else if self.selectedTab == 3 {
            if indexPath.row == self.yearlySelected {
                cell.transformCellToLarge()
            } else {
                cell.transformCellToStandard()
            }
        }
        
        
        cell.dayLbl.text = value
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        DispatchQueue.main.async {
            self.centerCell = self.colView.cellForItem(at: indexPath) as? HomeCollectionViewCell
            
            self.centerCell?.transformCellToLarge()
            for cell in collectionView.visibleCells {
                (cell as? HomeCollectionViewCell)?.transformCellToStandard()
            }
            self.centerCell?.transformCellToLarge()
        }
        
        if self.selectedTab == 0 {
            self.dailySelected = indexPath.row
        }  else if self.selectedTab == 1 {
            self.weeklySelected = indexPath.row
        }  else if self.selectedTab == 2 {
            self.monthlySelected = indexPath.row
        }  else if self.selectedTab == 3 {
            self.yearlySelected = indexPath.row
        }
        self.getTasks()
        collectionView.reloadData()
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
    
    func getTasks() {
        self.selectedDayTasks.removeAll()
        for tsk in self.allTasks {
            if self.selectedTab == 0 {
                self.filterDailyTasks(day: self.dailySelected, task: tsk)
            }  else if self.selectedTab == 1 {
                self.filterWeeklyTasks(day: self.weeklySelected, task: tsk)
            }  else if self.selectedTab == 2 {
                self.filterMonthlyTasks(day: self.monthlySelected, task: tsk)
            }  else if self.selectedTab == 3 {
                self.filterMonthlyTasks(day: self.yearlySelected, task: tsk)
            }
        }
//        self.updateValues = true
        self.tblView.reloadData()
    }
}

extension HomeViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dailyTime.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as! HomeTableViewCell
        
        cell.index = indexPath
        cell.selectedTableIndex = selectedTableIndex
        cell.selectedCollectionIndex = selectedCollectionIndex
        cell.colView.reloadData()
        if indexPath.row == selectedTableIndex {
            cell.tasksStackView.isHidden = false
            cell.transformCellToLarge()
//            cell.timeLbl.font = UIFont.boldSystemFont(ofSize: 14)
            cell.colView.reloadData()
        }else{
            cell.transformCellToStandard()
            cell.tasksStackView.isHidden = true
        }
        
        cell.timeLbl.text = self.dailyTime[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy h:mm a"

//        if self.updateValues {
//            if indexPath.row == self.dailyTime.count - 1 {
//                self.updateValues = false
//            }
        let finalTask = self.selectedDayTasks.filter { task in
            if let date = dateFormatter.date(from: task.date ?? "") {
                let formatter = DateFormatter()
                formatter.dateFormat = "h a"
                let hour = formatter.string(from: date)
                return hour == self.dailyTime[indexPath.row]
            }
            return false
        }
        cell.myFinalCategories.removeAll()// = [:]
        for item in finalTask {
            if cell.myFinalCategories[item.categoryName!] == nil{
                cell.myFinalCategories[item.categoryName!] = [item]
            }else{
                cell.myFinalCategories[item.categoryName!]!.append(item)
            }
        }
        cell.tasks.removeAll()// = []
        for dic in cell.myFinalCategories{
            let task = (dic.value as? [Task])!
            cell.tasks.append(CatTasks(catName: dic.key, tasks: task))
        }
        for view in cell.tasksStackView.subviews {
            view.removeFromSuperview()
        }
        
                for cat in cell.tasks {
                    for task in cat.tasks {
                        cell.loadTaskView(tag: 1, task: task)
                    }
                }
        
//        if self.selectedCollectionIndex != -1  && cell.tasks.count > 0 {
//            let taskss = cell.tasks[self.selectedCollectionIndex]
//            for teve in taskss.tasks {
//                cell.loadTaskView(tag: 1, task: teve)
//            }
//        }
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension HomeViewController: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
            // Perform actions when tab bar index changes, e.g., call a method, update UI, etc.
//        self.getAllTasks(userId: Utilities().getCurrentUser().id ?? "")
            print("Tab bar index changed to \(tabBarController.selectedIndex)")
        }
}
