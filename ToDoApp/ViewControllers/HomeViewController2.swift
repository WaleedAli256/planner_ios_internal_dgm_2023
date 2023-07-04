//
//  HomeViewController2.swift
//  ToDoApp
//
//  Created by mac on 25/06/2023.
//

import UIKit
import Firebase
import FirebaseFirestore
import GoogleMobileAds
import StoreKit

class HomeViewController2: UIViewController {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTaskToday: UILabel!
    @IBOutlet weak var btnRecent: CustomButton!
    @IBOutlet weak var btnUpcoming: CustomButton!
    @IBOutlet weak var btnHistory: CustomButton!
    @IBOutlet weak var btnThisMonth: CustomButton!
    @IBOutlet weak var colView: UICollectionView!
    @IBOutlet weak var stackInnerView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblTotalTaskNumbr: UILabel!
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var colViewHeight: NSLayoutConstraint!
    
    var isExpanded: Bool = false
    var heightIncreased: Bool = false
    var selectedIndex = -1
    var allTasks: [Task] = []
    var categories: [TaskCategory] = []
    var cateAgainstName = [customCategories]()
    struct customCategories {
        var cateName = String()
        var array = [Task]()
    }
    
    var colCellColorArray = ["cat-color-1","cat-color-2","cat-color-3","cat-color-4","cat-color-5","cat-color-6"]
    var tbleCellColors = ["task-cell-color-1","task-cell-color-2","task-cell-color-3"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utilities.setStringForKey(Constants.UserDefaults.currentUserExit, key: "NoUserExist")
        Utilities.setIsFirstTime(isFirstTime: false)
        Utilities.setStringForKey("false", key: "logout")
    
//        bottomViewTopConstraint.constant = 260
        
        tblView.register(UINib(nibName: "TaskCell2", bundle: nil), forCellReuseIdentifier: "TaskCell2")
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        
//       \
        
//        bottomView.addGestureRecognizer(gestureRecognizer)
        bottomView.addGestureRecognizer(panGestureRecognizer)
        self.colView.dataSource = self
        self.colView.delegate = self
        self.bottomViewHeight.constant =  300
        self.tapButtons(btnRecent, [btnHistory,btnUpcoming,btnThisMonth])
        
    
    }
    

    
    @objc private func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: view)
    
        if isExpanded {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.isExpanded = false
            }
            UIView.animate(withDuration: 1.0, delay: 0, options: .transitionFlipFromTop) {
                self.bottomViewHeight.constant = 300
            } completion: { Bool in
             
            }

            
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.isExpanded = true
            }
            
            UIView.animate(withDuration: 1.75) {
                self.bottomViewHeight.constant = 600
            }
//            self.bottomViewHeight.constant = 600
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getAllTasks(userId: Utilities().getCurrentUser().id ?? "") { Status in
            if Status {
                self.lblTotalTaskNumbr.text = "01 / \(self.allTasks.count)"
                self.tblView.reloadData()
                self.getCategories(userId: Utilities().getCurrentUser().id ?? "") { Status in
                    if Status {
                        for temp in self.categories{
                            let filteredArray = self.allTasks.filter({$0.categoryName == temp.name })
                            let newObj = customCategories(cateName: temp.name ?? "", array: filteredArray)
                            self.cateAgainstName.append(newObj)
                        }
                            let cellHeight: CGFloat = 55.0
                            let numberOfCells = self.cateAgainstName.count
                            let numberOfRows = (numberOfCells + 1) / 2
                            let totalHeight = cellHeight * CGFloat(numberOfRows)
                            self.colViewHeight.constant = totalHeight + 32
                
                            self.colView.reloadData()
                    }
                }

            }
        }
       
        
    }
    
    @IBAction func searchBtnAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let searchTaskVC = storyboard.instantiateViewController(identifier: "SeachTaskViewController") as! SeachTaskViewController
        searchTaskVC.fromViewController = "HomeVC"
        self.navigationController?.pushViewController(searchTaskVC, animated: true)
    }

    @IBAction func recentAction(_ sender: UIButton) {
        self.tapButtons(btnRecent, [btnHistory,btnUpcoming,btnThisMonth])
    }
    
    @IBAction func upcomingAction(_ sender: UIButton) {
        self.tapButtons(btnUpcoming, [btnHistory,btnRecent,btnThisMonth])
    }
    
    @IBAction func historyAction(_ sender: UIButton) {
        self.tapButtons(btnHistory, [btnUpcoming,btnRecent,btnThisMonth])
    }
    
    @IBAction func thisMonthAction(_ sender: UIButton) {
        self.tapButtons(btnThisMonth, [btnHistory,btnRecent,btnUpcoming])
    }
    
    @IBAction func seeAllAction(_ sender: UIButton) {
        _ = self.tabBarController?.selectedIndex = 1
    }
    
//    @IBAction func bottomViewGestureAction(_ sender: UIButton) {
//
//        if isExpanded {
//            self.isExpanded = false
//            bottomViewTopConstraint.constant = 260
//        } else {
//            self.isExpanded = true
//            bottomViewTopConstraint.constant = 10
//        }
//
//    }
    
    func tapButtons(_ btnSelected: UIButton, _ btnDeselected: [UIButton])  {
        btnSelected.isSelected = true
        for i in btnDeselected {
            i.isSelected = false
        }
    }
    
    func getAllTasks(userId:String, completion: @escaping(_ Status: Bool) -> Void) {
        self.allTasks.removeAll()
        let db = Firestore.firestore()
        db.collection("tasks").whereField("userId", isEqualTo: userId)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    completion(false)
                } else {
                    for document in querySnapshot!.documents {
                        let dicCat = document.data()
                        let objCat = Task.init(fromDictionary: dicCat)
                        self.allTasks.append(objCat)
                    }
                    completion(true)
                   
                }
            }
    }
    
    func getCategories (userId:String, completion: @escaping(_ Status: Bool) -> Void) {
        let db = Firestore.firestore()
        db.collection("category").whereField("userId", isEqualTo: userId)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    completion(false)
                    print("Error getting documents: \(err)")
                } else {
                    self.categories.removeAll()
                    for document in querySnapshot!.documents {
                        let dicCat = document.data()
                        let objCat = TaskCategory.init(fromDictionary: dicCat)
                        self.categories.append(objCat)
                    }
                    completion(true)
                }
            }
        
//        for temp in self.categories{
//            let filteredArray = self.allTasks.filter({$0.categoryName == temp.name })
//            let newObj = customCategories(cateName: temp.name ?? "", array: filteredArray)
//            self.cateAgainstName.append(newObj)
//        }
//        self.colView.reloadData()
    }
    
    func getTaskAgainstCatNam() {
        
        
    }
}

extension HomeViewController2 : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if cateAgainstName.count >= 6{
            return 6
        } else if cateAgainstName.count == 0 {
            return 0
        } else {
            return cateAgainstName.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = colView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell2", for: indexPath) as? HomeCollectionViewCell2 else {
            return UICollectionViewCell()
        }
        
        let catObj = cateAgainstName[indexPath.row]
        cell.lblCatName.text = catObj.cateName
        cell.lblTaskCount.text = "\(catObj.array.count)"
        cell.catBgView.backgroundColor = UIColor(named: colCellColorArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let searchTaskVC = storyboard.instantiateViewController(identifier: "SeachTaskViewController") as! SeachTaskViewController
        searchTaskVC.selectedCategory = self.categories[indexPath.row]
        searchTaskVC.fromViewController = "CategoryVC"
        searchTaskVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(searchTaskVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        let spacing: CGFloat = 10.0 // Adjust the spacing between cells as needed
//        let totalSpacing = spacing * 3 // spacing * (numberOfCells - 1)
        let itemWidth = (collectionViewWidth - spacing) / 2
//        let itemHeight = collectionView.bounds.height
        return CGSize(width: itemWidth, height: 55)
    }
}

extension HomeViewController2: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allTasks.count
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "") { (action, view, completionHandler) in
            // Handle delete action here
            let alertController = UIAlertController(title: "Alert", message: "Are you sure you want to delete this task?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.destructive) {
                UIAlertAction in
//                self.deleteTaskAgainstId(taskId: self.filterSearchTasks[indexPath.row].id!) { status in
//                  if status {
//                      self.getTaskAgaintCategory()
//                  }
//              }
        }
          let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
                UIAlertAction in
        }
            // Add the actions
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)

          self.present(alertController, animated: true, completion: nil)
            completionHandler(true)
        }
        
        deleteAction.backgroundColor = .white
        deleteAction.image = UIImage(named: "delete")
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tblView.dequeueReusableCell(withIdentifier: "TaskCell2", for: indexPath) as? TaskCell2 else {
            return UITableViewCell()
        }
        
        let taskObje = self.allTasks[indexPath.row]
        if selectedIndex == indexPath.row {
            cell.lblDetail.isHidden = false
            cell.lblDetail.text = taskObje.description
        } else {
            cell.lblDetail.isHidden = true
            cell.lblDetail.text = ""
        }
        
        cell.taskViewBgColor.backgroundColor = UIColor(named: tbleCellColors[indexPath.row])
        if self.tbleCellColors[indexPath.row] == "task-cell-color-2" {
            cell.lbltitle.textColor = .white
            cell.lblCatName.textColor = .white
            cell.lblDetail.textColor = .white
            cell.lblTimeRange.textColor = .white
            cell.lblDueTime.textColor = .white
        } else {
            cell.lbltitle.textColor = UIColor(named: "TextColor")
            cell.lblCatName.textColor = UIColor(named: "TextColor")
            cell.lblDetail.textColor = UIColor(named: "TextColor")
            cell.lblTimeRange.textColor = UIColor(named: "TextColor")
            cell.lblDueTime.textColor = UIColor(named: "TextColor")
        }
        
        //line circle img settings
        if indexPath.row == 0 {
//            cell.constraintIineImgHeight.constant = 21
//            cell.constraintIineImgWidth.constant = 21
            cell.leftLineImg.image = UIImage(named: "task-left-line-img2")
        } else {
            cell.constraintIineImgHeight.constant = 17
            cell.constraintIineImgWidth.constant = 17
            cell.leftLineImg.image = UIImage(named: "task-left-line-img")
        }
        cell.lblCatName.text = taskObje.categoryName
        cell.lbltitle.text = taskObje.title
        cell.lblTimeRange.text = (taskObje.startTime ?? "no time") + " - " + (taskObje.endTime ?? "no time")
        self.labelAttributedString(cell.lblDueTime)
        cell.selectionStyle = .none
        return cell
    }
    
    func labelAttributedString(_ lblDue: UILabel) {
        
        let attributedString1 = NSAttributedString(string: "Due in ",attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0, weight: .regular)])
        let attributedString2 = NSAttributedString(string: "2 Hour", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0, weight: .semibold)])

        let mutableAttributedString = NSMutableAttributedString()
        mutableAttributedString.append(attributedString1)
        mutableAttributedString.append(attributedString2)
        lblDue.attributedText = mutableAttributedString
    }
    
    func setShadowForView() {
        
        self.bottomView.layer.shadowColor = UIColor.red.cgColor
        self.bottomView.layer.shadowOpacity = 0.5
        self.bottomView.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.bottomView.layer.shadowRadius = 4

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

class CustomButton: UIButton {
    // Customization properties
    var selectedColor: UIColor = UIColor(named: "btn-selection-color")!
    var deselectedBordrColor: UIColor = UIColor(named: "btn-Deselection-bordr-color")!
    var deselectedTitleColor: UIColor = UIColor(named: "btn-Deselection-title-color")!
//    var deSelectedBtmBorderColor: UIColor = .lightGray
    var bottomBorderHeight: CGFloat = 2.0
    
    // Track the selected state
    override var isSelected: Bool {
        didSet {
            updateButtonAppearance()
        }
    }
    
    // Update the button's appearance based on the selected state
    private func updateButtonAppearance() {
        
        if isSelected {
            setTitleColor(selectedColor, for: .normal)
            setBottomBorder(color: selectedColor, height: bottomBorderHeight)
        } else {
            setTitleColor(deselectedTitleColor, for: .normal)
            setBottomBorder(color: deselectedBordrColor, height: bottomBorderHeight)
        }

    }
    
    // Helper method to add a bottom border to the button
    private func setBottomBorder(color: UIColor, height: CGFloat) {
        let borderLayer = CALayer()
        borderLayer.backgroundColor = color.cgColor
        borderLayer.frame = CGRect(x: 0, y: bounds.height - height, width: bounds.width, height: height)
        layer.addSublayer(borderLayer)
    }
}


import UIKit

//class BottomView: UIView {
//
//    @IBInspectable var defaultHeight: CGFloat = 400.0 {
//            didSet {
//                updateViewHeight()
//            }
//        }
//
//        @IBInspectable var expandedHeight: CGFloat = UIScreen.main.bounds.height {
//            didSet {
//                updateViewHeight()
//            }
//        }
//
//
//     var isExpanded = false {
//        didSet {
//            updateViewHeight()
//        }
//    }
//
//    private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
//        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
//        return gestureRecognizer
//    }()
//
//    private lazy var panGestureRecognizer: UIPanGestureRecognizer = {
//        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
//        return gestureRecognizer
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupGestureRecognizers()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setupGestureRecognizers()
//    }
//
//    private func setupGestureRecognizers() {
//        addGestureRecognizer(tapGestureRecognizer)
//        addGestureRecognizer(panGestureRecognizer)
//    }
//
//    private func updateViewHeight() {
//        let newHeight = isExpanded ? expandedHeight : defaultHeight
//        frame.size.height = newHeight
//        superview?.layoutIfNeeded()
//    }
//
//    @objc private func handleTap() {
//        isExpanded = !isExpanded
//    }
//
//    @objc private func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
//        let translation = gestureRecognizer.translation(in: self)
//
//        switch gestureRecognizer.state {
//        case .changed:
//            let newHeight = max(defaultHeight + translation.y, defaultHeight)
//            frame.size.height = newHeight
//            superview?.layoutIfNeeded()
//        case .ended:
//            let shouldExpand = translation.y < -50.0 // Adjust the threshold as per your preference
//            isExpanded = shouldExpand
//        default:
//            break
//        }
//    }
//}
