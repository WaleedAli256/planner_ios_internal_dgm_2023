//
//  TestViewController.swift
//  ToDoApp
//
//  Created by mac on 07/04/2023.
//

import UIKit
import FSCalendar
import FirebaseFirestore
import IQKeyboardManagerSwift

class SeachTaskViewController: BaseViewController {
    
    @IBOutlet weak var lblTaskCount: UILabel!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var searchTxtField: UITextField!
    var selectedIndex = -1
    var categoryName = ""
    var arrAllTasks = [Task]()
    var filterSearchTasks = [Task]()
    var fromViewController = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchTxtField.delegate = self
        //keyboard settings
        IQKeyboardManager.shared.enableAutoToolbar = false
        searchTxtField.inputAccessoryView = nil
        searchTxtField.autocorrectionType = .no
        
        tblView.register(UINib(nibName: "TaskCell", bundle: nil), forCellReuseIdentifier: "TaskCell")
        searchTxtField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getTaskAgaintCategory()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if self.searchTxtField.text!.count == 0 {
            self.getTaskAgaintCategory()
        } else {
            self.filterSearchTasks = self.arrAllTasks.filter({ word in
                return word.title!.lowercased().contains((self.searchTxtField.text!.lowercased()))
            })
            if self.filterSearchTasks.count > 0 {
                self.lblTaskCount.text = "Total Tasks: \(self.filterSearchTasks.count)"
                self.tblView.reloadData()
            } else {
                self.showAlert(title: "Alert", message: "No task available ")
                self.lblTaskCount.text = "Total Tasks: \(self.filterSearchTasks.count)"
                self.tblView.reloadData()
            }
        }
    }

    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getTaskAgaintCategory() {
        
        if self.fromViewController == "HomeVC" {
            
            Utilities.show_ProgressHud(view: self.view)
            self.arrAllTasks.removeAll()
            let db = Firestore.firestore()
            db.collection("tasks").whereField("userId", isEqualTo: Utilities().getCurrentUser().id ?? "")
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
                        
                        Utilities.hide_ProgressHud(view: self.view)
                        if self.arrAllTasks.count > 0 {
                            self.filterSearchTasks = self.arrAllTasks
                            self.lblTaskCount.text = "Total Tasks: \(self.arrAllTasks.count)"
                            self.tblView.reloadData()
                        } else {
                            self.showAlert(title: "Tasks", message: "No task available")
                    }
                        
                }
            }
        }
        Utilities.show_ProgressHud(view: self.view)
        self.arrAllTasks.removeAll()
        let db = Firestore.firestore()
        db.collection("tasks").whereField("userId", isEqualTo: Utilities().getCurrentUser().id ?? "").whereField("categoryName", isEqualTo: self.categoryName)
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
                    
                    Utilities.hide_ProgressHud(view: self.view)
                    if self.arrAllTasks.count > 0 {
                        self.filterSearchTasks = self.arrAllTasks
                        self.lblTaskCount.text = "Total Tasks: \(self.arrAllTasks.count)"
                        self.tblView.reloadData()
                    } else {
                        self.showAlert(title: "Tasks", message: "No task available")
                }
                    
            }
        }
    }

}

extension SeachTaskViewController: UITableViewDelegate,UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.filterSearchTasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tblView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as? TaskCell else {
            return UITableViewCell()
        }
        let obj = self.filterSearchTasks[indexPath.row]
        
//        if let color = obj.priorityColorCode {
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
//        let originalDateFormat = "MM/dd/yyyy h:mm a"
//        let desiredDateFormat = "EE,d MMM h:mm a"
//        let originalDateString = obj.date

//        if let formattedDate = Utilities.changeDateFormat(fromFormat: originalDateFormat, toFormat: desiredDateFormat, dateString: originalDateString!) {
//            print("Formatted Date: \(formattedDate)")
//            cell.lblpriority.text = obj.priority
        
            cell.lblTimeDate.text = obj.date
            cell.lbltitle.text = obj.title
            if selectedIndex == indexPath.row {
                cell.lblDetail.isHidden = false
                cell.lblDetail.text = obj.description
            }else{
                cell.lblDetail.isHidden = true
                cell.lblDetail.text = ""
            }

//        } else {
//            self.showAlert(title: "Date formate Error", message: "Failed to format date")
//        }
        cell.selectionStyle = .none
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

extension SeachTaskViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.searchTxtField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let textField = self.searchTxtField.text {
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
                   return false
               }
           }
           return true
    }
}
