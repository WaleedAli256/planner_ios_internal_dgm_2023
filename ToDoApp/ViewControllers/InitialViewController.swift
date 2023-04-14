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
                            "name": "old Annomous",
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
                            "name": "New Annomous",
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
            let db = Firestore.firestore()
            for cat in 0...5 {
                db.collection("category").document(userId).setData([
                    "image": cat,
                    "userId": userId,
                    "description": "USA"
                    "name": "USA"
                    "taskCount": "USA"
                    "description": "USA"
                    "description": "USA"
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
