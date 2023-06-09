//
//  InitialViewController.swift
//  ToDoApp
//
//  Created by mac on 12/04/2023.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseFirestore

class InitialViewController: BaseViewController {
    
    @IBOutlet weak var btnSkip: UIButton!
    let db = Firestore.firestore()
    var isButtonTapped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSkip.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc func buttonTapped() {
    
            btnSkip.isEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 8.0) {
                self.btnSkip.isEnabled = true
        }
    }


    @IBAction func loginGoogleAction(_ sender: UIButton) {
////
            self.btnSkip.tag = 0
            self.checkInternetAvailability()
            Utilities.show_ProgressHud(view: self.view)

            let signInConfig = GIDConfiguration.init(clientID: "359735858810-66jv9p5seorp32jkt1g3r3m4qtu5ogl0.apps.googleusercontent.com")
            GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
                guard error == nil else {
                    Utilities.hide_ProgressHud(view: self.view)
                    self.showAlert(title: "Login with Google", message: "\(error?.localizedDescription ?? "Unable to signin at this moment")")
                    return

                }
                guard let user = user else {
                    Utilities.hide_ProgressHud(view: self.view)
                    self.showAlert(title: "Login with Google", message: "\(error?.localizedDescription ?? "Unable to signin at this moment")")
                    return

                }
                let userId = user.userID
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
                            "isAnonmusUser" : "0",
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
                            "isAnonmusUser" : "0",
                        ]) { err in
                            if let err = err {
                                print("Error adding document: \(err)")
                            } else {
                                createDefaultsCategories(userId: userId ?? "")
                                self.userLoginParams(userId ?? "", fullName ?? "", emailAddress ?? "", "iOS", "0", profilePicUrl ?? "")
                                
                            }
                        }
                    }
                })
        }
//
    }
    
    
    @IBAction func skipAction(_ sender: UIButton) {
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let mainTabBarController = storyboard.instantiateViewController(identifier: "SeachTaskViewController") as SeachTaskViewController
//        self.navigationController?.pushViewController(mainTabBarController, animated: true)
        
        self.btnSkip.tag = 1
        Utilities.show_ProgressHud(view: self.view)
        self.checkInternetAvailability()

        var userUID = ""
        let db = Firestore.firestore()
        Auth.auth().signInAnonymously { authResult, error in
            userUID = (authResult?.user.uid)!
            let ref = db.collection("users").document(userUID ?? "")
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
            } else {
                ref.getDocument(completion: {(document,err) in
                    if let document = document, document.exists {
                        //User already exists in our database
                        self.db.collection("users").document(authResult?.user.uid ?? "").setData([
                            "id": userUID,
                            "name": "Anonymous user",
                            "email": "email",
                            "deviceType" : "iOS",
                            "isAnonmusUser" : "1",
                            "image_url": "profilePicUrl"

                        ], merge: true) { err in
                            if let err = err {
                                print("Error adding document: \(err)")
                            } else {
                                self.userLoginParams(userUID, "Annomous user", "email", "iOS", "1", "profilePicUrl")
                            }
                        }
                    }
                    else
                    {
                        // This  is a new user
                        self.db.collection("users").document(userUID ?? "").setData([
                            "id": userUID,
                            "name": "Annomous User",
                            "email": "email",
                            "deviceType" : "iOS",
                            "isAnonmusUser" : "0",
                            "image_url": "profilePicUrl"

                        ]) { err in
                            if let err = err {
                                print("Error adding document: \(err)")
                            } else {
                                createDefaultsCategories(userId: userUID)
                                self.userLoginParams(userUID, "Annomous user", "Annoumous user email is not exist", "iOS", "1", "profilePicUrl")

                            }
                        }
                    }
                })

            }
        }
    }
    
    func userLoginParams(_ userID: String, _ name: String, _ email: String, _ devicType: String, _ userTyp: String, _ profImgUrl: String) {
//        let ref = self.db.collection("users").document(self.firebaseUserId)
        let dict = [
            "id": userID,
            "name": name,
            "email": email,
            "deviceType" : devicType,
            "isAnonmusUser" : userTyp,
            "image_url": profImgUrl
        ]
        let user = User.init(fromDictionary: dict)
        Utilities().setCurrentUser(currentUser: user)
        Utilities.setStringForKey(Constants.UserDefaults.currentUserExit, key: "userexist")
        // uncomment this below line according to the user already exit or not
//        ref.getDocument { document, error in
//            if document?.documentID != user.id {
//
//            }
//        }
//        if Utilities.getStringForKey("userexist") != Constants.UserDefaults.currentUserExit {
//            createDefaultsCategories(userId: user.id!)
//        }
        if self.btnSkip.tag == 1 {
            Utilities.setIntForKey(1, key: "isAnonmusUser")
        } else {
            Utilities.setIntForKey(0, key: "isAnonmusUser")
        }
        Utilities.hide_ProgressHud(view: self.view)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
               return
           }
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
               return
           }
        sceneDelegate.setHomeVC()
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController") as TabBarViewController
//            .window?.rootViewController = 
            
    }
    
    func checkInternetAvailability() {
        guard Utilities.Connectivity.isConnectedToInternet else {
            Utilities.hide_ProgressHud(view: self.view)
            self.showAlert(title: "Error", message: "Please check your internet connection")
                return
        }
    }
    
    
}

func createDefaultsCategories(userId:String) {
    
    var categories = [TaskCategory]()
    let first = TaskCategory(image: 1, userId: userId, description: "Keep yourself hydrated all time!", name: "Water Intake", taskCount: "0", id: "", colorCode: "#5486E9")
    let sec = TaskCategory(image: 2, userId: userId, description: "Wake up on the time So you never late!", name: "Sleeping Schedule", taskCount: "0", id: "", colorCode: "#F1A800")
    let third = TaskCategory(image: 3, userId: userId, description: "Never miss an Event to wish to your loved ones", name: "Event Reminder", taskCount: "0", id: "", colorCode: "#FFB185")
    let fourth = TaskCategory(image: 4, userId: userId, description: "Schedule your Exercise to stay healthy", name: "Exercise Schedule", taskCount: "0", id: "", colorCode: "#E784D1")
    let fifth = TaskCategory(image: 5, userId: userId, description: "Keep yourself hydrated all time!", name: "Food Intake", taskCount: "0", id: "", colorCode: "#76DC80")
    let sixth = TaskCategory(image: 6, userId: userId, description: "Wake up on the time So you never late!", name: "Personal Care", taskCount: "0", id: "", colorCode: "#51BBA2")
    categories.append(first)
    categories.append(sec)
    categories.append(third)
    categories.append(fourth)
    categories.append(fifth)
    categories.append(sixth)
    
    for cat in categories {
        let db = Firestore.firestore()
        let ref = db.collection("category").document()
        ref.setData([
            "image": cat.image ?? 0,
            "userId": userId,
            "description": cat.description ?? "",
            "name": cat.name ?? "",
            "taskCount": cat.taskCount ?? "",
            "id": ref.documentID,
            "colorCode": cat.colorCode ?? ""
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
}
