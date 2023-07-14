//
//  CreateTaskViewController.swift
//  ToDoApp
//
//  Created by mac on 11/04/2023.
//

import UIKit
import iOSDropDown
import Firebase
import FirebaseFirestore
import GoogleMobileAds


class CreateTaskViewController: BaseViewController {
    
    static var onCreateTask:((_ catName: String) -> Void)?
    static var onAddTaskTap:((Bool) -> Void)?
    @IBOutlet weak var titleTxtField: UITextField!
    @IBOutlet weak var detailTxtView: UITextView!
    @IBOutlet weak var catTxtField: DropDown!
//    @IBOutlet weak var lblCateName: UILabel! 
    @IBOutlet weak var dateTxtField: UITextField!
    @IBOutlet weak var timeTxtField: UITextField!
    @IBOutlet weak var endTimeTxtField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topTitleView: UIView!
    @IBOutlet weak var preReminderTxtField: DropDown!
    @IBOutlet weak var RepititionTxtField: DropDown!
    var scanTextAlert: UIAlertController?
    
    @IBOutlet weak var highBtn: UIButton!
    @IBOutlet weak var medBtn: UIButton!
    @IBOutlet weak var lowBtn: UIButton!
    
    @IBOutlet weak var highView: UIView!
    @IBOutlet weak var medView: UIView!
    @IBOutlet weak var lowView: UIView!
    
    var fromViewController = ""
    var datePicker = UIDatePicker()
    var myPickerView = UIPickerView()
    var toolBar = UIToolbar()
    private var selectionMode = ""
    private var selectedTime = ""
    private var date = ""
    var startTime:Date?
    var endTime:Date?
    private var priortyValue : String?
    fileprivate let maxLen = 250
    fileprivate let maxLen2 = 50
    fileprivate var preminderMin: Int = 0
    var caseNumber: Int!
    var selectedCategry:TaskCategory?
    var categories = [TaskCategory]()
    var categoryId = ""
    var CarColorCode = ""
    var priortyColor = "medium-text-color"
    var strCategories = [String]()
    var preReminderTime = ["5min","10min","15min","30min","One hour","One day before"]
    var preReminderText = ""
    var categoryText = ""
    var repitionText = ""
    var repitiotn = ["Only one time","Daily","Once in a week","Once in a month"]
    
    var preReminderSelect: Bool = false
    var catFieldSelect: Bool = false
    var repetitionSelect: Bool = false
    var taskDocumentID: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.myPickerView.delegate = self
        self.myPickerView.dataSource = self
        if detailTxtView.text! == "Description"{
            detailTxtView.textColor = UIColor(named: "LightDarkTextColor")
        }else{
            detailTxtView.textColor = UIColor(named: "textColor")
        }
    
        let dummyInputView = UIView(frame: CGRect.zero)
        self.catTxtField.inputView = dummyInputView

        self.preReminderTxtField.inputView = dummyInputView
        self.RepititionTxtField.inputView = dummyInputView
        self.dateTxtField.inputView = dummyInputView
        self.timeTxtField.inputView = dummyInputView
        self.endTimeTxtField.inputView = dummyInputView
        self.catTxtField.endEditing(true)
        self.catTxtField.resignFirstResponder()
       
        
        self.medView.layer.borderColor = UIColor(named: "medium-text-color")?.cgColor
        self.medView.layer.borderWidth = 0.8
    
        self.catTxtField.delegate = self
        self.preReminderTxtField.delegate = self
        self.RepititionTxtField.delegate = self
        self.dateTxtField.delegate = self
        self.timeTxtField.delegate = self
        self.endTimeTxtField.delegate = self
        self.titleTxtField.delegate = self
        detailTxtView.textContainer.lineFragmentPadding = 15
        self.detailTxtView.delegate = self
        
        // drop down settings
//        catTxtField.arrowColor = .lightGray
//        catTxtField.selectedRowColor = .white
//        catTxtField.itemsTintColor = .red
////        catTxtField.
//        catTxtField.arrowSize = 20
//        catTxtField.text = "Select Category"
        
        // drop down settings
//        preReminderTxtField.arrowColor = .lightGray
//        preReminderTxtField.selectedRowColor = .white
//        preReminderTxtField.itemsTintColor = .red
//        preReminderTxtField.arrowSize = 20
//        preReminderTxtField.text = "Select Pre Reminder"
        
        // drop down settings
//        RepititionTxtField.arrowColor = .lightGray
//        RepititionTxtField.selectedRowColor = .white
//        RepititionTxtField.itemsTintColor = .red
//        RepititionTxtField.arrowSize = 20
////        RepititionTxtField.text = "Select Repitition"
        
        catTxtField.tintColor = .clear
        preReminderTxtField.tintColor = .clear
        RepititionTxtField.tintColor = .clear
        dateTxtField.tintColor = .clear
        timeTxtField.tintColor = .clear
        endTimeTxtField.tintColor = .clear
//        RepititionTxtField.optionArray = self.repitiotn
//        preReminderTxtField.optionArray = self.preReminderTime
        
//        self.catTxtField.didSelect { selectedText, index, id in
//            self.categoryId = self.categories[index].id!
//            self.CarColorCode = self.categories[index].colorCode ?? ""
//            self.catTxtField.text = self.strCategories[index].description
//        }

//        preReminderTxtField.didSelect { selectedText, index, id in
//            if index == 0 {
//                self.preminderMin = 5
//            }else if index == 1{
//                self.preminderMin = 10
//            }else if index == 2{
//                self.preminderMin = 15
//            }else if index == 3{
//                self.preminderMin = 30
//            }else if index == 4{
//                self.preminderMin = 60
//            }else if index == 5{
//                self.preminderMin = 3600
//            }
//            self.preReminderTxtField.text = self.preReminderTime[index].description
//        }
//        var dateComponenets = DateComponents()
//        ["Once in a week","Daily","Once in a month","Only one time"]
//        RepititionTxtField.didSelect { selectedText, index, id in
//            if index == 0{
//                self.caseNumber = 0
//                self.frequency = NotificationFrequency.once
//            }else if index == 1{
//                self.caseNumber = 1
//                self.frequency = NotificationFrequency.daily
//            }else if index == 2{
//                self.caseNumber = 2
//                self.frequency = NotificationFrequency.weekly
//            }
//            else if index == 3{
//                self.caseNumber = 3
//                self.frequency = NotificationFrequency.monthly
//            }
//            print(id)
//            self.RepititionTxtField.text = self.repitiotn[index].description
//        }
        
//        Utilities.show_ProgressHud(view: self.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.tabBarController?.tabBar.backgroundColor = .red
        if self.selectedCategry != nil || self.fromViewController == "HomeVC" || self.fromViewController == "Add Task View"{
            self.topTitleView.isHidden = true
            self.setNavBar("Create New Task")
        } else {
            self.topTitleView.isHidden = false
        }
        
        self.catTxtField.text = selectedCategry?.name ?? ""
        self.CarColorCode = selectedCategry?.colorCode ?? ""
        self.scrollView.scrollsToTop = true
        self.scrollView.scrollToTop()
        self.datePicker.date = Date()
        self.getCategories(userId: Utilities().getCurrentUser().id ?? "")
    
    }
     
    
    func createDatePicker() {
        self.toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(btnDoneAction))
        self.toolBar.setItems([doneButton], animated: true)
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        
        dateTxtField.inputView = datePicker
        timeTxtField.inputView = datePicker
        endTimeTxtField.inputView = datePicker
    }
    
    func simplePickerView() {
        self.selectionMode = "pickerView"
        self.catTxtField.inputAccessoryView = toolBar
        self.catTxtField.inputView = self.myPickerView
        
        self.preReminderTxtField.inputAccessoryView = toolBar
        self.preReminderTxtField.inputView = self.myPickerView
        
        self.RepititionTxtField.inputAccessoryView = toolBar
        self.RepititionTxtField.inputView = self.myPickerView

        self.toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(btnDoneAction))
        self.toolBar.setItems([doneButton], animated: true)
        
        let selectedRow = 2 // Index of the row you want to select
        let selectedComponent = 0 // Index of the component you want to select the row in
        myPickerView.selectRow(selectedRow, inComponent: selectedComponent, animated: false)
        self.myPickerView.reloadAllComponents()

    }
    
    func datePickerTap() {
        self.createDatePicker()
        self.selectionMode = "Date"
        self.datePicker.minimumDate = Date()
        dateTxtField.inputAccessoryView = toolBar
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        
    }
    
    func timePickerTap() {
        self.createDatePicker()
//        self.selectionMode = "Time"
        timeTxtField.inputAccessoryView = toolBar
        endTimeTxtField.inputAccessoryView = toolBar
        datePicker.datePickerMode = .time
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .minute, value: 1, to: Date())
//        var todayDate = Date()
//        todayDate = todayDate.addingTimeInterval(60*10)
        datePicker.minimumDate = date
        
    }

    
    @objc func btnDoneAction(_ sender: UIButton)
    {

        if(self.selectionMode == "Date")
        {
            self.view.endEditing(true)
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
//            self.txtFieldDate.text = formatter.string(from: self.datePicker.date)
//            self.dateSelected = true
            self.date = formatter.string(from: self.datePicker.date)
            self.dateTxtField.text = self.date
         
        } else if self.selectionMode == "endTime" {
            self.view.endEditing(true)
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a"
//            self.txtTitle.text = (formatter.string(from: self.datePicker.date))
//            self.timeSelected = true
            
            self.endTimeTxtField.text =  formatter.string(from: self.datePicker.date)
            self.endTime = formatter.date(from: self.endTimeTxtField.text!)
        }
        if(self.selectionMode == "Time")
        {
            self.view.endEditing(true)
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a"
//            self.txtTitle.text = (formatter.string(from: self.datePicker.date))
//            self.timeSelected = true
            self.selectedTime = formatter.string(from: self.datePicker.date)
            self.timeTxtField.text =  self.selectedTime
            self.startTime = formatter.date(from:  self.timeTxtField.text!)
        } else {
            if self.catFieldSelect {
                if self.CarColorCode == "" {
                    self.CarColorCode = self.categories[2].colorCode!
                }
                self.catTxtField.text = self.categoryText
            } else if self.preReminderSelect {
                if self.preminderMin == 0 {
                    self.preminderMin = 15
                }
                self.preReminderTxtField.text = self.preReminderText
            } else if self.repetitionSelect {
                self.RepititionTxtField.text = self.repitionText
            }
            
//            self.RepititionTxtField.text = self.pre
            self.self.view.endEditing(true)
        }
//        self.imgBlur.isHidden = true
    }
    
    func isEndTimeValid(startTime: Date, endTime: Date) -> Bool {
        let calendar = Calendar.current

        // Compare the start and end times
        let comparisonResult = calendar.compare(startTime, to: endTime, toGranularity: .minute)

        // Check if the end time is greater than the start time
        if comparisonResult == .orderedAscending {
            return true
        } else {
            return false
        }
    }
    
    @IBAction func priortyAction(_ sender: UIButton) {
        
    }
    
    @IBAction func openPickerAction(_ sender: UIButton) {
        self.myPickerView.selectedRow(inComponent: 2)
        self.simplePickerView()
    }
    
    @IBAction func highPriortyAction(_ sender: UIButton) {
        
        self.highView.layer.borderColor = UIColor(named: "high-text-color")?.cgColor
        self.highView.layer.borderWidth = 0.8
        self.medView.layer.borderColor = UIColor(named: "medium-color")?.cgColor
        self.medView.layer.borderWidth = 0.0
        self.lowView.layer.borderColor = UIColor(named: "low-colorP")?.cgColor
        self.lowView.layer.borderWidth = 0.0
        self.priortyColor = "high-text-color"
        self.priortyValue = "High"
        
    }
    
    @IBAction func medPriortyAction(_ sender: UIButton) {
        
        self.highView.layer.borderColor = UIColor(named: "high-color")?.cgColor
        self.highView.layer.borderWidth = 0.0
        self.medView.layer.borderColor = UIColor(named: "medium-text-color")?.cgColor
        self.medView.layer.borderWidth = 0.8
        self.lowView.layer.borderColor = UIColor(named: "low-colorP")?.cgColor
        self.lowView.layer.borderWidth = 0.0
        self.priortyColor = "medium-text-color"
        self.priortyValue = "Medium"
    }
    
    @IBAction func lowPriortyAction(_ sender: UIButton) {
        
        self.highView.layer.borderColor = UIColor(named: "high-color")?.cgColor
        self.highView.layer.borderWidth = 0.0
        self.medView.layer.borderColor = UIColor(named: "medium-color")?.cgColor
        self.medView.layer.borderWidth = 0.0
        self.lowView.layer.borderColor = UIColor(named: "low-text-color-1")?.cgColor
        self.lowView.layer.borderWidth = 1.0
        self.priortyColor = "low-text-color-1"
        self.priortyValue = "Low"
    }

    
    @IBAction func createTaskAction(_ sender: UIButton) {
        
        self.createTask()
        
        
    }
    @IBAction func CreateCateGoryActon(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addCatVC = storyboard.instantiateViewController(identifier: "AddCategoryViewController") as! AddCategoryViewController
//        searchTaskVC.mySelectedCategory = categoryName
        addCatVC.allCategories = categories
        addCatVC.fromEditOrUpdate = "Create Category"
//        addCatVC.fromViewController = "searchTaskViewController"
        self.navigationController?.pushViewController(addCatVC, animated: true)
    }
    @IBAction func pickerDoneAction(_ sender: UIButton) {
        
    }
    
    private func validate() -> Bool
    {
        if(self.titleTxtField.text?.count ?? 0 < 1 || self.titleTxtField.text == "Title")
        {
            self.showAlert(title: "Alert", message: "Please enter title")
            return false
        }
        if(self.detailTxtView.text?.count ?? 0 < 1 || self.detailTxtView.text == "Description")
        {
            self.showAlert(title: "Alert", message:"Please enter description")
            return false
        }
        if(self.catTxtField.text?.count ?? 0 < 1)
        {
            self.showAlert(title: "Alert", message:"Please enter Category")
            return false
        }
        if(dateTxtField.text!.count < 1)
        {
            self.showAlert(title: "Alert", message:"Please select date")
            return false
        }
        
        if(timeTxtField.text!.count < 1)
        {
            self.showAlert(title: "Alert", message:"Please select time")
            return false
        }
        
        let valideTime = self.isEndTimeValid(startTime: self.startTime!, endTime: self.endTime!)
        if valideTime == false {
            self.showAlert(title: "Alert", message:"End time must be greater than your choose time")
            return false
        }
        
        return true
    }
    
    func saveDataOnCreateTask(_ documentId: String) {
        
        let db = Firestore.firestore()
        let ref = db.collection("tasks").document()
        ref.setData([
            "id": documentId,
           "title": self.titleTxtField.text!,
           "userId": Utilities().getCurrentUser().id  ?? "",
            "categoryId": self.categoryId,
            "categoryName": self.catTxtField.text!,
           "description": self.detailTxtView.text!,
           "date":self.date + " " + self.selectedTime,
           "time":self.date,
           "endTime":self.endTimeTxtField.text ?? "",
           "priority": self.priortyValue ?? "Medium",
           "preReminder":self.preReminderTxtField.text ?? "None",
           "repetition": self.RepititionTxtField.text ?? "None",
            "colorCode": self.CarColorCode,
            "priorityColorCode":self.priortyColor
        ]) { err in
            if let err = err {
                Utilities.hide_ProgressHud(view: self.view)
                cAlert.ShowToastWithHandler(VC: self, msg: "Error writing document: (\(err)") { sucess in
                    _ = self.tabBarController?.selectedIndex = 0
                }

            } else {
                Utilities.hide_ProgressHud(view: self.view)
                cAlert.ShowToastWithHandler(VC: self, msg: "Task created successfully") { sucess in
                    
                    if self.fromViewController == "CategoryVC" ||  self.fromViewController == "HomeVC" {
                        self.navigationController?.popViewController(animated: true)
                        CreateTaskViewController.onCreateTask?(self.catTxtField.text!)
                        
                    } else if self.fromViewController == "Add Task View"{
                        self.navigationController?.popViewController(animated: true)
                        CreateTaskViewController.onAddTaskTap?(true)
                    } else {
                        _ = self.tabBarController?.selectedIndex = 0
                    }
                    self.titleTxtField.text = ""
                    self.detailTxtView.text = "Description"
                    self.catTxtField.text = ""
                    self.dateTxtField.text = ""
                    self.timeTxtField.text = ""
                    self.preReminderTxtField.text = ""
                    self.RepititionTxtField.text = ""
                }

            }
        }
    }
    
    func createTask() {
        
        if(validate())
        {
            guard Utilities.Connectivity.isConnectedToInternet else {
                self.showAlert(title: "Error", message: "Please check your internet connection")
                    return
            }
//                Utilities.show_ProgressHud(view: self.view)
            
            let db = Firestore.firestore()
            let ref = db.collection("tasks").document()
            self.taskDocumentID = ref.documentID
            if self.selectedTime != "" && self.date != "" {

                let mDate = self.date + " " + self.selectedTime
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy h:mm a"
                let newDate = dateFormatter.date(from: mDate)

                if validate() && self.RepititionTxtField.text?.isEmpty == true && self.preReminderTxtField.text?.isEmpty == true {
                    // do simple notification
//                    self.createNotificationReminder(newDate: newDate!)
                    self.saveDataOnCreateTask(self.taskDocumentID)
                    self.createNotificationReminder(newDate: newDate!, catId: self.categoryId, taskId: self.taskDocumentID)
                    
                } else if validate() && self.preReminderTxtField.text?.isEmpty == false && self.RepititionTxtField.text?.isEmpty == true {
                    
                    self.checkCurrentTime(self.preminderMin) { status in
                        if status {
                            self.saveDataOnCreateTask(self.taskDocumentID)
                            self.createPrereminderforNotification(beforeTime: self.preminderMin, newDate: newDate!, taskId: self.taskDocumentID, catId: self.categoryId)
                            
                            
                        } else {
                            self.showAlert(title: "Error", message: "Pre Reminder time should be greater than current time")
                        }
                    }
                   

                 }  else if validate() && self.preReminderTxtField.text?.isEmpty == false && self.RepititionTxtField.text?.isEmpty == false {
                    //do something
                     self.checkCurrentTime(self.preminderMin) { status in
                         if status {
                             self.saveDataOnCreateTask(self.taskDocumentID)
                             self.notifiPreAndRep(myDate: newDate!, beforetim: self.preminderMin, taskId: self.taskDocumentID)
                         } else {
                             self.showAlert(title: "Error", message: "Pre Reminder time should be greater than current time")
                         }
                     }
                     
                    
                     
                }  else if validate() && self.RepititionTxtField.text?.isEmpty == false && self.preReminderTxtField.text?.isEmpty == true {
                    self.saveDataOnCreateTask(self.taskDocumentID)
                    self.fireNotification(myDate: newDate!, taskId: self.taskDocumentID)
                }

            }
            
        
        }
    }
    
    func getCategories (userId:String) {
        guard Utilities.Connectivity.isConnectedToInternet else {
            self.showAlert(title: "Error", message: "Please check your internet connection")
                return
        }
            let db = Firestore.firestore()
            db.collection("category").whereField("userId", isEqualTo: userId)
                .getDocuments() { (querySnapshot, err) in
                    if err != nil {
                        print("Error getting documents: (err)")
                        Utilities.hide_ProgressHud(view: self.view)
                    } else {
                        self.categories.removeAll()
                        for document in querySnapshot!.documents {
                            let dicCat = document.data()
                            let objCat = TaskCategory.init(fromDictionary: dicCat)
                            self.categories.append(objCat)
                        }
                        self.strCategories.removeAll()
                        for cat in self.categories {
                            self.strCategories.append(cat.name!)
                        }
//                        self.catTxtField.optionArray = self.strCategories
                        Utilities.hide_ProgressHud(view: self.view)
                    }
                    
            }
        }
    
    func createNotificationReminder(newDate:Date,catId : String,taskId:String){
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = self.titleTxtField.text!
        content.body = self.detailTxtView.text!
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "alarm-2.wav"))
        content.categoryIdentifier = categoryId

        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: newDate)
    
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
    
        let uniqueID = taskId// Keep a record of this if necessary
        let request = UNNotificationRequest(identifier: uniqueID, content: content, trigger: trigger)
        center.add(request) { (error) in
            
        if let error = error {
                print("Failed to schedule alarm notification: \(error.localizedDescription)")
            } else {
                print("Alarm notification scheduled successfully")
            }
        }
    }
    func createPrereminderforNotification(beforeTime : Int, newDate : Date,taskId : String,catId : String){
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = self.titleTxtField.text!
        content.body = "\(beforeTime) before alarm"
        
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "alarm-2.wav"))
        content.categoryIdentifier = categoryId

        let preReminderDate = Calendar.current.date(byAdding: .minute, value: -beforeTime, to: newDate) // 5 minutes before event
       
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: preReminderDate!)
    
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
    
        let uniqueID = taskId// Keep a record of this if necessary
        let request = UNNotificationRequest(identifier: uniqueID, content: content, trigger: trigger)
        center.add(request) { (error) in
            
        if let error = error {
                print("Failed to schedule alarm notification: \(error.localizedDescription)")
            } else {
                print("Alarm notification scheduled successfully")
            }
        }
    }

    var frequency = NotificationFrequency.weekly
    func fireNotification(myDate : Date,taskId:String) {
        
//        let date = Date() // Replace with your desired date
        let calendar = Calendar.current

        print("Day number: (dayNumber)")
        
        // Create a date components object for the desired trigger date and time
        var dateComponents = DateComponents()
//        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = self.titleTxtField.text!
        content.body = self.detailTxtView.text!
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "alarm-2.wav"))
        dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: myDate)
                switch caseNumber {
                case 0: // No repeat
                   
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                    scheduleNotification(with: trigger, content: content, taskId: taskId)
                    break
                case 1: // Daily repeat
                    dateComponents.hour = dateComponents.hour! // Example hour, change it to your desired hour
                    dateComponents.minute = dateComponents.minute!
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                    // Create a notification request
                    content.subtitle = "Daily"
                    scheduleNotification(with: trigger, content: content, taskId: taskId)
                case 2: // Weekly repeat
                    
//                    let selectedDate = Date() // Replace with your selected date
                    let calendar = Calendar.current
                    let dayNumber = calendar.component(.weekday, from: myDate)
//
//                    print("Day number: \(dayNumber)")
//
//                    let dateComponents = DateComponents(hour: 5, minute: 36, weekday: dayNumber-1) // 10:00 AM every Tuesday
//                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                    
                    var dateComponents1 = DateComponents()
                    dateComponents1.calendar = Calendar.current
                    
                    dateComponents1.weekday = dayNumber
                    dateComponents1.hour = dateComponents.hour!
                    dateComponents1.minute = dateComponents.minute!

                    // Create the trigger as a repeating event.
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents1, repeats: true)
//                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 604800, repeats: true)
                    
//                    let triggerDate = calendar.date(byAdding: .weekday, value: 1, to: myDate)!
//                   let dateComponents1 = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate)
//                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents1, repeats: true)
                    content.subtitle = "Weekly"
                    scheduleNotification(with: trigger, content: content, taskId: taskId)
                case 3: // Monthly repeat
                    var components = DateComponents()
                    components.day = dateComponents.day! // Example date, change it to your desired date
                    components.hour = dateComponents.hour!
                    components.minute = dateComponents.minute!
                    let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                    content.subtitle = "Monthly"
                    scheduleNotification(with: trigger, content: content, taskId: taskId)
                default: // No repeat
                    break
            }
    
    }
    
    func notifiPreAndRep(myDate : Date, beforetim: Int,taskId:String) {
        
//        let date = Date() // Replace with your desired date
        let calendar = Calendar.current
        
        
        
        // Create a date components object for the desired trigger date and time
        var dateComponents = DateComponents()
//        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = self.titleTxtField.text!
        content.body = self.detailTxtView.text!
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "alarm-2.wav"))
        // some minutes before event
        let preReminderDate = Calendar.current.date(byAdding: .minute, value: -beforetim, to: myDate)
        dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: preReminderDate!)
        
                switch caseNumber {
                case 0: // No repeat
                    
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                    scheduleNotification(with: trigger, content: content, taskId: taskId)
                    break
                case 1: // Daily repeat
                    dateComponents.hour = dateComponents.hour! // Example hour, change it to your desired hour
                    dateComponents.minute = dateComponents.minute!
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                    // Create a notification request
                    content.subtitle = "Daily Reminder"
                    scheduleNotification(with: trigger, content: content, taskId: taskId)
                case 2: // Weekly repeat
                    
                    let selectedDate = Date() // Replace with your selected date
                        let calendar = Calendar.current
                        let dayNumber = calendar.component(.weekday, from: myDate)
                        var dateComponents1 = DateComponents()
                        dateComponents1.calendar = Calendar.current
                        dateComponents1.weekday = dayNumber
                        dateComponents1.hour = dateComponents.hour!
                        dateComponents1.minute = dateComponents.minute!
                    
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents1, repeats: true)
                    content.subtitle = "Weekly Reminder"
                    scheduleNotification(with: trigger, content: content, taskId: taskId)
                case 3: // Monthly repeat
                    var components = DateComponents()
                    components.day = dateComponents.day! // Example date, change it to your desired date
                    components.hour = dateComponents.hour!
                    components.minute = dateComponents.minute!
                    let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                    content.subtitle = "Monthly Reminder"
                    scheduleNotification(with: trigger, content: content, taskId: taskId)
                default: // No repeat
                    break
                }
        

    }
    
    
    func scheduleNotification(with trigger: UNNotificationTrigger, content: UNMutableNotificationContent,taskId : String) {
           // Create notification request
           let request = UNNotificationRequest(identifier: taskId, content: content, trigger: trigger)

           // Add the notification request to the notification center
           UNUserNotificationCenter.current().add(request) { (error) in
               if let error = error {
                   print("Error scheduling notification: \(error.localizedDescription)")
               } else {
                   print("Notification scheduled successfully.")
               }
           }
       }
    
    
    
    func checkCurrentTime(_ myTimeBefore: Int, completion: @escaping (_ status : Bool) -> Void){

        let compDate = self.date + " " + self.selectedTime
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy h:mm a"
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale.current//(identifier: "fr")
        let selectedDateTime = dateFormatter.date(from: compDate)
        let now = Date().localDate()
        let nowDatestr = dateFormatter.string(from: now)
        let nowDate = dateFormatter.date(from: nowDatestr)!
        let birthday: Date = selectedDateTime!
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.minute], from: nowDate, to: birthday)
        let age = ageComponents.minute!
        print(age)
        
        if age < myTimeBefore{
            completion(false)
        }else{
            completion(true)
        }
        
//        // calculate the time intervals for each reminder
//        let fiveMinutesBefore = TimeInterval(myTimeBefore * 60)
//        // create date components for each reminder
//        let fiveMinutesBeforeDate = Calendar.current.date(byAdding: .second, value: Int(fiveMinutesBefore), to: selectedDateTime!)!
//        if selectedDateTime! > fiveMinutesBeforeDate {
//            print("Selected time is greater than \(myTimeBefore) minutes")
//            completion(true)
//        } else {
//            print("Selected time is not greater than \(myTimeBefore) minutes")
//            completion(false)
//        }
    }
}

extension CreateTaskViewController: UIPickerViewDelegate,UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if self.catFieldSelect {
            return self.strCategories.count
        } else if self.preReminderSelect {
            return preReminderTime.count
        } else {
            return repitiotn.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            if self.catFieldSelect {
                self.categoryText = self.strCategories[row]
                return self.strCategories[row]
            } else if self.preReminderSelect {
                self.preReminderText = self.preReminderTime[row]
                return preReminderTime[row]
            } else  {
                self.repitionText = self.repitiotn[row]
                return self.repitiotn[row]
            }

    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if self.catFieldSelect {
            self.catTxtField.text = self.strCategories[row]
            self.categoryId = self.categories[row].id!
            self.CarColorCode = self.categories[row].colorCode ?? ""
        } else if self.preReminderSelect {
            self.preReminderTxtField.text = self.preReminderTime[row]
            if row == 0 {
                self.preminderMin = 5
            }else if row == 1{
                self.preminderMin = 10
            }else if row == 2{
                self.preminderMin = 15
            }else if row == 3{
                self.preminderMin = 30
            }else if row == 4{
                self.preminderMin = 60
            }else if row == 5{
                self.preminderMin = 3600
            }
        } else  {
            if row == 0{
                self.caseNumber = 0
                self.frequency = NotificationFrequency.once
            }else if row == 1{
                self.caseNumber = 1
                self.frequency = NotificationFrequency.daily
            }else if row == 2{
                self.caseNumber = 2
                self.frequency = NotificationFrequency.weekly
            }
            else if row == 3{
                self.caseNumber = 3
                self.frequency = NotificationFrequency.monthly
            }
            self.RepititionTxtField.text = self.repitiotn[row]
        }
        
        
    }

}


extension CreateTaskViewController: UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.RepititionTxtField {
            self.preReminderSelect = false
            self.catFieldSelect = false
            self.repetitionSelect = true
            self.simplePickerView()
        }
        else if textField == self.preReminderTxtField {
            self.preReminderSelect = true
            self.catFieldSelect = false
            self.repetitionSelect = false
            self.simplePickerView()
        }
         if textField == self.catTxtField {
            //picker view
             self.catFieldSelect = true
             self.preReminderSelect = false
             self.repetitionSelect = false
             self.simplePickerView()
    
        }
         else if textField == self.dateTxtField {
//            self.txtFieldDate.text = ""
            self.datePickerTap()
        }
        else if textField == self.timeTxtField  {
//            self.txtFieldTime.text = ""
            self.timePickerTap()
            self.selectionMode = "Time"
        } else if textField == self.endTimeTxtField {
            self.timePickerTap()
            self.selectionMode = "endTime"
        }
        
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           // Get the current text in the text field
        if let textField = self.titleTxtField.text {
               // Calculate the length of the resulting text after the change
               let newLength = textField.count + string.count
               
               // Limit the text field to a maximum of 50 characters
               if newLength <= 50 {
                   // Allow only characters (letters and spaces)
                   if string == " "{
                       return true
                   }
                   let allowedCharacters = CharacterSet.letters
                   let characterSet = CharacterSet(charactersIn: string)
                   return allowedCharacters.isSuperset(of: characterSet)
               } else {
                   // If the resulting text will exceed the maximum length, reject the change
                   return false
               }
           }
           return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.titleTxtField {
            self.titleTxtField.resignFirstResponder()
            self.detailTxtView.becomeFirstResponder()
        }
        else if textField == self.detailTxtView {
            self.detailTxtView.resignFirstResponder()
        } else if textField == self.dateTxtField || textField == self.timeTxtField || textField == preReminderTxtField || textField == RepititionTxtField || textField == catTxtField {
            self.catTxtField.resignFirstResponder()
            self.dateTxtField.resignFirstResponder()
            self.timeTxtField.resignFirstResponder()
            self.preReminderTxtField.resignFirstResponder()
            self.RepititionTxtField.resignFirstResponder()
        }
        return true
    }
    
}


extension CreateTaskViewController: UITextViewDelegate
{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if(textView == self.detailTxtView)
        {
            if(textView.text == "Description")
            {
                textView.textColor = UIColor(named: "LightDarkTextColor")
                textView.text = ""
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if(textView == self.detailTxtView)
        {
            if(textView.text == "")
            {
                textView.textColor = UIColor(named: "LightDarkTextColor")
                textView.text = "Description"
            } else {
                detailTxtView.resignFirstResponder()
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" { // Check for "Done" button press
            self.detailTxtView.resignFirstResponder() // Hide the keyboard
                  return false
        }
        
        let disallowedCharacterSet = CharacterSet(charactersIn: "0123456789")
              if let _ = text.rangeOfCharacter(from: disallowedCharacterSet) {
                  return false
        }
        
        let newLen = (textView.text.count - range.length) + text.count
        return newLen <= maxLen
    }
}


class cAlert{
    class func Showalert(VC:UIViewController,msg:String,title:String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert); VC.present(alert, animated: true) {
            var i = 1
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { (Timer) in
                if i == 3{
                    Timer.invalidate()
                    alert.dismiss(animated: true, completion: nil)
                }else{
                    i += 1
                } }
        } }
    class func ShowAlerTost(VC:UIViewController,title:String,msg:String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert); VC.present(alert, animated: true) {
            var i = 1
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { (Timer) in
                if i == 3{
                    Timer.invalidate()
                    alert.dismiss(animated: true, completion: nil)
                }else{
                    i += 1
                } }
        } }
    class func showAlertWithOkBtn(VC:UIViewController,msg:String) { let alertController = UIAlertController(title: msg, message: "",
                                                                                                            preferredStyle: .alert)
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            print("OK Pressed") }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in print("Cancel Pressed")
        }
        alertController.addAction(okAction); alertController.addAction(cancelAction)
        // Present the controller
        VC.present(alertController, animated: true, completion: nil)
    }
    class func ShowToast(VC:UIViewController,msg:String){
        let alert = UIAlertController(title: msg, message: "", preferredStyle: .alert); VC.present(alert, animated: true) {
            var i = 1
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { (Timer) in
                if i == 3{
                    Timer.invalidate()
                    alert.dismiss(animated: true, completion: nil)
                }else{
                    i += 1
                } }
        } }
    class func ShowToastWithHandler(VC:UIViewController,msg:String,completionHandler:@escaping(_ status : Bool)-> Void){
        let alert = UIAlertController(title: msg, message: "", preferredStyle: .alert); VC.present(alert, animated: true) {
            var i = 1
            Timer.scheduledTimer(withTimeInterval: 0.6, repeats: true) { (Timer) in
                if i == 3{
                    Timer.invalidate()
                    alert.dismiss(animated: true, completion: nil)
                    completionHandler(true)
                }else{
                    i += 1
                } }
        } }
    class func ShowBoldToast(VC:UIViewController,msg:String){
        let alert = UIAlertController(title: msg, message: "", preferredStyle: .alert)
        VC.present(alert, animated: true) {
            var i = 1
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { (Timer) in
                //
                if i == 3{
                    
                    Timer.invalidate()
                    alert.dismiss(animated: true, completion: nil) }else{
                        i += 1 }
            } }
    }
    
}



enum NotificationFrequency {
    case once, daily, weekly, monthly
}

extension Date {
    func localDate() -> Date {
        let nowUTC = Date()
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: nowUTC))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: nowUTC) else {return Date()}

        return localDate
    }
}
extension UIScrollView {
    func scrollToTop() {
        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(desiredOffset, animated: true)
   }
}



class NonEditableTextField: UITextField {
    override var canBecomeFirstResponder: Bool {
        return false
    }
}
