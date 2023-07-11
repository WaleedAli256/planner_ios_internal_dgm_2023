//
//  HomeViewController2.swift
//  ToDoApp
//
//  Created by mac on 25/06/2023.
//

import UIKit
import Firebase
import FirebaseFirestore
import GoogleMobileAds
import StoreKit

class HomeViewController2: UIViewController {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAllTodayTasks: UILabel!
    @IBOutlet weak var btnRecent: CustomButton!
    @IBOutlet weak var btnUpcoming: CustomButton!
    @IBOutlet weak var btnHistory: CustomButton!
    @IBOutlet weak var btnThisMonth: CustomButton!
    @IBOutlet weak var colView: UICollectionView!
    @IBOutlet weak var stackInnerView: UIView!
    @IBOutlet weak var bottomeInnerTopView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblTotalTaskNumbr: UILabel!
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var colViewHeight: NSLayoutConstraint!
    var filterTodayTask:[Task] = []
    var isExpanded: Bool = false
    var heightIncreased: Bool = false
    var selectedIndex = -1
    var allTasks: [Task] = []
    var upcomingTaskArray: [Task] = []
    var historyTaskArray: [Task] = []
    var categories: [TaskCategory] = []
    var favCategories: [TaskCategory] = []
    var cateAgainstName = [customCategories]()
    
    var bottomViewMinHeight = 0.0
    var bottomViewMaxHeight = 0.0
    var changeVal = false
    var myY = 0.0
    struct customCategories {
        var cateName = String()
        var array = [Task]()
    }
    
    var colCellColorArray = ["cat-color-1","cat-color-2","cat-color-3","cat-color-4","cat-color-5","cat-color-6"]
    var tbleCellColors = ["task-cell-color-1","task-cell-color-2","task-cell-color-3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.timeDueAndAgo("07/06/2023 5:50 PM")
        Utilities.setStringForKey(Constants.UserDefaults.currentUserExit, key: "NoUserExist")
        Utilities.setIsFirstTime(isFirstTime: false)
        Utilities.setStringForKey("false", key: "logout")
    
//        bottomViewTopConstraint.constant = 260
        
        tblView.register(UINib(nibName: "TaskCell2", bundle: nil), forCellReuseIdentifier: "TaskCell2")
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        
//       \
        
//        bottomView.addGestureRecognizer(gestureRecognizer)
        bottomView.addGestureRecognizer(panGestureRecognizer)
        self.colView.dataSource = self
        self.colView.delegate = self
        self.bottomViewHeight.constant =  400
        self.tapButtons(btnRecent, [btnHistory,btnUpcoming,btnThisMonth])
        
        
    }
    
    @objc private func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        self.bottomViewMaxHeight = (UIScreen.main.bounds.height - 125 - topsafearea)
        let translation = gestureRecognizer.translation(in: view)
        
        var newHeight = bottomViewHeight.constant
        print("state \(gestureRecognizer.state)")
        switch gestureRecognizer.state {
        case .changed:
            print(translation.y)
           
            if translation.y < 0 && translation.y > -300{
    //                if changeVal == false{
    //                    changeVal = true
    //                    myY = translation.y
    //                }

                    newHeight += -translation.y
                    newHeight = newHeight + myY
                    if ((newHeight) < bottomViewMaxHeight){
                        bottomViewHeight.constant = newHeight
                    }
                    myY = translation.y
                }
                if translation.y > 0 {
    //                if changeVal == false{
    //                    changeVal = true
    //                    myY = translation.y
    //                }

                    newHeight -= translation.y
                    newHeight = newHeight + myY
                    if ((newHeight) > bottomViewMinHeight){
                        bottomViewHeight.constant = newHeight
                    }
                    myY = translation.y
                }

    //            if newHeight > 200{
    //                //            print(newHeight)
    //                //            newHeight = (newHeight)
    //                bottomViewHeight.constant = newHeight
    //            }
                view.layoutIfNeeded()
                break

            case .ended , .cancelled :
                 myY = 0.0
                if translation.y < 0 && !isExpanded {
                    isExpanded = true
                    UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: .curveEaseInOut) {
                        self.bottomViewHeight.constant = self.bottomViewMaxHeight
                        self.view.layoutIfNeeded()
                    }
                } else if translation.y > 0 && isExpanded {
                    isExpanded = false
                    UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: .curveEaseInOut) {
                        self.bottomViewHeight.constant = self.bottomViewMinHeight
                        self.view.layoutIfNeeded()
                    }
                }
                break
            default:
                break
            }
        }


    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        let now = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: now)

        var greeting = ""

        if hour < 12 {
            greeting = "Good Morning"
        } else if hour < 17 {
            greeting = "Good Afternoon"
        } else {
            greeting = "Good Evening"
        }
        self.lblName.text = "\(greeting),\(Utilities().getCurrentUser().name ?? "")!"
        if btnRecent.tag == 1 {
            self.getAllTasks(userId: Utilities().getCurrentUser().id ?? "") { Status in
                if Status {
                    let singleDigitNumber = self.allTasks.count
                    let formattedNumber = String(format: "%02d", singleDigitNumber)
                    print(formattedNumber)
                    if formattedNumber.count == 0 {
                        self.lblTotalTaskNumbr.text = "0/ \(self.allTasks.count)"
                    } else {
                        self.lblTotalTaskNumbr.text = "\(formattedNumber) / \(self.allTasks.count)"
                    }
                    self.tblView.reloadData()
                }
            }
        } else if btnUpcoming.tag == 1 {
            self.upcomingTasks()
        } else if btnHistory.tag == 1 {
            self.historyTask()
        } else if btnThisMonth.tag == 1 {
            self.monthlyTask()
        }
//
        self.getAllTasks(userId: Utilities().getCurrentUser().id ?? "") { Status in
            if Status {
//                self.tblView.reloadData()
                //only today task
                self.filterTodayTask.removeAll()
                self.filterTodayTask = self.allTasks
                let myTodayDat = self.convertDateToStr("MM/dd/yyyy")
                let todayTasks = self.filterTodayTask.filter { task in
                    return myTodayDat == task.time!
                }
                let singleDigitNumber = todayTasks.count
                let formattedNumber = String(format: "%02d", singleDigitNumber)
                print(formattedNumber)
                if singleDigitNumber == 00 {
                    self.lblAllTodayTasks.text = "You’ve 0 Tasks Today"
                } else {
                    self.lblAllTodayTasks.text = "You’ve \(formattedNumber) Tasks Today"
                }
               
//                if self.btnRecent.tag == 1 {
//                    if formattedNumber.count == 0 {
//                        self.lblTotalTaskNumbr.text = "0/ \(self.allTasks.count)"
//                    } else {
//                        self.lblTotalTaskNumbr.text = "\(formattedNumber) / \(self.allTasks.count)"
//                    }
//                }
//
                self.getCategories(userId: Utilities().getCurrentUser().id ?? "") { Status in
                    if Status {
                        self.cateAgainstName.removeAll()
                        for temp in self.favCategories {
                            let filteredArray = self.allTasks.filter({$0.categoryName == temp.name })
                            let newObj = customCategories(cateName: temp.name ?? "", array: filteredArray)
                            self.cateAgainstName.append(newObj)
                        }
                            
                            let cellHeight: CGFloat = 55.0
                            let numberOfCells = self.cateAgainstName.count
                            let numberOfRows = (numberOfCells + 1) / 2
                            let totalHeight = cellHeight * CGFloat(numberOfRows)
                            self.colViewHeight.constant = totalHeight + 20
                            self.colViewHeight.constant = (totalHeight + 40)
                            self.bottomViewMinHeight = UIScreen.main.bounds.height - (210 + totalHeight + 40)
                            self.bottomViewHeight.constant = self.bottomViewMinHeight
                            self.colView.reloadData()
                    }
                }

            }

        }
       
    }
    
    @IBAction func searchBtnAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let searchTaskVC = storyboard.instantiateViewController(identifier: "SeachTaskViewController") as! SeachTaskViewController
        searchTaskVC.fromViewController = "HomeVC"
        self.navigationController?.pushViewController(searchTaskVC, animated: true)
    }

    @IBAction func recentAction(_ sender: UIButton) {
        self.tapButtons(btnRecent, [btnHistory,btnUpcoming,btnThisMonth])
        self.btnRecent.tag = 1
        self.btnHistory.tag = 0
        self.btnUpcoming.tag = 0
        self.btnThisMonth.tag = 0
        self.getAllTasks(userId: Utilities().getCurrentUser().id ?? "") { Status in
            if Status {
                let singleDigitNumber = self.allTasks.count
                let formattedNumber = String(format: "%02d", singleDigitNumber)
                print(formattedNumber)
                if formattedNumber.count == 0 {
                    self.lblTotalTaskNumbr.text = "0/ \(self.allTasks.count)"
                } else {
                    self.lblTotalTaskNumbr.text = "\(formattedNumber) / \(self.allTasks.count)"
                }
                self.tblView.reloadData()
            }
        }
        
    }
    
    @IBAction func upcomingAction(_ sender: UIButton) {
        self.tapButtons(btnUpcoming, [btnHistory,btnRecent,btnThisMonth])
        
        self.btnRecent.tag = 0
        self.btnHistory.tag = 0
        self.btnUpcoming.tag = 1
        self.btnThisMonth.tag = 0
        self.upcomingTasks()
     
    }
    
    func upcomingTasks() {
        
        var calendar = Calendar.current
        let currentDate = Date().localDate()
    
        guard let currentWeekInterval = calendar.dateInterval(of: .weekOfYear, for: currentDate) else {
            return
        }
        
        let currentWeekStartDate = currentWeekInterval.start
        let currentWeekEndDate = currentWeekInterval.end
        let currentMyDate = self.convertDateToString("MM/dd/yyyy h:mm a")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy h:mm a"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale.current//(identifier: "fr")
        let currentDateString = dateFormatter.string(from: currentWeekStartDate)
        let EndDateString = dateFormatter.string(from: currentWeekEndDate)
        
        self.getAllTasks(userId: Utilities().getCurrentUser().id ?? "") { Status in
            if Status {
                let currentWeekTasks = self.allTasks.filter { task in
                    return currentDateString <= task.date! && task.date! <= EndDateString && currentMyDate <= task.date!
                }
                
                print(currentWeekTasks.count)
                self.allTasks.removeAll()
                self.allTasks = currentWeekTasks
                
                self.numberformatter(currentWeekTasks)
                
                self.tblView.reloadData()
            }
        }
        
    }
    
    @IBAction func historyAction(_ sender: UIButton) {
        self.tapButtons(btnHistory, [btnUpcoming,btnRecent,btnThisMonth])
        self.btnRecent.tag = 0
        self.btnHistory.tag = 1
        self.btnUpcoming.tag = 0
        self.btnThisMonth.tag = 0
        self.historyTask()
    }
    
    func historyTask() {
        
        self.getAllTasks(userId: Utilities().getCurrentUser().id ?? "") { Status in
            if Status {
                
                let myCurrentDate = self.convertDateToString("MM/dd/yyyy h:mm a")
                print(myCurrentDate)
                let passedTasks = self.allTasks.filter { task in
                    return task.date! < myCurrentDate
                }
                self.allTasks.removeAll()
                self.allTasks = passedTasks
                self.numberformatter(passedTasks)
                self.tblView.reloadData()
            }
        }
        
    }
    
    @IBAction func thisMonthAction(_ sender: UIButton) {
        self.tapButtons(btnThisMonth, [btnHistory,btnRecent,btnUpcoming])
        self.btnRecent.tag = 0
        self.btnHistory.tag = 0
        self.btnUpcoming.tag = 0
        self.btnThisMonth.tag = 1
        self.monthlyTask()
    }
    
    func monthlyTask() {
        
        var calendar = Calendar.current
        let currentDate = Date()
    
        guard let currentWeekInterval = calendar.dateInterval(of: .month, for: currentDate) else {
            return
        }
        let currentWeekStartDate = currentWeekInterval.start
        let currentWeekEndDate = currentWeekInterval.end
        let dat = self.convertDateToString2("MM/dd/yyyy h:mm a", currentWeekStartDate)
        let dat2 = self.convertDateToString2("MM/dd/yyyy h:mm a", currentWeekEndDate)
        let dat3 = self.convertDateToString2("MM/dd/yyyy h:mm a", currentDate)
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MM/dd/yyyy h:mm a"
//        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
//        dateFormatter.locale = Locale.current//(identifier: "fr")
//        let currentDateString = dateFormatter.string(from: currentWeekStartDate)
//        let EndDateString = dateFormatter.string(from: currentWeekEndDate)
        
        self.getAllTasks(userId: Utilities().getCurrentUser().id ?? "") { Status in
            if Status {
                let currentWeekTasks = self.allTasks.filter { task in
                    return dat <= task.date! && task.date! <= dat2 && dat3 <= task.date!
                }
                print(currentWeekTasks.count)
                self.allTasks.removeAll()
                self.allTasks = currentWeekTasks
                self.numberformatter(currentWeekTasks)
                self.tblView.reloadData()
            }
        }
    }
    
    func numberformatter(_ taskArrayCount: [Task] ) {
        
        let singleDigitNumber = taskArrayCount.count
        let formattedNumber = String(format: "%02d", singleDigitNumber)
        print(formattedNumber)
        
        if taskArrayCount.count == 0 {
            self.lblTotalTaskNumbr.text = "\(taskArrayCount.count)"
        } else {
            self.lblTotalTaskNumbr.text = "\(formattedNumber)"
        }
    }
    
    func convertDateToStr(_ formateType: String) -> String {
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = formateType
            dateFormatter.timeZone = TimeZone.current
        let currentDateString = dateFormatter.string(from: currentDate)
        return currentDateString
    }
    
    func convertDateToString(_ formateType: String) -> String {
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy h:mm a"
            dateFormatter.timeZone = TimeZone.current
        let currentDateString = dateFormatter.string(from: currentDate)
//        print(currentDateString)
        return currentDateString
    }
    
    func convertDateToString2(_ formateType: String,_ myDate: Date) -> String {
        
//        let currentDate = Date()
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy h:mm a"
            dateFormatter.timeZone = TimeZone.current
        let currentDateString = dateFormatter.string(from: myDate)
//        print(currentDateString)
        return currentDateString
    }
    
    func convertDateStrIntoTimeFormate(_ taskDate: String) -> String{
        
        let dateString = taskDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy h:mm a"
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "h:mm a"
            let formattedTime = dateFormatter.string(from: date)
            return formattedTime
        } else {
            return "Invalide TIme"
        }
    }
    
   
    
    @IBAction func seeAllAction(_ sender: UIButton) {
        _ = self.tabBarController?.selectedIndex = 1
    }
    
//    @IBAction func bottomViewGestureAction(_ sender: UIButton) {
//
//        if isExpanded {
//            self.isExpanded = false
//            bottomViewTopConstraint.constant = 260
//        } else {
//            self.isExpanded = true
//            bottomViewTopConstraint.constant = 10
//        }
//
//    }
    
    func tapButtons(_ btnSelected: UIButton, _ btnDeselected: [UIButton])  {
        btnSelected.isSelected = true
        for i in btnDeselected {
            i.isSelected = false
        }
    }
    
    func getAllTasks(userId:String, completion: @escaping(_ Status: Bool) -> Void) {
        self.allTasks.removeAll()
        let db = Firestore.firestore()
        db.collection("tasks").whereField("userId", isEqualTo: userId)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    completion(false)
                } else {
                    self.allTasks.removeAll()
                    for document in querySnapshot!.documents {
                        let dicCat = document.data()
                        var objCat = Task.init(fromDictionary: dicCat)
                        self.timeDueAndAgo(objCat.date ?? "") { status, str in
                            if status{
                                objCat.dueOrAgoTime = str
                            }else{
                                objCat.dueOrAgoTime = ""
                            }
                        }
                        self.allTasks.append(objCat)
                    
                    }
                    self.getSortTasksByDate(tasks: self.allTasks) { Status, sortedTasks in
                    self.allTasks = sortedTasks!
                }
                    completion(true)
                   
                }
            }
    }
    
    func getSortTasksByDate(tasks: [Task], completion: @escaping(_ Status: Bool,_ sortedTasks : [Task]?) -> Void) {
        let sortedTasks = tasks.sorted { (task1, task2) -> Bool in
            guard let date1 = task1.date, let date2 = task2.date else {
                completion(false,nil)
                return false
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy h:mm a" // Adjust the date format according to your needs
            
            if let parsedDate1 = dateFormatter.date(from: date1), let parsedDate2 = dateFormatter.date(from: date2) {
                return parsedDate1 > parsedDate2
            }
            completion(false,nil)
            return false
        }
        
        completion(true,sortedTasks)
        return
    }
    
    func getCategories (userId:String, completion: @escaping(_ Status: Bool) -> Void) {
        let db = Firestore.firestore()
        db.collection("category").whereField("userId", isEqualTo: userId)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    completion(false)
                    print("Error getting documents: \(err)")
                } else {
                    self.categories.removeAll()
                    for document in querySnapshot!.documents {
                        let dicCat = document.data()
                        let objCat = TaskCategory.init(fromDictionary: dicCat)
                        self.categories.append(objCat)
                    }
                    let filteredFavCat = self.categories.filter({$0.isFavourite == true })
                    self.favCategories = filteredFavCat
                    completion(true)
                }
            }
        
    
        
//        for temp in self.categories{
//            let filteredArray = self.allTasks.filter({$0.categoryName == temp.name })
//            let newObj = customCategories(cateName: temp.name ?? "", array: filteredArray)
//            self.cateAgainstName.append(newObj)
//        }
//        self.colView.reloadData()
    }
    
    func timeDueAndAgo(_ taskDate: String, completion: @escaping (_ status : Bool, _ str : String?) -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy h:mm a"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.current
        
        guard let myTaskDate = dateFormatter.date(from: taskDate) else {
            print("Invalid taskDate format")
            completion(false,nil)
            return
        }
        
        let now = Date()
        
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute,.second], from: myTaskDate, to: now)
        
        var str = ""
        
        if let years = ageComponents.year, years > 0 {
            str = "\(years) year\(years > 1 ? "s" : "") "
        }else if let months = ageComponents.month, months > 0 {
            str.append("\(months) month\(months > 1 ? "s" : "") ")
        }else if let days = ageComponents.day, days > 0 {
            str.append("\(days) day\(days > 1 ? "s" : "") ")
        }else if let hours = ageComponents.hour, hours > 0 {
            str.append("\(hours) hour\(hours > 1 ? "s" : "") ")
        }else if let minutes = ageComponents.minute, minutes > 0 {
            str.append("\(minutes) minute\(minutes > 1 ? "s" : "") ")
        }else if let seconds = ageComponents.second, seconds > 0 {
            str.append("\(seconds) second\(seconds > 1 ? "s" : "") ")
        }
        
        if str == ""{
//            completion(false,str)
        }else{
            if str == "Just Now"{
                completion(true,str)
                return
            }else{
                str = "\(str) Ago"
                completion(true,str)
                return
            }
            
        }
        
         str = ""
        
        if let years = ageComponents.year, years < 0 {
            str = "\(-years) year\(-years > 1 ? "s" : "") "
        }else if let months = ageComponents.month, months < 0 {
            str.append("\(-months) month\(-months > 1 ? "s" : "") ")
        }else if let days = ageComponents.day, days < 0 {
            str.append("\(-days) day\(-days > 1 ? "s" : "") ")
        }else if let hours = ageComponents.hour, hours < 0 {
            str.append("\(-hours) hour\(-hours > 1 ? "s" : "") ")
        }else if let minutes = ageComponents.minute, minutes < 0 {
            str.append("\(-minutes) minute\(-minutes > 1 ? "s" : "") ")
        }else if let seconds = ageComponents.second, seconds < 0 {
            str.append("\(-seconds) minute\(-seconds > 1 ? "s" : "") ")
        }else if let second = ageComponents.second, second < 0 {
            str.append("\(-second) second\(-second > 1 ? "s" : "") ")
        }
        
        if str == ""{
            completion(true,"Just Now")
            return
        }else{
            if str == "Just Now"{
                completion(true,str)
                return
            }else{
                str = "Due in \(str)"
                completion(true,str)
                return
            }
            
        }
        
    }
    
    func deleteTaskAgainstId(taskId:String,completion: @escaping (_ status : Bool) -> Void){
        let db = Firestore.firestore()
       var taskIds = [String]()
        db.collection("tasks").whereField("id", isEqualTo: taskId).getDocuments {(querySnapshot , err) in
            if let err = err {
                print("Error removing document: \(err)")
                completion(false)
            } else {
                guard let documents = querySnapshot?.documents else { return }
                       for document in documents {
                           taskIds.append(document.documentID)
                           document.reference.delete()
                }
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: taskIds)
//                    self.getCategories(userId: Utilities().getCurrentUser().id ?? "")
                print("Document successfully removed!")
                completion(true)

            }
        }

    }

}

extension HomeViewController2 : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if cateAgainstName.count >= 6{
            return 6
        } else if cateAgainstName.count == 0 {
            return 0
        } else {
            return cateAgainstName.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = colView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell2", for: indexPath) as? HomeCollectionViewCell2 else {
            return UICollectionViewCell()
        }
        
        let catObj = cateAgainstName[indexPath.row]
        cell.lblCatName.text = catObj.cateName
        cell.lblTaskCount.text = "\(catObj.array.count)"
        cell.catBgView.backgroundColor = UIColor(named: colCellColorArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let searchTaskVC = storyboard.instantiateViewController(identifier: "SeachTaskViewController") as! SeachTaskViewController
        searchTaskVC.selectedCategory = self.favCategories[indexPath.row]
        searchTaskVC.fromViewController = "CategoryVC"
        searchTaskVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(searchTaskVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        let spacing: CGFloat = 10.0 // Adjust the spacing between cells as needed
//        let totalSpacing = spacing * 3 // spacing * (numberOfCells - 1)
        let itemWidth = (collectionViewWidth - spacing) / 2
//        let itemHeight = collectionView.bounds.height
        return CGSize(width: itemWidth, height: 55)
    }
}

extension HomeViewController2: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allTasks.count
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "") { (action, view, completionHandler) in
            // Handle delete action here
            let alertController = UIAlertController(title: "Alert", message: "Are you sure you want to delete this task?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.destructive) {
                UIAlertAction in
                self.deleteTaskAgainstId(taskId: self.allTasks[indexPath.row].id!) { status in
                  if status {
//                      self.getAllTasks(userId: Utilities().getCurrentUser().id ?? "") { Status in
//                          if Status {
//                              self.tblView.reloadData()
//                              self.colView.reloadData()
//                          }
//                      }
//                      self.getTaskAgaintCategory()
                  }
              }
        }
          let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
                UIAlertAction in
        }
            // Add the actions
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)

          self.present(alertController, animated: true, completion: nil)
            completionHandler(true)
        }
        
        deleteAction.backgroundColor = .white
        deleteAction.image = UIImage(named: "delete")
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tblView.dequeueReusableCell(withIdentifier: "TaskCell2", for: indexPath) as? TaskCell2 else {
            return UITableViewCell()
        }
        
        let taskObje = self.allTasks[indexPath.row]
        if selectedIndex == indexPath.row {
            cell.lblDetail.isHidden = false
            cell.lblDetail.text = taskObje.description
        } else {
            cell.lblDetail.isHidden = true
            cell.lblDetail.text = ""
        }
    
        let colorIndex = indexPath.row % tbleCellColors.count
        cell.taskViewBgColor.backgroundColor = UIColor(named: tbleCellColors[colorIndex])
//        cell.taskViewBgColor.backgroundColor = UIColor(named: tbleCellColors[indexPath.row])
        if self.tbleCellColors[colorIndex] == "task-cell-color-2" {
            cell.lbltitle.textColor = .white
            cell.lblCatName.textColor = .white
            cell.lblDetail.textColor = .white
            cell.lblTimeRange.textColor = .white
            cell.lblDueTime.textColor = .white
        } else {
            cell.lbltitle.textColor = UIColor(named: "TextColor")
            cell.lblCatName.textColor = UIColor(named: "TextColor")
            cell.lblDetail.textColor = UIColor(named: "TextColor")
            cell.lblTimeRange.textColor = UIColor(named: "TextColor")
            cell.lblDueTime.textColor = UIColor(named: "TextColor")
        }
        
        //line circle img settings
        if indexPath.row == 0 {
//            cell.constraintIineImgHeight.constant = 21
//            cell.constraintIineImgWidth.constant = 21
            cell.leftLineImg.image = UIImage(named: "task-left-line-img2")
        } else {
            cell.constraintIineImgHeight.constant = 17
            cell.constraintIineImgWidth.constant = 17
            cell.leftLineImg.image = UIImage(named: "task-left-line-img")
        }
        cell.lblCatName.text = taskObje.categoryName
        cell.lbltitle.text = taskObje.title
        
//        let dateString = taskObje.date
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MM/dd/yyyy h:mm a"
//        if let date = dateFormatter.date(from: dateString!) {
//            dateFormatter.dateFormat = "h:mm a"
//            let formattedTime = dateFormatter.string(from: date)
//            cell.lblTimeRange.text = (formattedTime ?? "")
//        } else {
//            print("Invalid date string")
//        }
        let formatedDateIs = self.convertDateStrIntoTimeFormate(taskObje.date!)
        cell.lblTimeRange.text = formatedDateIs
        
        if taskObje.endTime ?? "" != ""{
            cell.lblTimeRange.text?.append(" - \(taskObje.endTime ?? "")")
        }
        cell.lblDueTime.text = taskObje.dueOrAgoTime
        
//        self.labelAttributedString(cell.lblDueTime)
        cell.selectionStyle = .none
        return cell
    }
    
    func labelAttributedString(_ lblDue: UILabel) {
        
        let attributedString1 = NSAttributedString(string: "Due in ",attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0, weight: .regular)])
        let attributedString2 = NSAttributedString(string: "2 Hour", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0, weight: .semibold)])

        let mutableAttributedString = NSMutableAttributedString()
        mutableAttributedString.append(attributedString1)
        mutableAttributedString.append(attributedString2)
        lblDue.attributedText = mutableAttributedString
    }
    
    func setShadowForView() {
        
        self.bottomView.layer.shadowColor = UIColor.red.cgColor
        self.bottomView.layer.shadowOpacity = 0.5
        self.bottomView.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.bottomView.layer.shadowRadius = 4

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if selectedIndex == indexPath.row{
            selectedIndex = -1
        }else{
            self.selectedIndex = indexPath.row
        }

        self.tblView.reloadData()
    }
}

class CustomButton: UIButton {
    // Customization properties
    var selectedColor: UIColor = UIColor(named: "btn-selection-color")!
    var deselectedBordrColor: UIColor = UIColor(named: "btn-Deselection-bordr-color")!
    var deselectedTitleColor: UIColor = UIColor(named: "btn-Deselection-title-color")!
//    var deSelectedBtmBorderColor: UIColor = .lightGray
    var bottomBorderHeight: CGFloat = 2.0
    
    // Track the selected state
    override var isSelected: Bool {
        didSet {
            updateButtonAppearance()
        }
    }
    
    // Update the button's appearance based on the selected state
    private func updateButtonAppearance() {
        
        if isSelected {
            setTitleColor(selectedColor, for: .normal)
            setBottomBorder(color: selectedColor, height: bottomBorderHeight)
        } else {
            setTitleColor(deselectedTitleColor, for: .normal)
            setBottomBorder(color: deselectedBordrColor, height: bottomBorderHeight)
        }

    }
    
    // Helper method to add a bottom border to the button
    private func setBottomBorder(color: UIColor, height: CGFloat) {
        let borderLayer = CALayer()
        borderLayer.backgroundColor = color.cgColor
        borderLayer.frame = CGRect(x: 0, y: bounds.height - height, width: bounds.width, height: height)
        layer.addSublayer(borderLayer)
    }
}


//import UIKit

//class BottomView: UIView {
//
//    @IBInspectable var defaultHeight: CGFloat = 400.0 {
//            didSet {
//                updateViewHeight()
//            }
//        }
//
//        @IBInspectable var expandedHeight: CGFloat = UIScreen.main.bounds.height {
//            didSet {
//                updateViewHeight()
//            }
//        }
//
//
//     var isExpanded = false {
//        didSet {
//            updateViewHeight()
//        }
//    }
//
//    private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
//        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
//        return gestureRecognizer
//    }()
//
//    private lazy var panGestureRecognizer: UIPanGestureRecognizer = {
//        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
//        return gestureRecognizer
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupGestureRecognizers()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setupGestureRecognizers()
//    }
//
//    private func setupGestureRecognizers() {
//        addGestureRecognizer(tapGestureRecognizer)
//        addGestureRecognizer(panGestureRecognizer)
//    }
//
//    private func updateViewHeight() {
//        let newHeight = isExpanded ? expandedHeight : defaultHeight
//        frame.size.height = newHeight
//        superview?.layoutIfNeeded()
//    }
//
//    @objc private func handleTap() {
//        isExpanded = !isExpanded
//    }
//
//    @objc private func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
//        let translation = gestureRecognizer.translation(in: self)
//
//        switch gestureRecognizer.state {
//        case .changed:
//            let newHeight = max(defaultHeight + translation.y, defaultHeight)
//            frame.size.height = newHeight
//            superview?.layoutIfNeeded()
//        case .ended:
//            let shouldExpand = translation.y < -50.0 // Adjust the threshold as per your preference
//            isExpanded = shouldExpand
//        default:
//            break
//        }
//    }
//}
