//
//  HomeViewController.swift
//  ToDoApp
//
//  Created by mac on 07/04/2023.
//
import UIKit
import Firebase
import FirebaseFirestore
import GoogleMobileAds

class HomeViewController: UIViewController, CustomSegmentedControlDelegate {
    
    @IBOutlet weak var colView: UICollectionView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var calendrBtnView: UIView!
    @IBOutlet weak var lblDateWithYear: UILabel!
    
    private var datePicker: UIDatePicker?
    var myDateWithYear = ""
    private var selectedDate = MonthYear()
    
    // High-sized banner view
    var highBannerView: GADBannerView!
        
        // Medium-sized banner view
    var mediumBannerView: GADBannerView!
        
        // All-sized banner view
    var allBannerView: GADBannerView!
    var workItem: DispatchWorkItem?
    @IBOutlet weak var interfaceSegmented: CustomSegmentedControl!{
        didSet{
            interfaceSegmented.setButtonTitles(buttonTitles: ["Daily","Weekly","Monthly","Yearly"])
            interfaceSegmented.selectorViewColor = UIColor(named: "primary-color")!
            interfaceSegmented.selectorTextColor = UIColor(named: "TextColor-2")!
        }
    }
    
    let dailyTime = ["12 AM", "1 AM", "2 AM", "3 AM", "4 AM", "5 AM", "7 AM", "8 AM", "9 AM", "10 AM", "11 AM", "12 PM", "1 PM", "2 PM", "3 PM", "4 PM", "5 PM", "6 PM", "7 PM", "8 PM", "9 PM", "10 PM", "11 PM"]
    
    let dailyDays = ["Yesterday","Today","Tommorow"]
    
    let weeklyDays = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
    
    var monthlyDays: Int = 0
    
    var selectedTab = 0
    var centerCell: HomeCollectionViewCell?
    var tableCenterCell: HomeTableViewCell?
    var selectedTableIndex = -1
    var selectedCollectionIndex = -1
    var catName = ""
    var dailySelected = 1
    var weeklySelected = 1
    var monthlySelected = 1
    var yearlySelected = 1
    
    var allTasks: [Task] = []
    var bannerView: GADBannerView!
    var selectedDayTasks:[Task] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utilities.setStringForKey(Constants.UserDefaults.currentUserExit, key: "NoUserExist")
        Utilities.setIsFirstTime(isFirstTime: false)
        Utilities.setStringForKey("false", key: "logout")
        
        let calendar = Calendar.current
          let date = Date()
          let components = calendar.dateComponents([.month, .year], from: date)
        let month = components.month!
        let year = components.year!
        if let days = numberOfDays(inMonth: month, year: year) {
            print("Number of days in the month: \(days)")
            self.monthlyDays = days
        } else {
            print("Invalid month or year.")
        }
        // In this case, we instantiate the banner with desired ad size.
//        bannerView = GADBannerView(adSize: GADAdSizeBanner)
//        bannerView.adUnitID = "ca-app-pub-8414160375988475/6353645343"
//        bannerView.rootViewController = self
//        bannerView.delegate = self
//        bannerView.load(GADRequest())
//         addBannerViewToView(bannerView)
//        loadHighAd()
//
//        mediumBannerView = GADBannerView(adSize: GADAdSizeBanner)
//        mediumBannerView.adUnitID = "ca-app-pub-8414160375988475/8701958152"
//        mediumBannerView.rootViewController = self
//        mediumBannerView.load(GADRequest())
//         addBannerViewToView(mediumBannerView)
//
//        allBannerView = GADBannerView(adSize: GADAdSizeBanner)
//        allBannerView.adUnitID = "ca-app-pub-8414160375988475/5012643512"
//        allBannerView.rootViewController = self
//        allBannerView.load(GADRequest())
//         addBannerViewToView(allBannerView)
                
       
        let dateTap = UITapGestureRecognizer(target: self, action: #selector(showDatePicker))
        calendrBtnView.addGestureRecognizer(dateTap)
        
        self.calendrBtnView.isHidden = true
        self.tabBarController?.delegate = self
        
        self.tblView.delegate = self
        self.tblView.dataSource = self

        self.colView.delegate = self
        self.colView.dataSource = self
        
        self.colView.clipsToBounds = true
        self.colView.layer.cornerRadius = 4
        self.interfaceSegmented.delegate = self
        HomeTableViewCell.onDoneBlock = { catName,collectionIndex, tableIndex, sucess in
            self.catName = catName
            self.selectedTableIndex = tableIndex
            self.selectedCollectionIndex = collectionIndex
            print(collectionIndex)
            print(tableIndex)
            self.tblView.reloadData()
        }
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.navigationController?.navigationBar.isHidden = true
    }
    
    func numberOfDays(inMonth month: Int, year: Int) -> Int? {
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1

        guard let date = calendar.date(from: components) else {
            return nil
        }

        let range = calendar.range(of: .day, in: .month, for: date)
        return range?.count
    }
    
    func loadHighAd() {
          let request = GADRequest()
          bannerView.load(request)
        addBannerViewToView(bannerView)
      }
      
      func loadMediumAd() {
          
          bannerView.adUnitID = "ca-app-pub-8414160375988475/8701958152"
          let request = GADRequest()
          bannerView.load(request)
          addBannerViewToView(bannerView)
      }
      
      func loadAllAd() {
          bannerView.adUnitID = "ca-app-pub-8414160375988475/5012643512"
          let request = GADRequest()
          bannerView.load(request)
          addBannerViewToView(bannerView)
      }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        bannerView.isAutoloadEnabled = true
        
        view.addSubview(bannerView)
        view.addConstraints(
          [NSLayoutConstraint(item: bannerView,
                              attribute: .bottom,
                              relatedBy: .equal,
                              toItem: view.safeAreaLayoutGuide,
                              attribute: .bottom,
                              multiplier: 1,
                              constant: 0),
           NSLayoutConstraint(item: bannerView,
                              attribute: .centerX,
                              relatedBy: .equal,
                              toItem: view,
                              attribute: .centerX,
                              multiplier: 1,
                              constant: 0)
          ])
       }
    
//    func addIntertitial(_ interAdds: GADInterstitialAd! ,_ addId: String) {
//
//        var addsInter: GADInterstitialAd!
//        addsInter = interAdds
//
//        let request = GADRequest()
//         GADInterstitialAd.load(withAdUnitID: addId,
//                                     request: request,
//                           completionHandler: { [self] ad, error in
//                             if let error = error {
//                               print("Failed to load interstitial ad with error: \(error.localizedDescription)")
//                               return
//                             }
//                        addsInter = ad
//                        addsInter!.fullScreenContentDelegate = self
//                }
//         )
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        getTaskAgaintCategory()
        self.getAllTasks(userId: Utilities().getCurrentUser().id ?? "")
    
    }
    
    @objc private func showDatePicker() {
        let minDate = MonthYear()
        minDate.year -= 1
        let maxDate = MonthYear()
        maxDate.year += 50
        MonthYearPickerViewController.present(vc: self, minDate: minDate, maxDate: maxDate, selectedDate: selectedDate, onDateSelected: onDateSelected)
        
        
    }
    var selectdYearAndMonth = Date()
    private func onDateSelected(month: Int, year: Int) {
//        DateComponents
        let todayDate = Date()
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: todayDate)
        dateComponents.year = year
        dateComponents.month = month
        selectdYearAndMonth = Calendar.current.date(from: dateComponents)!
        
        getDateAfterSelection(segmentIndex: 3)
        
        selectedDate = MonthYear(month: month, year: year)
        let numberDate = formatMonthYear(date: selectedDate)
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "MM/yyyy"
        let date = inputFormatter.date(from: numberDate)
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMM-yyyy"
        let formattedDateString = outputFormatter.string(from: date!)
        let monthis = String(formattedDateString.prefix(3))
        let yearis = String(formattedDateString.suffix(2))
        self.lblDateWithYear.text = "\(monthis)-\(yearis)"
        monthlyDays = self.numberOfDays(inMonth: selectedDate.month, year: selectedDate.year)!
//        self.tblView.reloadData()
        self.colView.reloadData()
        
//        let yearis = lblDateWithYear.text?.suffix(<#T##maxLength: Int##Int#>)
    }
    
    
    private func formatMonthYear(date: MonthYear) -> String {
        
        return date.month < 10 ? "0\(date.month)/\(date.year)" : "\(date.month)/\(date.year)"
    }
    
    func getAllTasks(userId:String) {
        self.allTasks.removeAll()
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
                        self.allTasks.append(objCat)
                        self.selectedDayTasks = []
                    }
                    self.getTasks()
                    self.tblView.reloadData()
                }
            }
    }
    func scrollMyCollectionView(row : Int){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) { // Change `2.0` to the
            var mySelectedIndexPath = IndexPath(row: 0, section: 0)
            mySelectedIndexPath = IndexPath(row: row, section: 0)
            self.colView.scrollToItem(at: mySelectedIndexPath, at: .centeredHorizontally, animated: true)
        }
    }
    func change(to index: Int) {
        self.selectedTab = index
        let todayDate = Date()
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: todayDate)
        print(dateComponents)
        dailySelected = 1
        monthlySelected = dateComponents.day! - 1
        yearlySelected = dateComponents.day! - 1
        if index == 0{
            
        }else if index == 1{ //weekly seleted
            let dayNumber = Calendar.current.component(.weekday, from: todayDate)
            print(dayNumber)
            weeklySelected = dayNumber - 1
            self.scrollMyCollectionView(row: self.weeklySelected)
        }else{
            self.scrollMyCollectionView(row: self.monthlySelected)
            
            
        }
        self.colView.reloadData()
        self.filterTasks(filteredDate: todayDate)
    }
    func getDateAfterSelection(segmentIndex : Int){
        var todayDate = Date()
        if segmentIndex == 0{ //daily Selection
           
            if dailySelected == 0{
                todayDate = Calendar.current.date(byAdding: .day, value: -1, to: todayDate)!
            }else if dailySelected == 1{
                todayDate = Date()
            }else{
                todayDate = Calendar.current.date(byAdding: .day, value: 1, to: todayDate)!
            }
           
        }else if segmentIndex == 1{
            
        }else if segmentIndex == 2{
            var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: todayDate)
            dateComponents.day = monthlySelected + 1
            todayDate = Calendar.current.date(from: dateComponents)!
            
        }else if segmentIndex == 3{
            var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: todayDate)
            
            let tempDateCom = Calendar.current.dateComponents([.year, .month], from: selectdYearAndMonth)
            
            dateComponents.year = tempDateCom.year
            dateComponents.month = tempDateCom.month
            dateComponents.day = yearlySelected + 1
            todayDate = Calendar.current.date(from: dateComponents)!
            
            
        }
        filterTasks(filteredDate: todayDate)
    }
    func filterTasks(filteredDate : Date){
        let myDateStr = convertDateFormate(filteredDate)
        selectedDayTasks = arrAllTasks.filter ({$0.time == myDateStr})
        self.tblView.reloadData()
        
    }
    var arrAllTasks = [Task]()
    func getTaskAgaintCategory() {
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
                }
            }
        
       
    }
    func filterDailyTasks(day:Int, task:Task) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy h:mm a"

        var taskDate = Date()
        if let date = dateFormatter.date(from: task.date ?? "") {
            taskDate = date
            print(date)
        } else {
            print("Invalid date format")
            return
        }
        
        let calendar = Calendar.current
        
        if day == 0 {
            if calendar.isDateInYesterday(taskDate) {
                print("Given date is yesterday")
                self.selectedDayTasks.append(task)
            }
        } else if day == 1 {
            if calendar.isDateInToday(taskDate) {
                print("Given date is today")
                self.selectedDayTasks.append(task)
            }
        } else {
            if calendar.isDateInTomorrow(taskDate) {
                print("Given date is tomorrow")
                self.selectedDayTasks.append(task)
            }
        }
    }
    func filterWeeklyTasks(day:Int, task:Task) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy h:mm a"

        var taskDate = Date()
        if let date = dateFormatter.date(from: task.date ?? "") {
            taskDate = date
            print(date)
        } else {
            print("Invalid date format")
            return
        }
        
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: taskDate)

        if day == 1 && weekday == 2 {
            self.selectedDayTasks.append(task)
        }
        
        if day == 2 && weekday == 3 {
            self.selectedDayTasks.append(task)
        }
        
        if day == 3 && weekday == 4 {
            self.selectedDayTasks.append(task)
        }
        
        if day == 4 && weekday == 5 {
            self.selectedDayTasks.append(task)
        }
        
        if day == 5 && weekday == 6 {
            self.selectedDayTasks.append(task)
        }
        
        if day == 6 && weekday == 7 {
            self.selectedDayTasks.append(task)
        }
        
        if day == 7 && weekday == 1 {
            self.selectedDayTasks.append(task)
        }
    }
    
    func filterMonthlyTasks(day:Int, task:Task) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy h:mm a"

        var taskDate = Date()
        if let date = dateFormatter.date(from: task.date ?? "") {
            taskDate = date
            print(date)
        } else {
            print("Invalid date format")
            return
        }
        
        let calendar = Calendar.current
        let taskDay = calendar.component(.day, from: taskDate)

        if day == taskDay {
            self.selectedDayTasks.append(task)
        }
        print("Day: \(day)")
    }
    
    func filterYearlyTasks(day:Int, task:Task) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy h:mm a"

        var taskDate = Date()
        if let date = dateFormatter.date(from: task.date ?? "") {
            taskDate = date
            print(date)
        } else {
            print("Invalid date format")
            return
        }
        
        let calendar = Calendar.current
        let taskDay = calendar.component(.day, from: taskDate)

        if day == taskDay {
            self.selectedDayTasks.append(task)
        }
        print("Day: \(day)")
    }

    @IBAction func searchBtnAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let searchTaskVC = storyboard.instantiateViewController(identifier: "SeachTaskViewController") as! SeachTaskViewController
        searchTaskVC.fromViewController = "HomeVC"
        self.navigationController?.pushViewController(searchTaskVC, animated: true)
    }
    
    private func setupDatePicker() {
        let picker = datePicker ?? UIDatePicker()
        picker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        }
        
        picker.addTarget(self, action: #selector(dueDateChanged(sender:)), for: .valueChanged)
        let size = self.view.frame.size
        picker.frame = CGRect(x: 0.0, y: size.height - 200, width: size.width, height: 200)
        picker.backgroundColor = UIColor.white
        
        self.datePicker = picker
        self.view.addSubview(self.datePicker!)
    }

    @objc func dueDateChanged(sender:UIDatePicker){
        self.myDateWithYear = self.lblDateWithYear.text!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM-yy"
        let date = dateFormatter.date(from: self.lblDateWithYear.text!)
        print(date)
        
        
//        dateFilter.setTitle(dateFormatter.string(from: senderse.date), for: .normal)
    }
}


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.selectedTab == 0 {
            self.calendrBtnView.isHidden = true
            return self.dailyDays.count
        } else if self.selectedTab == 1 {
            self.calendrBtnView.isHidden = true
            return self.weeklyDays.count
        } else if self.selectedTab == 2 {
            self.calendrBtnView.isHidden = true
            return self.monthlyDays
        } else {
            self.calendrBtnView.isHidden = false
            return self.monthlyDays
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = colView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as? HomeCollectionViewCell else {
            return UICollectionViewCell()
        }
        var value = ""
        if self.selectedTab == 0 {
            value = self.dailyDays[indexPath.row]
        } else if self.selectedTab == 1 {
            value = self.weeklyDays[indexPath.row]
            
        } else {
            value = "\(indexPath.row + 1)"
        }
        cell.transformCellToStandard()
        if self.selectedTab == 0 {
            if indexPath.row == self.dailySelected {
                cell.transformCellToLarge()
            } else {
                cell.transformCellToStandard()
            }
            
        }  else if self.selectedTab == 1 {
            if indexPath.row == self.weeklySelected {
                cell.transformCellToLarge()
            } else {
                cell.transformCellToStandard()
            }
        }  else if self.selectedTab == 2 {
            if indexPath.row == self.monthlySelected {
                cell.transformCellToLarge()
            } else {
                cell.transformCellToStandard()
            }
        }  else if self.selectedTab == 3 {
            if indexPath.row == self.yearlySelected {
                cell.transformCellToLarge()
            } else {
                cell.transformCellToStandard()
            }
        }
        
        
        cell.dayLbl.text = value
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
//        workItem?.cancel()
        DispatchQueue.main.sync {
            self.centerCell = self.colView.cellForItem(at: indexPath) as? HomeCollectionViewCell
            
            self.centerCell?.transformCellToLarge()
            for cell in collectionView.visibleCells {
                (cell as? HomeCollectionViewCell)?.transformCellToStandard()
            }
            self.centerCell?.transformCellToLarge()
        }
        
        if self.selectedTab == 0 {
            self.dailySelected = indexPath.row
            self.getDateAfterSelection(segmentIndex: selectedTab)
            
        }  else if self.selectedTab == 1 {
            self.weeklySelected = indexPath.row
            getDateFromSelectedWeekday(selectedDay: indexPath.row+1)
        }  else if self.selectedTab == 2 {
            
            self.monthlySelected = indexPath.row
            self.getDateAfterSelection(segmentIndex: selectedTab)
        }  else if self.selectedTab == 3 {
            self.yearlySelected = indexPath.row
            self.getDateAfterSelection(segmentIndex: selectedTab)
            
        }
       
       
//        self.getTasks()
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.selectedTab == 0 {
            let width  = (collectionView.frame.width)/3
            return CGSize(width: width, height: collectionView.frame.height)
        } else if self.selectedTab == 1 {
            let width  = (collectionView.frame.width)/7 + 10
            return CGSize(width: width, height: collectionView.frame.height)
        } else {
            let width  = (collectionView.frame.width)/9
            return CGSize(width: width, height: collectionView.frame.height)
        }
    }
    
    func getTasks() {
        self.selectedDayTasks.removeAll()
        for tsk in self.allTasks {
            if self.selectedTab == 0 {
                self.filterDailyTasks(day: self.dailySelected, task: tsk)
            }  else if self.selectedTab == 1 {
                self.filterWeeklyTasks(day: self.weeklySelected + 1, task: tsk)
            }  else if self.selectedTab == 2 {
                self.filterMonthlyTasks(day: self.monthlySelected + 1, task: tsk)
            }  else if self.selectedTab == 3 {
                self.filterYearlyTasks(day: self.yearlySelected + 1, task: tsk)
            }
        }
//        self.updateValues = true
        self.tblView.reloadData()
    }
}

extension HomeViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dailyTime.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as! HomeTableViewCell
        cell.catName = self.catName
        cell.index = indexPath
        cell.selectedTableIndex = selectedTableIndex
        cell.selectedCollectionIndex = selectedCollectionIndex
        cell.colView.reloadData()
        if indexPath.row == selectedTableIndex {
            cell.tasksStackView.isHidden = false
//            cell.transformCellToLarge()
//            cell.timeLbl.font = UIFont.boldSystemFont(ofSize: 14)
            cell.colView.reloadData()
        }else{
//            cell.transformCellToStandard()
            cell.tasksStackView.isHidden = true
        }
        cell.transformCellToStandard()
        cell.timeLbl.text = self.dailyTime[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy h:mm a"

//        if self.updateValues {
//            if indexPath.row == self.dailyTime.count - 1 {
//                self.updateValues = false
//            }
        let finalTask = self.selectedDayTasks.filter { task in
            if let date = dateFormatter.date(from: task.date ?? "") {
                let formatter = DateFormatter()
                formatter.dateFormat = "h a"
                let hour = formatter.string(from: date)
                return hour == self.dailyTime[indexPath.row]
            }
            return false
        }
        cell.myFinalCategories.removeAll()// = [:]
        for item in finalTask {
            if cell.myFinalCategories[item.categoryName!] == nil{
                cell.myFinalCategories[item.categoryName!] = [item]
            }else{
                cell.myFinalCategories[item.categoryName!]!.append(item)
            }
        }
        cell.tasks.removeAll()// = []
        for dic in cell.myFinalCategories{
            let task = (dic.value as? [Task])!
            cell.tasks.append(CatTasks(catName: dic.key, tasks: task))
        }
        for view in cell.tasksStackView.subviews {
            view.removeFromSuperview()
        }
        
                for cat in cell.tasks {
                    if cat.catName == self.catName{
                        for task in cat.tasks {
                            
                            cell.loadTaskView(tag: 1, task: task)
                        }
                    }

                }
        
//        if self.selectedCollectionIndex != -1  && cell.tasks.count > 0 {
//            let taskss = cell.tasks[self.selectedCollectionIndex]
//            for teve in taskss.tasks {
//                cell.loadTaskView(tag: 1, task: teve)
//            }
//        }
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension HomeViewController: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
            // Perform actions when tab bar index changes, e.g., call a method, update UI, etc.
//        self.getAllTasks(userId: Utilities().getCurrentUser().id ?? "")
            print("Tab bar index changed to \(tabBarController.selectedIndex)")
        }
    
    func getDateFromSelectedWeekday(selectedDay : Int) {
        
        var todayDate = Date()
        let dayNumber = Calendar.current.component(.weekday, from: todayDate)
        let numberOfDays = selectedDay - dayNumber
        todayDate = Calendar.current.date(byAdding: .day, value: numberOfDays, to: todayDate)!
        
        filterTasks(filteredDate: todayDate)
    }
}

extension HomeViewController: GADBannerViewDelegate {
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
//        self.loadMediumAd()
        
    }
    
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        
//        if bannerView == highBannerView {
//            print("high")
//        } else if bannerView == mediumBannerView {
//            print("med")
//        } else if bannerView == allBannerView {
//            print("all")
//        }
    }
    
}

