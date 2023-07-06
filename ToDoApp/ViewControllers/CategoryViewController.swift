//
//  CategoryViewController.swift
//  ToDoApp
//
//  Created by mac on 31/03/2023.
//

import UIKit
import Firebase
import FirebaseFirestore
import BEMCheckBox
var catFavouritCount = 0
class CategoryViewController: BaseViewController {
    
    @IBOutlet weak var profilPic: UIImageView!
    @IBOutlet weak var catColView: UICollectionView!
    
    var categories: [TaskCategory] = []
    var cellRow: Int!
    var actionTyp: String!
    var actionIndex: Int!
    var selectedIndex = -1
    var selectedInde: Int = -1
    var favCategories: [TaskCategory] = []
    var updatedCellHeight: CGFloat = 0.0
    var cellHeight: CGFloat = 148.0
    var checkBoxHide: Bool = true
    override func viewDidLoad() { 
        super.viewDidLoad()
        
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
                catColView.addGestureRecognizer(longPressGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        profilPic.addGestureRecognizer(tapGesture)
        profilPic.isUserInteractionEnabled = true
        
        self.profilPic.layer.cornerRadius = self.profilPic.frame.size.width / 2
        self.profilPic.clipsToBounds = true
        self.catColView.delegate = self
        self.catColView.dataSource = self
//        Utilities.show_ProgressHud(view: self.view)
    

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkBoxHide = true
        self.navigationController?.navigationBar.isHidden = true
        self.getCategories(userId: Utilities().getCurrentUser().id ?? "")
        self.setData()
//        self.setNavBar("Category", self.profilPic.image!)
    }
    
    @objc func imageTapped() {
        self.tabBarController?.selectedIndex = 4
    }
    
    func getCategories (userId:String) {
        selectedInde = -1
        let db = Firestore.firestore()
        db.collection("category").whereField("userId", isEqualTo: userId)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    Utilities.hide_ProgressHud(view: self.view)
                } else {
                    Utilities.hide_ProgressHud(view: self.view)
                    self.categories.removeAll()
//                    self.favCategories.removeAll()
                    for document in querySnapshot!.documents {
                        let dicCat = document.data()
                        let objCat = TaskCategory.init(fromDictionary: dicCat)
                        self.categories.append(objCat)
                    }
                    let filteredFavCat = self.categories.filter({$0.isFavourite == true })
                    catFavouritCount = filteredFavCat.count
                    self.selectedInde = -1
                    self.catColView.reloadData()
                }
            }
    }
    
    func deleteCategories() {
        selectedInde = -1
        let db = Firestore.firestore()
//        db.collection("category").whereField("id", isEqualTo: self.categories[self.cellRow].id!).
//        self.getCategories(userId: Utilities().getCurrentUser().id ?? "")
        
        db.collection("category").whereField("id", isEqualTo: self.categories[self.cellRow].id!).getDocuments {(querySnapshot , err) in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                guard let documents = querySnapshot?.documents else { return }
                       for document in documents {
                           document.reference.delete()
                }
                self.getCategories(userId: Utilities().getCurrentUser().id ?? "")
                print("Document successfully removed!")
            }
        }
    }
    
    @IBAction func addCateAction(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addCatVC = storyboard.instantiateViewController(identifier: "AddCategoryViewController") as! AddCategoryViewController
        addCatVC.fromEditOrUpdate = "Create Category"
        self.navigationController?.pushViewController(addCatVC, animated: true)
    }
    
    @IBAction func btnShowEditDeleteView(_ sender: UIButton) {
        if sender.tag == selectedInde {
            selectedInde = -1
        } else {
            selectedInde = sender.tag
        }
        self.catColView.reloadData()
    }
    
    @IBAction func btnEditAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addCatVC = storyboard.instantiateViewController(identifier: "AddCategoryViewController") as! AddCategoryViewController
        addCatVC.fromEditOrUpdate = "Update Category"
        addCatVC.categoryObj = self.categories[sender.tag]
        self.navigationController?.pushViewController(addCatVC, animated: true)
    }
    
    @IBAction func btnDeleteAction(_ sender: UIButton) {
        
        
        let alertController = UIAlertController(title: "Alert", message: "Are you sure you want to delete this task?", preferredStyle: .alert)
      let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.destructive) {
            UIAlertAction in
          var taskIds = [String]()
          self.cellRow = sender.tag
          self.selectedInde = -1
          let db = Firestore.firestore()
          db.collection("tasks").whereField("categoryId", isEqualTo: self.categories[sender.tag].id!).getDocuments {(querySnapshot , err) in
              if let err = err {
                  print("Error removing document: \(err)")
              } else {
                  guard let documents = querySnapshot?.documents else { return }
                         for document in documents {
                             taskIds.append(document.documentID)
                             document.reference.delete()
                  }
                  UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: taskIds)
                  self.getCategories(userId: Utilities().getCurrentUser().id ?? "")
                  print("Document successfully removed!")
              }
          }                              
          self.deleteCategories()
          
          
          
        }
      let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
           
        }

        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)

      self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func checkBoxAction(_ sender: BEMCheckBox) {
        
        if catFavouritCount >= 6 && sender.on == true {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.showAlert(title: "Limit Exceeded", message: "You can only add up to six categories.")
            }
           
        } else {
            var category = self.categories[sender.tag]
            if sender.on {
                category.isFavourite = true
                self.catAddToFavouritFirebase(category.isFavourite!, category.id!) { Status in
                    if Status {
                    catFavouritCount += 1
                    self.showAlert(title: "Category Added", message: "The category has been added to your favorites.")
                        
                    }
                }
                
            } else {
                category.isFavourite = false
                self.catAddToFavouritFirebase(category.isFavourite!, category.id!) { Status in
                    if Status {
                        catFavouritCount -= 1
                        self.showAlert(title: "Category Removed", message: "The category has been removed from your favorites.")
                        
                    }
                }
                
            }
            
          
        }
       
        self.getCategories(userId: Utilities().getCurrentUser().id ?? "")
        self.catColView.reloadData()

    }
    
    func catAddToFavouritFirebase(_ isFavourit: Bool, _ catId: String,completion: @escaping(_ Status: Bool) -> Void) {
        
        let db = Firestore.firestore()
        let ref = db.collection("category").document(catId)
        ref.setData([
            "isFavourite": isFavourit
        ], merge: true) { err in
            if let err = err {
                cAlert.ShowToastWithHandler(VC: self, msg: "Error writing document: (\(err)") { sucess in
                }
                completion(false)
            } else {
                print("successful")
                completion(true)
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
            customPopUpVC.modalTransitionStyle = .crossDissolve
            customPopUpVC.view.frame = self.view.frame
            customPopUpVC.delegate = self
            self.view.addSubview(customPopUpVC.view)
            customPopUpVC.modalTransitionStyle = .coverVertical
            customPopUpVC.modalPresentationStyle = .fullScreen
            customPopUpVC.didMove(toParent: self)
    }
    
    func setData(){
        if Utilities.getIntForKey("isAnonmusUser") == "0" {
            
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
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
           if gestureRecognizer.state == .began {
               // Get the collection view
               checkBoxHide = !checkBoxHide
//               for case let cell as CategoryCollectionViewCell in catColView.visibleCells {
//                   cell.checkBox.isHidden = !cell.checkBox.isHidden
//                   cell.stackInnerView.isHidden = !cell.stackInnerView.isHidden
//
//                   // Adjust cell height based on checkbox visibility
//                   if cell.checkBox.isHidden {
//                       cellHeight = 163 // Replace 50 with your original cell height
//                   } else {
//                       cellHeight = 190 // Replace 72 with your desired expanded cell height
//                   }
//                   UIView.animate(withDuration: 0.3) {
//                       self.view.layoutIfNeeded()
//                   }
//
//               }
               self.catColView.reloadData()
           }
        
       }
       
       // ...
   }



extension CategoryViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = catColView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as? CategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        let cat = self.categories[indexPath.row]
        cell.btndropdown.tag = indexPath.row
        cell.checkBox.tag = indexPath.row
        if selectedInde == indexPath.row {
            cell.popupView.isHidden = false
        } else {
            cell.popupView.isHidden = true
        }
//        if checkBoxHide == true {
        cell.checkBox.isHidden = checkBoxHide
        cell.stackInnerView.isHidden = checkBoxHide
        if cat.isFavourite == true {
            cell.checkBox.on = true
        } else {
            cell.checkBox.on = false
        }
//        if cell.checkBox.isHidden == true {
//            cellHeight = 163
//        } else {
//            cellHeight = 190
//        }
//        }
        
        // Hide the checkbox initially
        
       
        cell.checkBox.boxType = .square
        cell.delegate = self
        cell.deleteBtn.tag = indexPath.row
        cell.editBtn.tag = indexPath.row
        cell.catBGView.backgroundColor = UIColor(hexString: cat.colorCode ?? "")
        cell.catDesc.text = cat.description ?? ""
        cell.catName.text = cat.name ?? ""
//        cell.catImage.image = UIImage(named: cat.image ?? "")
        var num = cat.image ?? 1
        if num < 0{
            num = num * -1
        }
        cell.catImage.image = UIImage(named: "cat-icon-\(num)")?.withTintColor(.white)
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//
//
//        self.tblView.reloadData()
//    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        if selectedIndex == indexPath.row{
//            selectedIndex = -1
//        }else{
//            self.selectedIndex = indexPath.row
//        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let searchTaskVC = storyboard.instantiateViewController(identifier: "SeachTaskViewController") as! SeachTaskViewController
        searchTaskVC.selectedCategory = self.categories[indexPath.row]
        searchTaskVC.fromViewController = "CategoryVC"
        searchTaskVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(searchTaskVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frameCV = catColView.frame//размер collectionView
        let cellWidth = (frameCV.width / CGFloat(2)) - 10 // countOfCells == 2

        if self.checkBoxHide == false {
            self.cellHeight = 190
        } else {
            self.cellHeight = 150
        }
        
        if cellWidth < 190 {
            return CGSize(width: cellWidth, height: cellHeight)
        }else{
            return CGSize(width: 190, height: 190)
        }
    }
}

extension CategoryViewController: PopupViewControllerDelegate {
    func dimissSuperView() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension CategoryViewController: CategoryCollectionViewCellDelegate{
    
    func editOrDelete(_ actionType: String, _ actionIndex: Int, _ cellIndex: IndexPath) {
        self.cellRow = cellIndex.row
        self.actionTyp = actionType
        self.actionIndex = actionIndex
        print(actionType)
        print(actionIndex)
        print(cellIndex.row)
        
//        self.categories.remove(at: cellIndex.row)
        
        if self.actionIndex == 0 {
            //edit the category
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let addCatVC = storyboard.instantiateViewController(identifier: "AddCategoryViewController") as! AddCategoryViewController
            addCatVC.fromEditOrUpdate = "Update Category"
            addCatVC.categoryObj = self.categories[self.cellRow]
            self.navigationController?.pushViewController(addCatVC, animated: true)
            
            
        } else {
            let db = Firestore.firestore()
            db.collection("tasks").whereField("id", isEqualTo: self.categories[self.cellRow].id!).getDocuments {(querySnapshot , err) in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    guard let documents = querySnapshot?.documents else { return }
                           for document in documents {
                               document.reference.delete()
                    }
                    self.getCategories(userId: Utilities().getCurrentUser().id ?? "")
                    print("Document successfully removed!")
                }
            }
            self.deleteCategories()
        }
        
        
            
        // cate id
        // get cate / skip
        // all task again that cate id
        // chak all task is yours / skip
        // delete all task
        // than delete cate
        
    }
    
}


