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

    static var onNext : ((Bool) -> Void)?
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

    @IBAction func nextPageAction(_ sender: UIButton) {
        ViewController2.onNext?(true)
        
    }
    
    @IBAction func skipAction(_ sender: UIButton) {
        onSkipAction()
    }

}



