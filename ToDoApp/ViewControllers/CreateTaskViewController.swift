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
    @IBOutlet weak var dateTxtField: UITextField!
    @IBOutlet weak var timeTxtField: UITextField!
    @IBOutlet weak var preReminderTxtField: DropDown!
    @IBOutlet weak var RepititionTxtField: DropDown!
    
    var datePicker = UIDatePicker()
    var toolBar = UIToolbar()
    private var selectionMode = ""
    private var selectedTime = ""
    private var date = ""
    
    var preReminderTime = ["5min","10min","15min","20min"]
    
    var repitiotn = ["Once in a week","Once in a day","Daily","Weekly","Monthly","Yearly"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dateTxtField.delegate = self
        self.timeTxtField.delegate = self
        
        detailTxtView.textContainer.lineFragmentPadding = 15
        self.detailTxtView.delegate = self
        
        // drop down settings
        preReminderTxtField.arrowColor = .white
        preReminderTxtField.selectedRowColor = .white
        preReminderTxtField.itemsTintColor = .red
        preReminderTxtField.arrowSize = 15
        preReminderTxtField.text = "Select Store"
        
        // drop down settings
        RepititionTxtField.arrowColor = .white
        RepititionTxtField.selectedRowColor = .white
        RepititionTxtField.itemsTintColor = .red
        RepititionTxtField.arrowSize = 15
        RepititionTxtField.text = "Select Store"
        
        preReminderTxtField.didSelect { selectedText, index, id in
            print(id)
            self.preReminderTxtField.text = self.preReminderTime[index].description
//            self.preReminderTime = self.preReminderTime[index].id
        }
        
        RepititionTxtField.didSelect { selectedText, index, id in
            print(id)
            self.RepititionTxtField.text = self.preReminderTime[index].description
//            self.preReminderTime = self.preReminderTime[index].id
        }
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
            formatter.dateFormat = "dd/MM/yyyy"
//            self.txtFieldDate.text = formatter.string(from: self.datePicker.date)
//            self.dateSelected = true
            self.date = formatter.string(from: self.datePicker.date)
            self.dateTxtField.text = self.date
        }
        if(self.selectionMode == "Time")
        {
            self.view.endEditing(true)
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm:ss a"
//            self.txtTitle.text = (formatter.string(from: self.datePicker.date))
//            self.timeSelected = true
            self.selectedTime = formatter.string(from: self.datePicker.date)
            self.timeTxtField.text =  self.selectedTime
        }
//        self.imgBlur.isHidden = true
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
        
        if(preReminderTxtField.text!.count < 1)
        {
            self.showAlert(title: "Error", message:"Please select set pre reminder")
            return false
        }
        
        if(RepititionTxtField.text!.count < 1)
        {
            self.showAlert(title: "Error", message:"Please select set pre reminder")
            return false
        }

        return true
    }
    
    func createAction(_ sender: UIButton) {
        
        if(validate())
        {
            guard Utilities.Connectivity.isConnectedToInternet else {
                self.showAlert(title: "Error", message: "Please check your internet connection")
                    return
            }
            Utilities.show_ProgressHud(view: self.view)
     
            let dic = ["Title": self.titleTxtField.text ?? "",
                       "Detail": self.detailTxtView.text ?? "",
                       "id": "id",
                       "Category_id": "cat",
                       "userId":Utilities().getCurrentUser().id ?? "",
                       "Category_name": "catName",
                       "date":self.date,
                       "time":self.selectedTime,
                       "priority":"",
                       "pre_reminder":self.preReminderTxtField.text!,
                       "repitition": self.RepititionTxtField.text!,
                       ] as [String : Any]
            
                let db = Firestore.firestore()
                var ref: DocumentReference?
        
                ref = db.collection("users").document(Utilities().getCurrentUser().id ?? "").collection("tasks").addDocument(data: dic)
            
                self.showAlert(title: "Task", message: "Task created successfully")
                Utilities.hide_ProgressHud(view: self.view)
//                self.docId = ref!.documentID
            
            
//            if selectedTime != ""{
//                let mDate = self.date + " " + self.selectedTime
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "dd/MM/yyyy hh:mm:ss a"
//                let newDate = dateFormatter.date(from: mDate)
//
//                let center = UNUserNotificationCenter.current()
//                let content = UNMutableNotificationContent()
//                content.title = self.txtTitle.text ?? ""
//                content.body = self.txtDescription.text ?? ""
//                content.sound = UNNotificationSound.default
//                content.categoryIdentifier = self.docId
//
//                let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: newDate!)
//
//                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
//
//                let uniqueID = self.docId // Keep a record of this if necessary
//                let request = UNNotificationRequest(identifier: uniqueID, content: content, trigger: trigger)
//                center.add(request)
//
//
//
//            let controller = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//
//            self.navigationController?.pushViewController(controller, animated: true)
//        }
    
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
                textView.textColor = UIColor.black
                textView.text = ""
            }
        }
    }
}
