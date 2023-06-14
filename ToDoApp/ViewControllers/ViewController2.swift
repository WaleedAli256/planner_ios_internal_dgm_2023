//
//  ViewController2.swift
//  ViewPager
//
//  Created by mac on 01/06/2023.
//  Copyright © 2023 sailabs. All rights reserved.
//

import UIKit
import AuthenticationServices

class ViewController2: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let appleSignInButton = ASAuthorizationAppleIDButton()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func actionLoginApple(_ sender: UIButton) {
        
        let appleIDProvider = ASAuthorizationAppleIDProvider().createRequest()
        appleIDProvider.requestedScopes = [.fullName, .email]
            
            let controller = ASAuthorizationController(authorizationRequests: [appleIDProvider])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        
    }

}


extension ViewController2: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // Handle the user's credentials
            let userID = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            print(userID)
            print(fullName)
            print(email)
            // Use the received data to authenticate or create a user session
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle the error
    }
}
