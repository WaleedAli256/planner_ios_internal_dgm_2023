//
//  SettingViewController.swift
//  ToDoApp
//
//  Created by mac on 10/04/2023.
//

import UIKit
import StoreKit
import Firebase
import GoogleSignIn
import FirebaseFirestore
import MBProgressHUD

class SettingViewController: BaseViewController {

    @IBOutlet weak var profpic: UIImageView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var tblHeight: NSLayoutConstraint!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblemail: UILabel!
    let db = Firestore.firestore()
    var selectedIndex = -1
    var arrAllTasks = [Task]()
    var googleUserID = ""
//    var filterSearchTasks = [Task]()
//    var labelText = ["About","Rate us","Share app","Privacy policy","Login with Google"]
    var labelText = ["Rate us","Share app","Privacy policy"]
    
    var tblImages = ["icon-rate","icon-share","icon-privacy"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profpic.layer.cornerRadius = self.profpic.frame.size.width / 2
        self.profpic.clipsToBounds = true
        self.tblView.delegate = self
        self.tblView.dataSource = self
//        navigationController?.navigationBar.isTranslucent = false
//        if #available(iOS 15.0, *) {
//            let appearance = UITabBarAppearance()
//            appearance.configureWithOpaqueBackground()
//            appearance.backgroundColor = .black
//            // Set the appearance for normal state
//            tabBarController?.tabBar.standardAppearance = appearance
//            // Set the appearance for scrolled state
////            tabBarController?.tabBar.scrollEdgeAppearance = appearance
//        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setData()
        self.tblView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.tblView.removeObserver(self, forKeyPath: "contentSize")
        
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
    }
    func setData(){
        labelText = ["Rate us","Share app","Privacy policy"]
        tblImages = ["icon-rate","icon-share","icon-privacy"]
        
        if Utilities().getCurrentUser().userType == "0" || Utilities().getCurrentUser().userType == "2" {
            lblName.text = Utilities().getCurrentUser().name ?? ""
            lblemail.text = Utilities().getCurrentUser().email ?? ""

            tblImages.append("icon-signout")
//            tblImages.append("icon-signout")
            self.labelText.append("Sign Out")
            tblImages.append("icon-delete")
            self.labelText.append("Sign Out and Delete account")
//            self.labelText.append("Sign out and Delete User")
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
                    self.profpic.image = UIImage(data: data)
                }
            }
            
            // Start the data task
            task.resume()
            
        } else {
            lblName.text = "Guest User"
            lblemail.text = ""
            tblImages.append("icon-prof-2")
            self.labelText.append("Connect your account")
            self.profpic.image = UIImage(named: "icon-profile")
        }
        self.tblView.reloadData()
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){

        if(keyPath == "contentSize"){
            if(self.tblView.contentSize.height < 0)
            {
                self.tblHeight.constant = 100
            }
            else
            {
                self.tblHeight.constant = self.tblView.contentSize.height + 20
            }
        }
    }

    func shareMyApp() {
        
        if let urlStr = NSURL(string: "https://apps.apple.com/us/app/idxxxxxxxx?ls=1&mt=8") {
            let objectsToShare = [urlStr]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                if let popup = activityVC.popoverPresentationController {
                    popup.sourceView = self.view
                    popup.sourceRect = CGRect(x: self.view.frame.size.width / 2, y: self.view.frame.size.height / 4, width: 0, height: 0)
                }
            }
            
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    
    func openPrivacyPolicy() {
        
        guard let url = URL(string: "https://centumsolutions1.blogspot.com/2023/05/to-do-list.html") else {
                  return //be safe
                }
//           let url = URL(string: "https://centumsols.com/privacy-policy")
           if #available(iOS 13.0, *) {
               UIApplication.shared.open(url, options: [:], completionHandler: nil)
           } else {
               UIApplication.shared.openURL(url)
           }
        
    }
    
    func requestAppReview() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else {
            // Fallback for earlier iOS versions
            let appStoreReviewURL = "itms-apps://itunes.apple.com/app/[Your-App-ID]?action=write-review"
            if let url = URL(string: appStoreReviewURL) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    func loginGoogleAction() {
////
        self.checkInternetAvailability()
//        Utilities.show_ProgressHud(view: self.view)
        let signInConfig = GIDConfiguration.init(clientID: "359735858810-66jv9p5seorp32jkt1g3r3m4qtu5ogl0.apps.googleusercontent.com")
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else {
//                Utilities.hide_ProgressHud(view: self.view)
                self.showAlert(title: "Login with Google", message: "\(error?.localizedDescription ?? "Unable to signin at this moment")")
                return

            }
            guard let user = user else {
//                Utilities.hide_ProgressHud(view: self.view)
                self.showAlert(title: "Login with Google", message: "\(error?.localizedDescription ?? "Unable to Signin at this moment")")
                return

            }
            let userId = user.userID
            self.googleUserID = userId ?? ""
            let emailAddress = user.profile?.email
            let fullName = user.profile?.name
            let profilePicUrl = user.profile?.imageURL(withDimension: 320)?.absoluteString
            // If sign in succeeded, display the app's main content View.

            //Check if the user already exists
            
            let ref = self.db.collection("users").document(userId ?? "")
            ref.getDocument(completion: {(document,err) in
                if let document = document, document.exists {
                    //User already exists in our database
                    self.db.collection("users").document(userId ?? "").setData([
                        "id":userId ?? "",
                        "name": fullName ?? "",
                        "email": emailAddress ?? "",
                        "imageUrl": profilePicUrl ?? "",
                        "deviceType" : "iOS",
                        "userType" : "0",
                    ], merge: true) { err in
                        if let err = err {
                            print("Error adding document: \(err)")
                        } else {
                            self.userLoginParams(userId ?? "", fullName ?? "", emailAddress ?? "", "iOS", "0", profilePicUrl ?? "")
                        }
                    }
                }
                else
                {
                    // This  is a new user
                    self.db.collection("users").document(userId ?? "").setData([
                        "id":userId ?? "",
                        "name": fullName ?? "",
                        "email": emailAddress ?? "",
                        "imageUrl": profilePicUrl ?? "",
                        "deviceType" : "iOS",
                        "userType" : "0",
                    ]) { err in
                        if let err = err {
                            print("Error adding document: \(err)")
                        } else {
                            createDefaultsCategories(userId: userId!)
                            self.userLoginParams(userId ?? "", fullName ?? "", emailAddress ?? "", "iOS", "0", profilePicUrl ?? "")
                            
                        }
                    }
                }
            })
        }
    }
    
    func checkInternetAvailability() {
        guard Utilities.Connectivity.isConnectedToInternet else {
            self.showAlert(title: "Error", message: "Please check your internet connection")
                return
        }
    }
    
    func getallTaskAgainUser() {
//        Utilities.show_ProgressHud(view: self.view)
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
                    Utilities.hide_ProgressHud(view: self.view)
//                    if self.arrAllTasks.count > 0 {
//                        self.filterSearchTasks = self.arrAllTasks
//                        self.lblTaskCount.text = "Total Tasks: \(self.arrAllTasks.count)"
//                        self.tblView.reloadData()
//                    } else {
//                        self.showAlert(title: "Tasks", message: "No task available")
//                }
                    
            }
        }
    }
    
    func userLogout() {
        
        let alertController = UIAlertController(title: "Alert", message: "Are you sure you want to Sign Out", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.destructive) {
            UIAlertAction in
//            do {
//                self.checkInternetAvailability()
//                try Auth.auth().signOut()
//                // User is now signed out
//            } catch let signOutError as NSError {
//                self.showAlert(title: "Sign Out Error", message: "\(signOutError.localizedDescription)")
//                print("Error signing out: %@", signOutError)
//            }
            Utilities.setStringForKey(Constants.UserDefaults.currentUserExit, key: "NoUserExist")
            Utilities.setIsFirstTime(isFirstTime: false)
            Utilities.setStringForKey("true", key: "logout")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "InitialNavigationController") as! InitialNavigationController
            let window = UIApplication.shared.windows.first
            window?.rootViewController = vc
            window?.makeKeyAndVisible()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
              UIAlertAction in
             
          }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)

      self.present(alertController, animated: true, completion: nil)
        
    }
    
    func userLoginParams(_ userID: String, _ name: String, _ email: String, _ devicType: String, _ userTyp: String, _ profImgUrl: String) {
        let ref = db.collection("users").document(self.googleUserID)
        let dict = [
            "id": userID,
            "name": name,
            "email": email,
            "deviceType" : devicType,
            "userType" : userTyp,
            "image_url": profImgUrl
        ]
        let user = User.init(fromDictionary: dict)
        Utilities().setCurrentUser(currentUser: user)
        Utilities.setStringForKey(Constants.UserDefaults.currentUserExit, key: "userexist")
//         uncomment this below line according to the user already exit or not
//        ref.getDocument { document, error in
//            if document?.exists == false {
//                createDefaultsCategories(userId: user.id!)
//            }
//        }
        Utilities.hide_ProgressHud(view: self.view)
        self.tabBarController?.selectedIndex = 0
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
//        self.navigationController?.pushViewController(mainTabBarController, animated: true)
    }
    
    //account delettion
    
    
    func deleteUserAcount() {
        self.checkInternetAvailability()
        let alertController = UIAlertController(title: "User Deletion and Sign Out Alert", message: "Are you sure you want to Sign Out and Delete your account?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.destructive) {
            UIAlertAction in
            
            Utilities.setStringForKey(Constants.UserDefaults.currentUserExit, key: "NoUserExist")
            Utilities.setIsFirstTime(isFirstTime: false)
            Utilities.setStringForKey("true", key: "logout")
            self.deleteUserData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
              UIAlertAction in
             
          }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)

      self.present(alertController, animated: true, completion: nil)
    }
    
    func deleteAllTaskAndCategories(completion: @escaping(_ status: Bool) -> Void) {
        var taskIds = [String]()
        let db = Firestore.firestore()
        //remove all tasks against a user
        db.collection("tasks").whereField("userId", isEqualTo: Utilities().getCurrentUser().id ?? "").getDocuments {(querySnapshot , err) in
            if let err = err {
                completion(false)
//                print("Error removing document: \(err)")
                self.showAlert(title: "Error", message: "Error removing document: \(err)")
            } else {
                guard let documents = querySnapshot?.documents else { return }
                       for document in documents {
                           let data = document.data()
                           if let task = data["id"] as? String{
                               taskIds.append(task)
                           }
//                           taskIds.append(document.documentID)
                           document.reference.delete()
                }
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: taskIds)
                print("removed all tasks")
                
                //remove all categories against a user
                db.collection("category").whereField("userId", isEqualTo: Utilities().getCurrentUser().id ?? "").getDocuments {(querySnapshot , err) in
                    if let err = err {
        //                print("Error removing document: \(err)")
                        completion(false)
                        self.showAlert(title: "Error", message: "Error removing document: \(err)")
                    } else {
                        guard let documents = querySnapshot?.documents else { return }
                               for document in documents {
                                   document.reference.delete()
                        }
                        completion(true)
                        print("Removed all categories")
                    }
                }
            }
        }
        
    }
    
    
    func deleteUserData() {
        self.checkInternetAvailability()
        self.deleteAllTaskAndCategories { status in
            if status {
                Utilities.show_ProgressHud(view: self.view)
                guard let currentUser = Auth.auth().currentUser else {
                    print("No user is currently logged in.")
        
                    Utilities.hide_ProgressHud(view: self.view)
                    return
                }
                
                // Delete user data from Firebase Authentication
                currentUser.delete { error in
                    if let error = error {
                        Utilities.hide_ProgressHud(view: self.view)
                        print("Failed to delete user: \(error.localizedDescription)")
                        cAlert.ShowAlerTost(VC: self, title: "", msg: error.localizedDescription)
                        return
                    }
                    
                    print("User deleted successfully from Firebase Authentication.")
                    
                    // Delete user data from Firestore
                    let db = Firestore.firestore()
                    let userDocRef = db.collection("users").document(Utilities().getCurrentUser().id ?? "")
                    
                    userDocRef.delete { error in
                        if let error = error {
                            print("Failed to delete user data from Firestore: \(error.localizedDescription)")
                            Utilities.hide_ProgressHud(view: self.view)
                            guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
                                return
                            }
                            sceneDelegate.setLoginVC()
                            return
                        }
                        Utilities.hide_ProgressHud(view: self.view)
                        Utilities.setStringForKey("", key: "uid")
                        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
                            return
                        }
                        sceneDelegate.setLoginVC()
                        print("User data deleted successfully from Firestore.")
                    }
                }
            }
        }
    }
    

//    func deleteUserData() {
//        Utilities.show_ProgressHud(view: self.view)
//        self.deleteAllTaskAndCategories(completion: { status in
//            if status {
//                let db = Firestore.firestore()
//                let userDocRef = db.collection("users").document(Utilities().getCurrentUser().id ?? "")
//
//                userDocRef.delete { error in
//                    if let error = error {
//                        Utilities.hide_ProgressHud(view: self.view)
//                        print("Failed to delete user data from Firestore: \(error.localizedDescription)")
//                        self.showAlert(title: "Error", message: "\(error.localizedDescription)")
//
//                        return
//                    }
//                    print("User data deleted successfully from Firestore.")
//                }
//
//                guard let currentUser = Auth.auth().currentUser else {
//                    print("No user is currently logged in.")
//        //            activityIndicator.stopAnimating()
//                    Utilities.hide_ProgressHud(view: self.view)
//                    return
//                }
//
//                // Delete user data from Firebase Authentication
//                currentUser.delete { error in
//                    if let error = error {
//        //                self.activityIndicator.stopAnimating()
//                        Utilities.hide_ProgressHud(view: self.view)
//                        print("Failed to delete user: \(error.localizedDescription)")
//                        self.showAlert(title: "Error", message: "Failed to delete user: \(error.localizedDescription)")
//                        return
//                    }
//
//                    print("User deleted successfully from Firebase Authentication.")
//                    // Delete user data from Firestore
//
//                }
//
//            }
//        })
//
//
//    }
            
}



extension SettingViewController: UITableViewDelegate,UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.labelText.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tblView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as? SettingsCell else {
            return UITableViewCell()
        }
        
        cell.aboutlbl.text = labelText[indexPath.row]
        cell.iconImg.image = UIImage(named: tblImages[indexPath.row])
//        if selectedIndex == indexPath.row {
//            cell.aboutlbl.textColor = UIColor.white
//            cell.iconImg.tintColor = UIColor.white
//            cell.innerView.backgroundColor = UIColor(named: "primary-color")
//            cell.dividerView.backgroundColor = UIColor(named: "low-color")?.withAlphaComponent(0.2)
//            cell.selectionStyle = .none
//        }else{
//            cell.aboutlbl.textColor = UIColor.black
//            cell.iconImg.tintColor = UIColor(named: "primary-color")
//            cell.innerView.backgroundColor = UIColor(named: "ViewBGLight")
//            cell.dividerView.backgroundColor = UIColor(named: "low-color")
//
//
//        }
       
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if selectedIndex == indexPath.row {
            selectedIndex = -1
        } else {
            selectedIndex = indexPath.row
        }
//        if indexPath.row == 0 {
//            let controller = self.storyboard?.instantiateViewController(withIdentifier: "AboutUsViewController") as! AboutUsViewController
//            self.navigationController?.pushViewController(controller, animated: true)
//
//        } else
        if indexPath.row == 0 {
//            self.requestAppReview()
            SKStoreReviewController.requestReview()
            
//            let isDarkMode = traitCollection.userInterfaceStyle == .dark
//                let newInterfaceStyle: UIUserInterfaceStyle = isDarkMode ? .light : .dark
//                UIApplication.shared.keyWindow?.overrideUserInterfaceStyle = newInterfaceStyle
            
        } else if indexPath.row == 1 {
            self.shareMyApp()
        } else if indexPath.row == 2 {
            self.openPrivacyPolicy()
        } else if indexPath.row == 3 {
            if labelText[indexPath.row] != "Sign Out"{
//                loginGoogleAction()
                guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
                    return
                }
                do {
                    self.checkInternetAvailability()
                    try Auth.auth().signOut()
                    // User is now signed out
                } catch let signOutError as NSError {
                    self.showAlert(title: "Sign Out Error", message: "\(signOutError.localizedDescription)")
                    print("Error signing out: %@", signOutError)
                }
                sceneDelegate.setLoginVC()

                
            }else{
                userLogout()
            }
            
        }  else if indexPath.row == 4 {
//            self.deleteUserData()
            self.deleteUserAcount()
        }
        self.tblView.reloadData()
    }
}


class SettingsCell: UITableViewCell {
        
    @IBOutlet weak var aboutlbl: UILabel!
    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var dividerView: UIView!
    @IBOutlet weak var innerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
