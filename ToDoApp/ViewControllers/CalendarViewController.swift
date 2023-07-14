//
//  CalendarViewController.swift
//  ToDoApp
//
//  Created by mac on 31/03/2023.
//

import UIKit
import FSCalendar
import FirebaseFirestore

class CalendarViewController: BaseViewController {

    @IBOutlet weak var tblHeight: NSLayoutConstraint!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblMonthName: UILabel!
    @IBOutlet weak var profilPic: UIImageView!
    @IBOutlet weak var calendar: FSCalendar!
    var selectedIndex = -1
    var mySelectedDate = Date()
    var arrAllTasks = [Task]()
    var selectedDate = ""
    var filterArray = [Task]()
    var cellRow: Int!
    var actionTyp: String!
    var actionIndex: Int!
    var selectedInde: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        profilPic.addGestureRecognizer(tapGesture)
        profilPic.isUserInteractionEnabled = true
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        selectedDate = dateFormatter.string(from: Date().localDate())
        mySelectedDate = dateFormatter.date(from: selectedDate)!
        
        
        self.profilPic.layer.cornerRadius = self.profilPic.frame.size.width / 2
        self.profilPic.clipsToBounds = true
        calendar.appearance.weekdayFont = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        tblView.register(UINib(nibName: "TaskCell", bundle: nil), forCellReuseIdentifier: "TaskCell")
        let currentDate = Date()
        
        let dateString = dateFormatter.string(from: currentDate)
        self.selectedDate = dateString
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "MMMM yyyy"
        let dateStringr = dateFormatter2.string(from: currentDate)
        self.lblMonthName.text = dateStringr
//        self.selectedDate = dateString
//        calendar.select(Date())
        self.calendar.delegate = self
        self.calendar.dataSource = self
        self.tblView.delegate = self
        self.tblView.dataSource = self
//        Utilities.show_ProgressHud(view: self.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setData()
        self.tblView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.getAllTasks(userId: Utilities().getCurrentUser().id ?? "", myDate: mySelectedDate)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.tblView.removeObserver(self, forKeyPath: "contentSize")
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func imageTapped() {
        self.tabBarController?.selectedIndex = 4
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        
        if(keyPath == "contentSize"){
            if(self.tblView.contentSize.height < 0)
            {
                self.tblHeight.constant = 100
            }
            else
            {
                self.tblHeight.constant = self.tblView.contentSize.height + 20
            }
        }
    }
    
    func getAllTasks(userId:String,myDate : Date) {
        self.selectedInde = -1
        self.arrAllTasks.removeAll()
        self.filterArray.removeAll()
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
                        self.arrAllTasks.append(objCat)
                    }
                    let myDateStr = convertDateFormate(myDate)
                    self.filterArray = self.arrAllTasks.filter ({$0.time == myDateStr})
                    Utilities.hide_ProgressHud(view: self.view)
                    self.tblView.reloadData()
                    self.calendar.reloadData()
                    
                }
            }
    }
    

    
//    private func getTasksByDate(date: String){
//        selectedInde = -1
//        guard Utilities.Connectivity.isConnectedToInternet  else {
//            self.showAlert(title: "Network Error", message: "Please check your internet connection")
//            return
//        }
//        Utilities.show_ProgressHud(view: self.view)
////        self.arrTasks.removeAll()
//        let db = Firestore.firestore()
//        db.collection("tasks").whereField("userId", isEqualTo: Utilities().getCurrentUser().id ?? "").whereField("time", isEqualTo: self.selectedDate).getDocuments(completion: {(snapshot,error) in
//            if let err = error
//            {
//                Utilities.hide_ProgressHud(view: self.view)
//                self.showAlert(title: "Error" , message: "\(err)")
//            }
//            else
//            {
//                Utilities.hide_ProgressHud(view: self.view)
////                self.arrAllTasks.removeAll()
////                self.filterArray.removeAll()
//                for doc in snapshot!.documents
//                {
//                    let dictask = doc.data()
//                    let dateObj = dictask["time"] as! String
//                    if self.selectedDate == dateObj {
//                        print(self.selectedDate)
//                        let objTask = Task.init(fromDictionary: dictask)
////                        self.arrAllTasks.append(objTask)
//                        self.filterArray.append(objTask)
//                    }
//
//                }
//                self.calendar.reloadData()
//                self.tblView.reloadData()
////                self.lblTaskNumber.text = "Tasks (\(self.arrTasks.count))"
//            }
//        })
//    }
    
    @IBAction func nextbtnAction(_ sender: UIButton) {
        let monthis = self.getTheMonthByTap(1)
        self.lblMonthName.text = monthis
    }
    
    @IBAction func previousBtnAction(_ sender: UIButton) {
        let monthis = self.getTheMonthByTap(-1)
        self.lblMonthName.text = monthis
    }
    
    func getTheMonthByTap(_ monthNumber: Int) -> String{
        let currentMonth = calendar.currentPage
        let nextMonth = Calendar.current.date(byAdding: .month, value: monthNumber, to: currentMonth)
            calendar.setCurrentPage(nextMonth!, animated: true)
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM yyyy"
            let nextMonthString = formatter.string(from: nextMonth!)
            return nextMonthString
    }
    
    func setData(){
        if Utilities().getCurrentUser().userType == "0" {
            
            // Create a URL object for the profile picture
            let imgUrl = Utilities().getCurrentUser().image_url ?? ""
            guard let url = URL(string: imgUrl) else { return }
            
            // Create a data task to download the profile picture
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                // Check for errors and unwrap the downloaded data
                guard let data = data, error == nil else {
                    print("Error downloading profile picture: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                // Create an image from the downloaded data and display it in the image view
                DispatchQueue.main.async {
                    self.profilPic.image = UIImage(data: data)
                }
            }
            // Start the data task
            task.resume()
            
        } else {
            self.profilPic.image = UIImage(named: "icon-profile")
        }

    }
    
    func deleteTaskAgainstId(taskId: String,completion: @escaping (_ status : Bool) -> Void){
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
                print("Document successfully removed!")
                completion(true)

            }
        }

    }
}

extension CalendarViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filterArray.count
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {
            (action, view, completionHandler) in
            
            let alertController = UIAlertController(title: "Alert", message: "Are you sure you want to delete this task?", preferredStyle: .alert)
          let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.destructive) {
                UIAlertAction in
              self.deleteTaskAgainstId(taskId: self.filterArray[indexPath.row].id!) { status in
                  if status {
                      let dateFormatter = DateFormatter()
                      dateFormatter.dateFormat = "MM/dd/yyyy"
                      let dateString = dateFormatter.string(from: self.mySelectedDate)
                      let da = dateFormatter.date(from: dateString)!
                      self.getAllTasks(userId: Utilities().getCurrentUser().id ?? "", myDate: da)
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
        }
        deleteAction.backgroundColor = UIColor(named: "view-color")
        deleteAction.image = UIImage(named: "delete")
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tblView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        
        let obj = self.filterArray[indexPath.row]
        let originalDateFormat = "MM/dd/yyyy h:mm a"
        let desiredDateFormat = "EE,d MMM h:mm a"
        let originalDateString = obj.date
        cell.selectionStyle = .none
        cell.btndropdown.tag = indexPath.row
        if selectedInde == indexPath.row {
            cell.popupView.isHidden = false
        } else {
            cell.popupView.isHidden = true
        }

        if let formattedDate = Utilities.changeDateFormat(fromFormat: originalDateFormat, toFormat: desiredDateFormat, dateString: originalDateString!) {
            print("Formatted Date: \(formattedDate)")
            cell.lblTimeDate.text = formattedDate
            
            if obj.priority == "High" || obj.priority == "high" {
                    cell.priorityView.backgroundColor = UIColor(named: "high-color")
                    cell.lblpriority.textColor = UIColor(named: "high-text-color")
                    cell.lblpriority.text = "High"
                } else if obj.priority == "Medium" || obj.priority == "medium" {
                    cell.priorityView.backgroundColor = UIColor(named: "medium-color")
                    cell.lblpriority.textColor = UIColor(named: "medium-text-color")
                    cell.lblpriority.text = "Medium"
                } else if obj.priority == "Low" || obj.priority == "low" {
                    cell.priorityView.backgroundColor = UIColor(named: "low-colorP")
                    cell.lblpriority.textColor = UIColor(named: "low-text-color")
                    cell.lblpriority.text = "Low"
                    
            }
//            cell.delegate = self
//            cell.delegate2 = self
            cell.deleteBtn.tag = indexPath.row
            cell.btndropdown.tag = indexPath.row
            cell.lbltitle.text = obj.title
            cell.lblpriority.text = obj.priority
            if selectedIndex == indexPath.row {
                cell.lblDetail.isHidden = false
                cell.lblDetail.text = obj.description
            }else{
                cell.lblDetail.isHidden = true
                cell.lblDetail.text = ""
            }

        } else {
            self.showAlert(title: "Date formate Error", message: "Failed to format date")
//            print("Failed to format date")
        }
        return cell
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


extension CalendarViewController : FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.selectedInde = -1
        mySelectedDate = date
        self.calendar.appearance.todayColor = .clear
        self.calendar.appearance.titleTodayColor = UIColor(named: "LightDarkTextColor")
        let newDateStr = convertDateFormate(date)
        let matchingTasks = arrAllTasks.filter ({$0.time == newDateStr})
        self.filterArray = matchingTasks
        self.tblView.reloadData()
        print(newDateStr)
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("yes")
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM yyyy"
            let month = dateFormatter.string(from: calendar.currentPage)
            self.lblMonthName.text = month
        }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
            let myDateStr = convertDateFormate(date)
            let matchingTasks = arrAllTasks.filter ({$0.time == myDateStr})
            return matchingTasks.count
    
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        var dateArray = [String]()
        for dateObj in self.arrAllTasks {
            dateArray.append(dateObj.time!)
        }
        let myDateStr = convertDateFormate(date)
        if dateArray.contains(myDateStr) {
            return UIColor(named: "primary-color")
        } else {
            return nil
        }
    }
    
    

}

func convertDateFormate(_ dateis: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM/dd/yyyy"
    let newDateString = formatter.string(from: dateis)
    return newDateString
    
}

//extension CalendarViewController: TaskCellDelegate, TaskCellDelegate2{
//    func btnDelete(_ btnTag: Int) {
//        
//        if btnTag == selectedInde {
//            selectedInde = -1
//        } else {
//            selectedInde = btnTag
//        }
//
//        self.tblView.reloadData()
//        
//        // cate id
//        // get cate / skip
//        // all task again that cate id
//        // chak all task is yours / skip
//        // delete all task
//        // than delete cate
//    }
//    
//    func deleteTaskAgainstId(ind: Int,completion: @escaping (_ status : Bool) -> Void){
//        let db = Firestore.firestore()
//        var taskIds = [String]()
//        db.collection("tasks").whereField("id", isEqualTo: self.filterArray[ind].id!).getDocuments {(querySnapshot , err) in
//            if let err = err {
//                print("Error removing document: \(err)")
//                completion(false)
//            } else {
//                guard let documents = querySnapshot?.documents else { return }
//                       for document in documents {
//                           taskIds.append(document.documentID)
//                           document.reference.delete()
//                }
//                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: taskIds)
//                print("Document successfully removed!")
//                completion(true)
//
//            }
//        }
//
//    }
//    
//    func btnDeleted(_ btnTag: Int) {
//            
//        let alertController = UIAlertController(title: "Alert", message: "Are you sure you want to delete this task?", preferredStyle: .alert)
//      let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.destructive) {
//            UIAlertAction in
//          self.deleteTaskAgainstId(ind: btnTag) { status in
//              if status {
//                  let dateFormatter = DateFormatter()
//                  dateFormatter.dateFormat = "MM/dd/yyyy"
//                  let dateString = dateFormatter.string(from: self.mySelectedDate)
//                  let da = dateFormatter.date(from: dateString)!
//                  self.getAllTasks(userId: Utilities().getCurrentUser().id ?? "", myDate: da)
//              }
//          }
//        }
//      let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
//            UIAlertAction in
//
//        }
//
//        // Add the actions
//        alertController.addAction(okAction)
//        alertController.addAction(cancelAction)
//
//      self.present(alertController, animated: true, completion: nil)
//
//    }
//
//}
