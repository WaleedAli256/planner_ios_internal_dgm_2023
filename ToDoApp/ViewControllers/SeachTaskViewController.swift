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
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var lblcatName: UILabel!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var btnCrateTask: UIButton!
    @IBOutlet weak var btnCrateTask2: UIButton!
    
    var selectedIndex = -1
    var categoryName = ""
    var arrAllTasks = [Task]()
    var filterSearchTasks = [Task]()
    var fromViewController = ""
    var selectedInde: Int = -1
    
    var cellRow: Int!
    var actionTyp: String!
    var actionIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.lblcatName.text = self.categoryName
        self.searchTxtField.delegate = self
        //keyboard settings
        IQKeyboardManager.shared.enableAutoToolbar = false
        searchTxtField.inputAccessoryView = nil
        searchTxtField.autocorrectionType = .no
        
        tblView.register(UINib(nibName: "TaskCell", bundle: nil), forCellReuseIdentifier: "TaskCell")
        searchTxtField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
//        Utilities.show_ProgressHud(view: self.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CreateTaskViewController.onCreateTask = { catName in
            self.categoryName = catName
        }
        self.getTaskAgaintCategory()
        btnCrateTask2.layer.cornerRadius = 25
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func swipeToPop() {

//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
//    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//
//        if gestureRecognizer == self.navigationController?.interactivePopGestureRecognizer {
//            return true
//        }
//        return false
//    }
    
    @IBAction func createNewTask(_ sender: UIButton) {
        //create VC
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let searchTaskVC = storyboard.instantiateViewController(identifier: "CreateTaskViewController") as! CreateTaskViewController
//        searchTaskVC.mySelectedCategory = categoryName
        searchTaskVC.fromViewController = "searchTaskViewController"
        self.navigationController?.pushViewController(searchTaskVC, animated: true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if self.searchTxtField.text!.count == 0 {
            self.getTaskAgaintCategory()
        } else {
            self.filterSearchTasks = self.arrAllTasks.filter({ word in
                return word.title!.lowercased().contains((self.searchTxtField.text!.lowercased()))
            })
            if self.filterSearchTasks.count > 0 {
//                self.alertLabel.isHidden = false
//                self.lblTaskCount.isHidden = false

//                self.lblTaskCount.text = "Total Tasks: \(self.filterSearchTasks.count)"
                self.btnCrateTask.isHidden = true
                self.btnCrateTask2.isHidden = false
                self.searchView.isHidden = false
                self.tblView.reloadData()
            } else {
                self.alertLabel.isHidden = false
                self.lblTaskCount.isHidden = true
                self.searchView.isHidden = true
                self.btnCrateTask.isHidden = false
                self.btnCrateTask2.isHidden = true
                self.alertLabel.text = "No task available!"
//                self.lblTaskCount.text = "Total Tasks: \(self.filterSearchTasks.count)"
                self.tblView.reloadData()
            }
        }
    }

    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getTaskAgaintCategory() {
        selectedInde = -1
        if self.fromViewController == "HomeVC" {
//            self.lblcatName.text = "All Tasks"
            self.setNavBar("All Tasks")
            let db = Firestore.firestore()
            db.collection("tasks").whereField("userId", isEqualTo: Utilities().getCurrentUser().id ?? "")
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                        Utilities.hide_ProgressHud(view: self.view)
                    } else {
                        self.arrAllTasks.removeAll()
                        Utilities.hide_ProgressHud(view: self.view)
                        for document in querySnapshot!.documents {
                            let dicCat = document.data()
                            let objCat = Task.init(fromDictionary: dicCat)
                            self.arrAllTasks.append(objCat)
                        }
                        self.filterSearchTasks = self.arrAllTasks
                        Utilities.hide_ProgressHud(view: self.view)
                        if self.arrAllTasks.count > 0 {
                            self.alertLabel.isHidden = true
                            self.btnCrateTask.isHidden = true
                            self.btnCrateTask2.isHidden = false
                            self.searchView.isHidden = false
                            self.filterSearchTasks = self.arrAllTasks
//                            self.lblTaskCount.text = "Total Tasks: \(self.arrAllTasks.count)"
                            self.tblView.reloadData()
                        } else {
                            self.searchView.isHidden = true
                            self.alertLabel.isHidden = false
                            self.lblTaskCount.isHidden = true
                            self.btnCrateTask.isHidden = false
                            self.btnCrateTask2.isHidden = true
                            self.alertLabel.text = "No Task Available!"
//                            self.lblTaskCount.text = "Total Tasks: \(self.arrAllTasks.count)"
//                            self.alertLabel.text = "No task available!"
                            self.tblView.reloadData()
                    }
                        
                }
            }
        } else {
            
//            self.lblcatName.text = self.categoryName
            self.setNavBar("\(self.categoryName)")
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
                        self.filterSearchTasks = self.arrAllTasks
                        if self.arrAllTasks.count > 0 {
                            self.alertLabel.isHidden = true
//                            self.lblTaskCount.text = "Total Tasks: \(self.arrAllTasks.count)"
                            self.searchView.isHidden = false
                            self.btnCrateTask2.isHidden = false
                            self.btnCrateTask.isHidden = true
                            self.tblView.reloadData()
                        } else {
                            self.searchView.isHidden = true
                            self.alertLabel.isHidden = false
//                            self.lblTaskCount.isHidden = true
                            self.btnCrateTask.isHidden = false
                            self.btnCrateTask2.isHidden = true
                            self.alertLabel.text = "No Task Available!"
//                            self.lblTaskCount.text = "Total Tasks: \(self.arrAllTasks.count)"
//                            self.alertLabel.text = "No task available!"
                            self.tblView.reloadData()
                        }
                        
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
        
        cell.btndropdown.tag = indexPath.row
        cell.deleteBtn.tag = indexPath.row
        
        if selectedInde == indexPath.row {
            cell.popupView.isHidden = false
        } else {
            cell.popupView.isHidden = true
        }
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
            cell.delegate = self
            cell.delegate2 = self
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

extension SeachTaskViewController: TaskCellDelegate,TaskCellDelegate2{
    func btnDelete(_ btnTag: Int) {
        
        if btnTag == selectedInde {
            selectedInde = -1
        } else {
            selectedInde = btnTag
        }
        self.tblView.reloadData()
    
        // cate id
        // get cate / skip
        // all task again that cate id
        // chak all task is yours / skip
        // delete all task
        // than delete cate
    }
    func deleteTaskAgainstId(ind:Int,completion: @escaping (_ status : Bool) -> Void){
        let db = Firestore.firestore()
       var taskIds = [String]()
        db.collection("tasks").whereField("id", isEqualTo: self.filterSearchTasks[ind].id!).getDocuments {(querySnapshot , err) in
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
    
    func btnDeleted(_ btnTag: Int) {

          let alertController = UIAlertController(title: "Alert", message: "Are you sure you want to delete this task?", preferredStyle: .alert)
          let okAction = UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive) {
              UIAlertAction in
            self.deleteTaskAgainstId(ind: btnTag) { status in
                if status {
                    self.getTaskAgaintCategory()
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
    

}
