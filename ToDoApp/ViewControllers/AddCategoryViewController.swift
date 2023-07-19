//
//  AddCategoryViewController.swift
//  ToDoApp
//
//  Created by mac on 01/05/2023.
//

import UIKit
import Firebase
import FirebaseFirestore

class AddCategoryViewController: BaseViewController {

    @IBOutlet weak var uploadIcon: UIImageView!
    @IBOutlet weak var colview: UICollectionView!
    @IBOutlet weak var lblUploadIcon: UILabel!
    @IBOutlet weak var lblCatTopTitle: UILabel!
    @IBOutlet weak var topColView: UIView!
    @IBOutlet weak var btnCrUpCat: UIButton!
    @IBOutlet weak var txtCatName: UITextField!
    @IBOutlet weak var txtViewDescrip: UITextView!
    var allCategories = [TaskCategory]()
    var hexColorCode = ""
    var imageIconNumber: Int?
    var fromEditOrUpdate: String!
    var categoryObj: TaskCategory!
    var selectedIndex = -1
    var sizeOfCellChange: Bool = false
    fileprivate let maxLen = 250
    var alertMsg = ""
    var colorsArray = ["#5486E9","#F2AD10","#FFB489","#E784D1","#81DF8A","#51BBA2","#971919"]
    var fromViewController = ""
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.isHidden = false
//        self.navigationItem.title = "Create Category"
//        self.navigationController?.navigationBar.tintColor = UIColor(named: "low-text-color")
//        self.navigationController?.navigationBar.topItem?.backButtonTitle = "category"
        
        if txtViewDescrip.text! == "Description"{
            txtViewDescrip.textColor = UIColor(named: "text-view-placeholder")
        }else{
            txtViewDescrip.textColor = UIColor(named: "TextColor")
        }
        self.txtViewDescrip.keyboardToolbar.isHidden = true
        self.txtViewDescrip.autocorrectionType = .no
        self.txtCatName.autocorrectionType = .no
        
//        self.colview.delegate = self
//        self.colview.dataSource = self
        self.txtCatName.delegate = self
        self.txtViewDescrip.delegate = self
        self.txtViewDescrip.textContainer.lineFragmentPadding = 15
//        self.lblCatTopTitle.text = fromEditOrUpdate
        self.setNavBar("\(fromEditOrUpdate!)")
        self.btnCrUpCat.setTitle(fromEditOrUpdate, for: .normal)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.fromEditOrUpdate == "Update Category" {
            self.populateView()
            txtViewDescrip.textColor = UIColor(named: "TextColor")
        }
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func populateView() {
        self.colview.isHidden = true
        self.topColView.isHidden = true
        self.uploadIcon.image = UIImage(named: "cat-icon-\(categoryObj.image!)")?.withTintColor(.white)
        self.txtCatName.text = categoryObj.name
        self.txtViewDescrip.text = categoryObj.description
        self.imageIconNumber = categoryObj.image
//        self.hexColorCode = categoryObj.colorCode!
    }
    
    private func validate() -> Bool
    {
        if(self.imageIconNumber == nil)
        {
            self.showAlert(title: "Alert", message:"Please select an icon")
            return false
        }
        
//        if fromEditOrUpdate == "Create Category" {
//            if(self.hexColorCode == "")
//            {
//                self.showAlert(title: "Alert", message:"Please select the color")
//                return false
//            }
//        }
        
        if(self.txtCatName.text!.count == 0)
        {
            self.showAlert(title: "Alert", message: "Please enter category name")
            return false
        }
        if(self.txtViewDescrip.text?.count ?? 0 < 1 || self.txtViewDescrip.text == "Description")
        {
            self.showAlert(title: "Alert", message:"Please enter category description")
            return false
        }
        if allCategories.count > 0{
            let filteredFavCat = self.allCategories.filter({($0.name ?? "").lowercased() == txtCatName.text!.lowercased() })
            if filteredFavCat.count > 0{
                self.showAlert(title: "Alert", message:"This Category name already exists, please choose another one")
                return false
            }
        }
        
        return true
    }
    @IBAction func CreateCateGoryActon(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let searchTaskVC = storyboard.instantiateViewController(identifier: "CreateTaskViewController") as! CreateTaskViewController
//        searchTaskVC.mySelectedCategory = categoryName
        self.navigationController?.pushViewController(searchTaskVC, animated: true)
    }
    @IBAction func btnCreateCatAction(_ sender: UIButton) {
    
            self.addNewCategory()

    }
        func addNewCategory() {
            
            if(validate())
            {
                guard Utilities.Connectivity.isConnectedToInternet else {
                    self.showAlert(title: "Error", message: "Please check your internet connection")
                        return
                }
                
                if fromEditOrUpdate == "Create Category" {
                    //for new category
//                    Utilities.show_ProgressHud(view: self.view)
                    let db = Firestore.firestore()
                    let ref = db.collection("category").document()
                    var dic = ["id": ref.documentID,
                                "userId": Utilities().getCurrentUser().id  ?? "",
                                "name": self.txtCatName.text!,
                                "description": self.txtViewDescrip.text!,
                                "colorCode": self.hexColorCode,
                                "image": self.imageIconNumber ?? 1,
                                "taskCount": "0",
                                "isFavourite": false] as [String : Any]
                    ref.setData(dic) { err in
                        if let err = err {
                            Utilities.hide_ProgressHud(view: self.view)
                            cAlert.ShowToastWithHandler(VC: self, msg: "Error writing document: (\(err)") { sucess in
                                _ = self.tabBarController?.selectedIndex = 0
                            }

                        } else {
                            Utilities.hide_ProgressHud(view: self.view)
                            self.alertMsg = "You have successfully created a new category!"
                            self.showPopup()
                    }
                }
                    
                } else {
                    // for edit category
                    
                    let db = Firestore.firestore()
                    let ref = db.collection("category").document(self.categoryObj?.id ?? "")
                    var dic1 = ["id": ref.documentID,
                                "userId": Utilities().getCurrentUser().id  ?? "",
                                "name": self.txtCatName.text!,
                                "description": self.txtViewDescrip.text!,
                                "colorCode": self.hexColorCode,
                                "image": self.imageIconNumber ?? 1,
                                "taskCount": "0"] as [String : Any]
                    
//                    Utilities.show_ProgressHud(view: self.view)
                    
//                    db.collection("category").document()
                    ref.setData(dic1, merge: true) { err in
                        if let err = err {
                            Utilities.hide_ProgressHud(view: self.view)
                            cAlert.ShowToastWithHandler(VC: self, msg: "Error writing document: (\(err)") { sucess in
                                _ = self.tabBarController?.selectedIndex = 0
                            }

                        } else {
                            self.alertMsg = "You have successfully updated a new category!"
                            Utilities.hide_ProgressHud(view: self.view)
                            self.showPopup()
                          
                    }
                }
                    
            }
                    
        }
    }
    
    func showPopup() {
        
        //show popup
        let customPopUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopupViewController") as! PopupViewController
//                customPopUpVC.isWorkLabelhidden = false
//                customPopUpVC.wordTxt = ""//"Immunosuppressed"
//                customPopUpVC.meanignTxt = currentQues!.info ?? ""
            self.addChild(customPopUpVC)
            customPopUpVC.alertMg = self.alertMsg
            customPopUpVC.modalTransitionStyle = .crossDissolve
            customPopUpVC.view.frame = self.view.frame
            customPopUpVC.delegate = self
            self.view.addSubview(customPopUpVC.view)
            customPopUpVC.modalTransitionStyle = .coverVertical
            customPopUpVC.modalPresentationStyle = .fullScreen
            
            customPopUpVC.didMove(toParent: self)
    }
    
    @IBAction func btnUploadAction(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let catIconVC = storyboard.instantiateViewController(identifier: "CategoryIconViewController") as! CategoryIconViewController
        catIconVC.delegate = self
        catIconVC.fromEditOrUpdat = self.fromEditOrUpdate
        self.navigationController?.pushViewController(catIconVC, animated: true)
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}


//extension AddCategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.colorsArray.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        guard let cell = colview.dequeueReusableCell(withReuseIdentifier: "ColorCollectionViewCell", for: indexPath) as? ColorCollectionViewCell else {
//            return UICollectionViewCell()
//        }
//
//        if selectedIndex == indexPath.row {
//            self.sizeOfCellChange = true
//        }else{
//            self.sizeOfCellChange = false
//        }
//        cell.colorView.backgroundColor = UIColor(hexString: self.colorsArray[indexPath.row])
//        return cell
//    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.hexColorCode = self.colorsArray[indexPath.row]
//        if selectedIndex == indexPath.row{
//            selectedIndex = -1
//        }else{
//            self.selectedIndex = indexPath.row
//        }
//
//        self.colview.reloadData()
//    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let defaultSize = CGSize(width: 30, height: 30)
//        if indexPath.row ==  self.selectedIndex {
//            return CGSize(width: 35, height: 35)
//
//        }
//        return defaultSize
//    }

    
//}

extension AddCategoryViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           // Get the current text in the text field
        if let textField = self.txtCatName.text {
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
}

extension AddCategoryViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if(textView == self.txtViewDescrip)
        {
            if(textView.text == "Description")
            {
                textView.textColor = UIColor(named: "TextColor")
                textView.text = ""
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if(textView == self.txtViewDescrip)
        {
            if(textView.text == "")
            {
                textView.textColor = UIColor(named: "text-view-placeholder")
                textView.text = "Description"
            } else {
                txtViewDescrip.resignFirstResponder()
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
            case txtCatName:
                self.txtViewDescrip.becomeFirstResponder()
            case txtViewDescrip:
                self.txtViewDescrip.resignFirstResponder()
            default:
                textField.resignFirstResponder()
            }
            return false
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" { // Check for "Done" button press
            self.txtViewDescrip.resignFirstResponder() // Hide the keyboard
                  return false
        }
        
        let disallowedCharacterSet = CharacterSet(charactersIn: "0123456789")
              if let _ = text.rangeOfCharacter(from: disallowedCharacterSet) {
                  return false
        }
        
        
//        let allowedCharacters = CharacterSet.letters
//        let characterSet = CharacterSet(charactersIn: text)
//        return allowedCharacters.isSuperset(of: characterSet)
        let newLen = (textView.text.count - range.length) + text.count
        return newLen <= maxLen
    }
}

extension AddCategoryViewController: CategoryIconViewControllerDelegate {
    func uploadCatgoryIcon(_ iconName: Int) {
        if self.fromEditOrUpdate == "Update Category" {
            categoryObj.image = iconName
        } else {
            self.lblUploadIcon.text = "Icon Selected"
            self.imageIconNumber = iconName
            self.uploadIcon.image = UIImage(named: "cat-icon-\(iconName)")?.withTintColor(.white)
        }
        
    }
}

extension AddCategoryViewController: PopupViewControllerDelegate {
    
    func dimissSuperView() {
        self.navigationController?.popViewController(animated: true)
    }
    
}


