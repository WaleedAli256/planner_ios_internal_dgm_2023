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
    @IBOutlet weak var calendar: FSCalendar!
    var selectedIndex = -1
    
    var arrAllTasks = [Task]()
    var selectedDate = ""
    var filterArray = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.CalendarSelected(notification:)), name: Notification.Name("CalendarSelected"), object: nil)
        
        tblView.register(UINib(nibName: "TaskCell", bundle: nil), forCellReuseIdentifier: "TaskCell")
//
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy h:mm a"
        let dateString = dateFormatter.string(from: currentDate)
        self.selectedDate = dateString
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "MMMM yyyy"
        let dateStringr = dateFormatter2.string(from: currentDate)
        self.lblMonthName.text = dateStringr
        self.selectedDate = dateString
        calendar.select(Date())
        self.calendar.delegate = self
        self.calendar.dataSource = self
        self.tblView.delegate = self
        self.tblView.dataSource = self

//        self.getTasksByDate(date: selectedDate)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getAllTasks(userId: Utilities().getCurrentUser().id ?? "")
        self.tblView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.tblView.removeObserver(self, forKeyPath: "contentSize")
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
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
    
    func getAllTasks(userId:String) {
        Utilities.show_ProgressHud(view: self.view)
        self.arrAllTasks.removeAll()
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
//                        self.selectedDayTasks = []
                    }
                    
//                    self.getTasks()
                    Utilities.hide_ProgressHud(view: self.view)
//                    self.tblView.reloadData()
                    self.calendar.reloadData()
                    
                }
            }
    }
    
    @objc func CalendarSelected(notification: Notification) {
        self.getAllTasks(userId: Utilities().getCurrentUser().id ?? "")
    }
    
//        }
//        Utilities.show_ProgressHud(view: self.view)
    {
        guard Utilities.Connectivity.isConnectedToInternet  else {
            self.showAlert(title: "Network Error", message: "Please check your internet connection")
            return
        }
        Utilities.show_ProgressHud(view: self.view)
//        self.arrTasks.removeAll()
        let db = Firestore.firestore()
        db.collection("tasks").whereField("userId", isEqualTo: Utilities().getCurrentUser().id ?? "").whereField("date", isEqualTo: self.selectedDate).getDocuments(completion: {(snapshot,error) in
            if let err = error
            {
                Utilities.hide_ProgressHud(view: self.view)
                self.showAlert(title: "Error" , message: "\(err)")
//                Utilities.showAlert("\(err)", subtitle: "",type: .danger)
//                print("Error getting documents: \(err)")
            }
            else
            {
                Utilities.hide_ProgressHud(view: self.view)
                for doc in snapshot!.documents
                {
                    let dictask = doc.data()
                    let dateObj = dictask["date"] as! String
                    if self.selectedDate == dateObj {
                        print(self.selectedDate)
                        let objTask = Task.init(fromDictionary: dictask)
                        self.arrAllTasks.append(objTask)
                    }
                }
//                self.lblTaskNumber.text = "Tasks (\(self.arrTasks.count))"
                self.calendar.reloadData()
                self.tblView.reloadData()
            }
        })
    }
    
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
}

extension CalendarViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filterArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tblView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        let obj = self.filterArray[indexPath.row]
        let originalDateFormat = "MM/dd/yyyy h:mm a"
        let desiredDateFormat = "EE,d MMM h:mm a"
        let originalDateString = obj.date

        if let formattedDate = Utilities.changeDateFormat(fromFormat: originalDateFormat, toFormat: desiredDateFormat, dateString: originalDateString!) {
            print("Formatted Date: \(formattedDate)")
            cell.lblTimeDate.text = formattedDate
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
        self.calendar.appearance.todayColor = .clear
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
           // Get the number of tasks that occur on the specified date
            let myDateStr = convertDateFormate(date)
            let matchingTasks = arrAllTasks.filter ({$0.time == myDateStr})
            self.filterArray = matchingTasks
            self.tblView.reloadData()
            return matchingTasks.count
    }
    
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
//        var dateArray = [String]()
//        for dateObj in self.filterArray {
//            dateArray.append(dateObj.time!)
//        }
//        let myDateStr = convertDateFormate(date)
//        if dateArray.contains(myDateStr) {
//            return .blue
//        } else {
//            return nil
//        }
//    }
    
    
    func convertDateFormate(_ dateis: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let newDateString = formatter.string(from: dateis)
        return newDateString
        
    }
}

