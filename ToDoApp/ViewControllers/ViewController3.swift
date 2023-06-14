//
//  ViewController3.swift
//  ViewPager
//
//  Created by mac on 01/06/2023.
//  Copyright © 2023 sailabs. All rights reserved.
//

import UIKit

class ViewController3: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnInitVCTap(_ sender: UIButton) {
     
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "InitialNavigationController") as! InitialNavigationController
        let window = UIApplication.shared.windows.first
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }

}
