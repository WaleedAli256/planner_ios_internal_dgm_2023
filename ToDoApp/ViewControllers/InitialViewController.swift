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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func loginGoogleAction(_ sender: UIButton) {
////
//        guard Connectivity.isConnectedToInternet else {
//            self.showAlert(title: "Network Error", message: "Please check your internet connection")
//            return
//        }
//
//            Utilities.show_ProgressHud(view: self.view)
//
//            let signInConfig = GIDConfiguration.init(clientID: "776374048814-6lidgnkkfus5mmdu50lh0mnh17icmo1o.apps.googleusercontent.com")
//            GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
//                guard error == nil else {
//                    Utilities.hide_ProgressHud(view: self.view)
//                    Utilities.showAlert("\(error?.localizedDescription ?? "Unable to signin at this moment")", subtitle: "",type: .danger)
//                    return
//
//                }
//                guard let user = user else {
//                    Utilities.hide_ProgressHud(view: self.view)
//                    Utilities.showAlert("\(error?.localizedDescription ?? "Unable to signin at this moment")", subtitle: "",type: .danger)
//                    return
//
//                }
//
//                let id = user.userID
//                let emailAddress = user.profile?.email
//
//                let fullName = user.profile?.name
//
//                let profilePicUrl = user.profile?.imageURL(withDimension: 320)?.absoluteString
//                // If sign in succeeded, display the app's main content View.
//
//                //Check if the user already exists
//                let db = Firestore.firestore()
//
//                let ref = db.collection("users").document(id ?? "")
//
//                ref.getDocument(completion: {(document,err) in
//
//                    if let document = document, document.exists {
//
//                        //User already exists in our database
//
//                        db.collection("users").document(id ?? "").setData([
//                            "name": fullName ?? "",
//                            "email": emailAddress ?? "",
//                            "image_url": profilePicUrl ?? "",
//                            "id":id ?? ""
//                        ], merge: true) { err in
//                            if let err = err {
//                                print("Error adding document: \(err)")
//                            } else {
//                                var dict = [String:Any]()
//                                dict["name"] = fullName
//                                dict["email"] = emailAddress
//                                dict["image_url"] = profilePicUrl
//                                dict["id"] = id
//                                let user = User.init(fromDictionary: dict)
//                                Utilities().setCurrentUser(currentUser: user)
//                                self.getCategories(userId: id ?? "")
//                            }
//                        }
//                    }
//                    else
//                    {
//                        // This  is a new user
//
//                        db.collection("users").document(id ?? "").setData([
//                            "name": fullName ?? "",
//                            "email": emailAddress ?? "",
//                            "image_url": profilePicUrl ?? "",
//                            "id":id ?? ""
//                        ]) { err in
//                            if let err = err {
//                                print("Error adding document: \(err)")
//                            } else {
//                                var dict = [String:Any]()
//                                dict["name"] = fullName
//                                dict["email"] = emailAddress
//                                dict["image_url"] = profilePicUrl
//                                dict["id"] = id
//                                let user = User.init(fromDictionary: dict)
//                                Utilities().setCurrentUser(currentUser: user)
//
//                                self.getCategories(userId: id ?? "")
//                            }
//                        }
//                    }
//                })
//        }
//
    }
    
    @IBAction func skipAction(_ sender: UIButton) {
        
        
        var dict = [String:Any]()
        var userUID = ""
        let db = Firestore.firestore()
        Auth.auth().signInAnonymously { authResult, error in
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
            } else {
                userUID = (authResult?.user.uid)!
                let db = Firestore.firestore()

                let ref = db.collection("users").document(authResult?.user.uid ?? "")
                
                ref.getDocument(completion: {(document,err) in
                    if let document = document, document.exists {
                        //User already exists in our database
                        db.collection("users").document(authResult?.user.uid ?? "").setData([
                            "id": userUID,
                            "name": "Annomous",
                            "email": "emailAddress",
                            "deviceType" : "iOS",
                            "userType" : "Annomous",
                            "image_url": "profilePicUrl"
                    
                        ], merge: true) { err in
                            if let err = err {
                                print("Error adding document: \(err)")
                            } else {
                                dict["id"] = userUID
                                dict["name"] = "Annomous"
                                dict["deviceType"] = "iOS"
                                dict["userType"] = "Annomous"
                                dict["email"] = "emailAddress"
                                dict["image_url"] = "profilePicUrl"
                                let user = User.init(fromDictionary: dict)
                                Utilities().setCurrentUser(currentUser: user)
                                self.createDefaultsCategories(userId: userUID)
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
                                self.navigationController?.pushViewController(mainTabBarController, animated: true)
                            }
                        }
                    }
                    else
                    {
                        // This  is a new user
                        db.collection("users").document(authResult?.user.uid ?? "").setData([
                            "id": userUID,
                            "name": "Annomous",
                            "email": "emailAddress",
                            "deviceType" : "iOS",
                            "userType" : "Annomous",
                            "image_url": "profilePicUrl"
                            
                        ]) { err in
                            if let err = err {
                                print("Error adding document: \(err)")
                            } else {
                                var dict = [String:Any]()
                                dict["id"] = userUID
                                dict["name"] = "Annomous"
                                dict["deviceType"] = "iOS"
                                dict["userType"] = "Annomous"
                                dict["email"] = "emailAddress"
                                dict["image_url"] = "profilePicUrl"
                                let user = User.init(fromDictionary: dict)
                                Utilities().setCurrentUser(currentUser: user)
                                self.createDefaultsCategories(userId: userUID)
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
                                self.navigationController?.pushViewController(mainTabBarController, animated: true)

                            }
                        }
                    }
                })
                
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
}
