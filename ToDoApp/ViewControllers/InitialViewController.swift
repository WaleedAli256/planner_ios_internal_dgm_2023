//
//  InitialViewController.swift
//  ToDoApp
//
//  Created by mac on 12/04/2023.
//

import UIKit
import Firebase
import GoogleSignIn
import CryptoKit
import FirebaseFirestore
import AuthenticationServices
class InitialViewController: BaseViewController {
    
    @IBOutlet weak var myStackView: UIStackView!
    @IBOutlet weak var btnSkip: UIButton!
    let db = Firestore.firestore()
    var isAppleButtonTap = false
    var changeMode: Bool =  false
    var isButtonAdded: Bool = false
    var authorizationButton = ASAuthorizationAppleIDButton()
    var allTasks: [Task] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        Utilities.setIsFirstTime(isFirstTime: false)
        btnSkip.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
//        AddTaskViewController.onAddTask = { res in
//           
//        }
    }
    
    @objc func buttonTapped() {
        
        btnSkip.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 8.0) {
            self.btnSkip.isEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.setupProviderLoginView()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
           super.traitCollectionDidChange(previousTraitCollection)
//        self.setupProviderLoginView()
    }
    
    func setupProviderLoginView() {
//      authorizationButton.removeFromSuperview()
        authorizationButton.cornerRadius = 12
        if traitCollection.userInterfaceStyle == .dark {
                // Code for dark mode
            authorizationButton = ASAuthorizationAppleIDButton(type: .signIn, style: .whiteOutline)
            } else {
                // Code for light mode
                authorizationButton = ASAuthorizationAppleIDButton(type: .signIn, style: .whiteOutline)
            }
        authorizationButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        self.myStackView.addArrangedSubview(authorizationButton)
    }
    
    @objc
    func handleAuthorizationAppleIDButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
        //        cAlert.ShowToast(VC: self, msg: "This functionality will work when app would be uploaded on testflight")
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
            let ref = db.collection("users").document(userUID)
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
                            "userType" : "1",
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
                        self.db.collection("users").document(userUID).setData([
                            "id": userUID,
                            "name": "Annomous User",
                            "email": "email",
                            "deviceType" : "iOS",
                            "userType" : "1",
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
    
    func navigateToHome() {
        
        guard UIApplication.shared.delegate is AppDelegate else {
            return
        }
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            return
        }
        sceneDelegate.setHomeVC()
    }
    
    
    
    func userLoginParams(_ userID: String, _ name: String, _ email: String, _ devicType: String, _ userTyp: String, _ profImgUrl: String) {
        //        let ref = self.db.collection("users").document(self.firebaseUserId)
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
        Utilities.setStringForKey("logout", key: "false")
        Utilities.setIsFirstTime(isFirstTime: false)
//        if self.btnSkip.tag == 1 || isAppleButtonTap == true{
//            Utilities.setIntForKey(1, key: "userType")
//            Utilities.setIntForKey(2, key: "userType")
//        } else {
//            Utilities.setIntForKey(0, key: "userType")
//        }
        Utilities.hide_ProgressHud(view: self.view)
        
        self.getAllTasks(userId: Utilities().getCurrentUser().id ?? "")
    
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
//                        self.selectedDayTasks = []
                    }
                    if self.allTasks.count == 0 {
                        self.showPopup()
                    } else {
                        guard UIApplication.shared.delegate is AppDelegate else {
                            return
                        }
                        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
                            return
                        }
                        sceneDelegate.setHomeVC()
                    }
                    
//                    self.getTasks()
                }
            }
    }
    
    func showPopup() {
        //show popup
        let customPopUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddTaskViewController") as! AddTaskViewController
            let navigationController = UINavigationController(rootViewController: customPopUpVC)
            self.addChild(navigationController)
        navigationController.modalTransitionStyle = .crossDissolve
        navigationController.view.frame = self.view.frame
            self.view.addSubview(navigationController.view)
//            customPopUpVC.modalTransitionStyle = .coverVertical
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.didMove(toParent: self)
        
        
//        
//        let customPopUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddTaskViewController") as! AddTaskViewController
//
//        // Embed the customPopUpVC in a UINavigationController
//        let navigationController = UINavigationController(rootViewController: customPopUpVC)
//
//        self.addChild(navigationController)
//        navigationController.modalTransitionStyle = .crossDissolve
//        navigationController.view.frame = self.view.frame
//        self.view.addSubview(navigationController.view)
//        navigationController.modalPresentationStyle = .fullScreen
//        navigationController.didMove(toParent: self)

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
    let first = TaskCategory(image: 1, userId: userId, description: "Keep yourself hydrated all time!", name: "Water Intake", taskCount: "0", id: "", colorCode: "#5486E9", isFavourite: false)
    let sec = TaskCategory(image: 2, userId: userId, description: "Wake up on the time So you never late!", name: "Sleeping Schedule", taskCount: "0", id: "", colorCode: "#F1A800",isFavourite: false)
    let third = TaskCategory(image: 3, userId: userId, description: "Never miss an Event to wish to your loved ones", name: "Event Reminder", taskCount: "0", id: "", colorCode: "#FFB185",isFavourite: false)
    let fourth = TaskCategory(image: 4, userId: userId, description: "Schedule your Exercise to stay healthy", name: "Exercise Schedule", taskCount: "0", id: "", colorCode: "#E784D1",isFavourite: false)
    let fifth = TaskCategory(image: 5, userId: userId, description: "Keep yourself hydrated all time!", name: "Food Intake", taskCount: "0", id: "", colorCode: "#76DC80", isFavourite: false)
    let sixth = TaskCategory(image: 6, userId: userId, description: "Wake up on the time So you never late!", name: "Personal Care", taskCount: "0", id: "", colorCode: "#51BBA2", isFavourite: false)
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
            "colorCode": cat.colorCode ?? "",
            "isFavourite": cat.isFavourite ?? ""
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
}
//MARK: - Apple Login
extension InitialViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let nonce = randomNonceString()

            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            Utilities.show_ProgressHud(view: self.view)
            if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
//            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName?.familyName
                
                let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                          idToken: idTokenString,
                                                          rawNonce: nonce)
                Auth.auth().signIn(with: credential) { (authResult, error) in
                    if (error != nil) {
                        print(error?.localizedDescription ?? "")
                        return
                    } else {
                        guard let user = authResult?.user else { return }
                        let email = user.email ?? ""
                        let displayName = fullName ?? "Apple user"
                        let profilePic = "imageURLString" ?? ""
                        guard let uid = Auth.auth().currentUser?.uid else { return }
                        //Check if the user already exists
                        let ref = self.db.collection("users").document(authResult?.user.uid ?? "")
                        ref.getDocument(completion: {(document,err) in
                            if let document = document, document.exists {
                                //User already exists in our database
                                self.db.collection("users").document(uid).setData([
                                    "userToken": "idTokenString",
                                    "id":uid ,
                                    "name": displayName,
                                    "email": email,
                                    "deviceType" : "iOS",
                                    "userType" : "2",
                                    "imageUrl": profilePic,
                                ], merge: true) { err in
                                    if let err = err {
                                        print("Error adding document: \(err)")
                                    } else {
                                        self.userLoginParams(user.uid , displayName, user.email!, "iOS", "0", profilePic)
                                    }
                                }



                            }
                            else
                            {
                                // This  is a new user
                                self.db.collection("users").document(user.uid).setData([
                                    "userToken": "idTokenString",
                                    "id":uid ,
                                    "name": displayName ,
                                    "email": email,
                                    "deviceType" : "iOS",
                                    "userType" : "2",
                                ]) { err in
                                    if let err = err {
                                        print("Error adding document: \(err)")
                                    } else {
                                        createDefaultsCategories(userId: user.uid)
                                        self.userLoginParams(user.uid , displayName, user.email!, "iOS", "0", profilePic)

                                    }
                                }
                            }
                        })
                        print("User login successfully with apple account")
                    }
                }
            }
            }
            
           
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("erro occure")
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }

    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    @available(iOS 13.0, *)
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap { return String(format: "%02x", $0) }.joined()
        return hashString
    }
}
