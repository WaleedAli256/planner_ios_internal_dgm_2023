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


class CreateTaskViewController: BaseViewController {
    
    @IBOutlet weak var titleTxtField: UITextField!
    @IBOutlet weak var detailTxtView: UITextView!
    @IBOutlet weak var catTxtField: DropDown!
    @IBOutlet weak var dateTxtField: UITextField!
    @IBOutlet weak var timeTxtField: UITextField!
    @IBOutlet weak var preReminderTxtField: DropDown!
    @IBOutlet weak var RepititionTxtField: DropDown!
    
    @IBOutlet weak var highBtn: UIButton!
    @IBOutlet weak var medBtn: UIButton!
    @IBOutlet weak var lowBtn: UIButton!
    
    @IBOutlet weak var highView: UIView!
    @IBOutlet weak var medView: UIView!
    @IBOutlet weak var lowView: UIView!
    
    var datePicker = UIDatePicker()
    var toolBar = UIToolbar()
    private var selectionMode = ""
    private var selectedTime = ""
    private var date = ""
    private var priortyValue : String?
    fileprivate let maxLen = 250
    fileprivate let maxLen2 = 50
    fileprivate var preminderMin: Int = 0
    var caseNumber: Int!
    
    var categories = [TaskCategory]()
    var categoryId = ""
    var strCategories = [String]()
    var preReminderTime = ["5min","10min","15min","30min","One hour","One day before"]
    var preReminderText = ""
    var repitiotn = ["Once in a week","Daily","Once in a month","Only one time"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dummyInputView = UIView(frame: CGRect.zero)
        self.catTxtField.inputView = dummyInputView
        self.preReminderTxtField.inputView = dummyInputView
        self.RepititionTxtField.inputView = dummyInputView
        self.dateTxtField.inputView = dummyInputView
        self.timeTxtField.inputView = dummyInputView
        self.medView.layer.borderColor = UIColor(named: "medium-text-color")?.cgColor
        self.medView.layer.borderWidth = 0.8
    
        self.dateTxtField.delegate = self
        self.timeTxtField.delegate = self
        
        self.titleTxtField.delegate = self
        detailTxtView.textContainer.lineFragmentPadding = 15
        self.detailTxtView.delegate = self
        
        // drop down settings
        catTxtField.arrowColor = .lightGray
        catTxtField.selectedRowColor = .white
        catTxtField.itemsTintColor = .red
        catTxtField.arrowSize = 15
//        catTxtField.text = "Select Category"
        
        // drop down settings
        preReminderTxtField.arrowColor = .lightGray
        preReminderTxtField.selectedRowColor = .white
        preReminderTxtField.itemsTintColor = .red
        preReminderTxtField.arrowSize = 15
//        preReminderTxtField.text = "Select Pre Reminder"
        
        // drop down settings
        RepititionTxtField.arrowColor = .lightGray
        RepititionTxtField.selectedRowColor = .white
        RepititionTxtField.itemsTintColor = .red
        RepititionTxtField.arrowSize = 15
//        RepititionTxtField.text = "Select Repitition"
        
        catTxtField.tintColor = .clear
        preReminderTxtField.tintColor = .clear
        RepititionTxtField.tintColor = .clear
        dateTxtField.tintColor = .clear
        timeTxtField.tintColor = .clear
        
        RepititionTxtField.optionArray = self.repitiotn
        preReminderTxtField.optionArray = self.preReminderTime
        
        self.catTxtField.didSelect { selectedText, index, id in
            self.categoryId = self.categories[index].id!
            self.catTxtField.text = self.strCategories[index].description
        }

        preReminderTxtField.didSelect { selectedText, index, id in
            
            if index == 0 {
                self.preminderMin = 5
            }else if index == 1{
                self.preminderMin = 10
            }else if index == 2{
                self.preminderMin = 15
            }else if index == 3{
                self.preminderMin = 30
            }else if index == 4{
                self.preminderMin = 60
            }else if index == 5{
                self.preminderMin = 3600
            }
            self.preReminderTxtField.text = self.preReminderTime[index].description
        }
        var dateComponenets = DateComponents()
//        ["Once in a week","Daily","Once in a month","Only one time"]
        RepititionTxtField.didSelect { selectedText, index, id in
            if index == 0{
                self.caseNumber = 0
                self.frequency = NotificationFrequency.once
            }else if index == 1{
                self.caseNumber = 1
                self.frequency = NotificationFrequency.daily
            }else if index == 2{
                self.caseNumber = 2
                self.frequency = NotificationFrequency.weekly
            }
            else if index == 3{
                self.caseNumber = 3
                self.frequency = NotificationFrequency.monthly
            }
            print(id)
            self.RepititionTxtField.text = self.repitiotn[index].description
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        self.selectionMode = "Time"
        timeTxtField.inputAccessoryView = toolBar
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
           
              
        }
//        self.imgBlur.isHidden = true
    }
    
    @IBAction func priortyAction(_ sender: UIButton) {
        
        
    }
    
    @IBAction func highPriortyAction(_ sender: UIButton) {
        
        self.highView.layer.borderColor = UIColor(named: "high-text-color")?.cgColor
        self.highView.layer.borderWidth = 0.8
        self.medView.layer.borderColor = UIColor(named: "medium-color")?.cgColor
        self.medView.layer.borderWidth = 0.0
        self.lowView.layer.borderColor = UIColor(named: "low-colorP")?.cgColor
        self.lowView.layer.borderWidth = 0.0
        self.priortyValue = "high"
    }
    
    @IBAction func medPriortyAction(_ sender: UIButton) {
        
        self.highView.layer.borderColor = UIColor(named: "high-color")?.cgColor
        self.highView.layer.borderWidth = 0.0
        self.medView.layer.borderColor = UIColor(named: "medium-text-color")?.cgColor
        self.medView.layer.borderWidth = 0.8
        self.lowView.layer.borderColor = UIColor(named: "low-colorP")?.cgColor
        self.lowView.layer.borderWidth = 0.0
        self.priortyValue = "medium"
    }
    
    @IBAction func lowPriortyAction(_ sender: UIButton) {
        
        self.highView.layer.borderColor = UIColor(named: "high-color")?.cgColor
        self.highView.layer.borderWidth = 0.0
        self.medView.layer.borderColor = UIColor(named: "medium-color")?.cgColor
        self.medView.layer.borderWidth = 0.0
        self.lowView.layer.borderColor = UIColor(named: "low-text-color-1")?.cgColor
        self.lowView.layer.borderWidth = 1.0
        self.priortyValue = "low"
    }

    
    @IBAction func createTaskAction(_ sender: UIButton) {
        
        self.createTask()
    }
    
    private func validate() -> Bool
    {
        if(self.titleTxtField.text?.count ?? 0 < 1 || self.titleTxtField.text == "Title")
        {
            self.showAlert(title: "Error", message: "Please enter title")
            return false
        }
        if(self.detailTxtView.text?.count ?? 0 < 1 || self.detailTxtView.text == "Description")
        {
            self.showAlert(title: "Error", message:"Please enter description")
            return false
        }
        if(self.catTxtField.text?.count ?? 0 < 1)
        {
            self.showAlert(title: "Error", message:"Please enter Category")
            return false
        }
        if(dateTxtField.text!.count < 1)
        {
            self.showAlert(title: "Error", message:"Please select date")
            return false
        }
        
        if(timeTxtField.text!.count < 1)
        {
            self.showAlert(title: "Error", message:"Please select time")
            return false
        }
        
        return true
    }
    func createNotificationReminder(newDate:Date){
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = self.titleTxtField.text!
        content.body = "Simple Notification"
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "234"

        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: newDate)
    
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
    
        let uniqueID = "234"// Keep a record of this if necessary
        let request = UNNotificationRequest(identifier: uniqueID, content: content, trigger: trigger)
        center.add(request) { (error) in
            
        if let error = error {
                print("Failed to schedule alarm notification: \(error.localizedDescription)")
            } else {
                print("Alarm notification scheduled successfully")
            }
        }
    }
    func createPrereminderforNotification(beforeTime : Int, newDate : Date){
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = self.titleTxtField.text!
        content.body = "5 mints Remaining"
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "234"
        
//        let snoozeAction = UNNotificationAction(identifier: "Snooze",
//                                                title: "Snooze", options: [])
//        let deleteAction = UNNotificationAction(identifier: "UYLDeleteAction",
//                                                title: "Delete", options: [.destructive])
//
//        let category = UNNotificationCategory(identifier: "UYLReminderCategory",
//                                              actions: [snoozeAction,deleteAction],
//                                              intentIdentifiers: [], options: [])
//
//        center.setNotificationCategories([category])
    
        let preReminderDate = Calendar.current.date(byAdding: .minute, value: -beforeTime, to: newDate) // 5 minutes before event
       
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: preReminderDate!)
    
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
    
        let uniqueID = "234"// Keep a record of this if necessary
        let request = UNNotificationRequest(identifier: uniqueID, content: content, trigger: trigger)
        center.add(request) { (error) in
            
        if let error = error {
                print("Failed to schedule alarm notification: \(error.localizedDescription)")
            } else {
                print("Alarm notification scheduled successfully")
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
                Utilities.show_ProgressHud(view: self.view)
        
                let db = Firestore.firestore()
                let ref = db.collection("tasks").document()
                ref.setData([
                    "id": ref.documentID,
                   "title": self.titleTxtField.text!,
                   "userId": Utilities().getCurrentUser().id  ?? "",
                    "categoryId": self.categoryId,
                    "categoryName": self.catTxtField.text!,
                   "descriptionField": self.detailTxtView.text!,
                   "date":self.date,
                   "time":self.selectedTime,
                   "priority": self.priortyValue ?? "medium",
                   "preReminder":self.preReminderTxtField.text ?? "Never",
                   "repitition": self.RepititionTxtField.text! ?? "Never"
                ]) { err in
                    if let err = err {
                        Utilities.hide_ProgressHud(view: self.view)
                        cAlert.ShowToastWithHandler(VC: self, msg: "Error writing document: (\(err)") { sucess in
                            _ = self.tabBarController?.selectedIndex = 0
                        }
                        
                    } else {
                        Utilities.hide_ProgressHud(view: self.view)
                        
                        cAlert.ShowToastWithHandler(VC: self, msg: "Task created successfully") { sucess in
                            _ = self.tabBarController?.selectedIndex = 0
//                            self.titleTxtField.text = ""
//                            self.detailTxtView.text = "Description"
//                            self.catTxtField.text = ""
//                            self.dateTxtField.text = ""
//                            self.timeTxtField.text = ""
//                            self.preReminderTxtField.text = ""
//                            self.RepititionTxtField.text = ""
                        }

                    }
                }
                
            if self.selectedTime != "" && self.date != "" {
                
                let mDate = self.date + " " + self.selectedTime
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy h:mm a"
                let newDate = dateFormatter.date(from: mDate)
                
                if self.preReminderTxtField.text?.isEmpty == false && self.RepititionTxtField.text?.isEmpty == false {
                    //do something
                    
                } else if self.preReminderTxtField.text?.isEmpty == false {
                    //do something
                    self.createPrereminderforNotification(beforeTime: self.preminderMin, newDate: newDate!)
                } else if self.RepititionTxtField.text?.isEmpty == false {
                    self.fireNotification(myDate: newDate!)
                } else {
                    //do something
                    createNotificationReminder(newDate: newDate!)
                    
                }
                
            }
    
        }
    }
    
    func getCategories (userId:String) {
            Utilities.show_ProgressHud(view: self.view)
            self.categories.removeAll()
            let db = Firestore.firestore()
            db.collection("category").whereField("userId", isEqualTo: userId)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: (err)")
                        Utilities.hide_ProgressHud(view: self.view)
                    } else {
                        for document in querySnapshot!.documents {
                            let dicCat = document.data()
                            let objCat = TaskCategory.init(fromDictionary: dicCat)
                            self.categories.append(objCat)
                        }
                        for cat in self.categories {
                            self.strCategories.append(cat.name!)
                        }
                        self.catTxtField.optionArray = self.strCategories
                        Utilities.hide_ProgressHud(view: self.view)
                    }
                    
            }
        }
    
    var frequency = NotificationFrequency.weekly
    func fireNotification(myDate : Date) {
        
        let date = Date() // Replace with your desired date
        let calendar = Calendar.current

        print("Day number: (dayNumber)")
        
        // Create a date components object for the desired trigger date and time
        var dateComponents = DateComponents()
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Repetition"
        content.body = "Repetition body"
        content.sound = UNNotificationSound.default

               

                switch caseNumber {
                case 0: // No repeat
                    dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: myDate)
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                    scheduleNotification(with: trigger, content: content)
                    break
                case 1: // Daily repeat
                    dateComponents.hour = dateComponents.hour! // Example hour, change it to your desired hour
                    dateComponents.minute = dateComponents.minute!
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                    // Create a notification request
                    content.subtitle = "Daily"
                    scheduleNotification(with: trigger, content: content)
                case 2: // Weekly repeat
                    let triggerDate = calendar.date(byAdding: .weekOfYear, value: 1, to: myDate)!
                   let dateComponents1 = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate)
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents1, repeats: true)
                    content.subtitle = "Weekly"
                    scheduleNotification(with: trigger, content: content)
                case 3: // Monthly repeat
                    var components = DateComponents()
                    components.day = dateComponents.day // Example date, change it to your desired date
                    let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                    content.subtitle = "Monthly"
                    scheduleNotification(with: trigger, content: content)
                default: // No repeat
                    break
                }
        

    }
    
    func scheduleNotification(with trigger: UNNotificationTrigger, content: UNMutableNotificationContent) {
           // Create notification request
           let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

           // Add the notification request to the notification center
           UNUserNotificationCenter.current().add(request) { (error) in
               if let error = error {
                   print("Error scheduling notification: \(error.localizedDescription)")
               } else {
                   print("Notification scheduled successfully.")
               }
           }
       }
}


extension CreateTaskViewController: UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if textField == self.txtTitle {
//            self.txtTitle.text = ""
//        }
//        else if textField == self.txtDescription {
//            self.txtDescription.text = ""
//        }
//        else if textField == self.txtLocation {
//            self.txtLocation.text = ""
//        }
         if textField == self.dateTxtField {
//            self.txtFieldDate.text = ""
            self.datePickerTap()
        }
        else if textField == self.timeTxtField {
//            self.txtFieldTime.text = ""
            self.timePickerTap()
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
//                textView.textColor = UIColor.black
                textView.text = ""
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if(textView == self.detailTxtView)
        {
            if(textView.text == "")
            {
                textView.textColor = UIColor.lightGray
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


