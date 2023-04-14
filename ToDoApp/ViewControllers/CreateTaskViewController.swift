//
//  CreateTaskViewController.swift
//  ToDoApp
//
//  Created by mac on 11/04/2023.
//

import UIKit
import iOSDropDown


class CreateTaskViewController: BaseViewController {
    
    @IBOutlet weak var titleTxtField: UITextField!
    @IBOutlet weak var detailTxtView: UITextView!
    @IBOutlet weak var dateTxtField: UITextField!
    @IBOutlet weak var timeTxtField: UITextField!
    @IBOutlet weak var setReminderTxtField: DropDown!
    
    var datePicker = UIDatePicker()
    var toolBar = UIToolbar()
    private var selectionMode = ""
    private var selectedTime = ""
    private var date = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dateTxtField.delegate = self
        self.timeTxtField.delegate = self
        
        detailTxtView.textContainer.lineFragmentPadding = 15
        self.detailTxtView.delegate = self
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
        
        if(setReminderTxtField.text!.count < 1)
        {
            self.showAlert(title: "Error", message:"Please select set pre reminder")
            return false
        }

        return true
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
