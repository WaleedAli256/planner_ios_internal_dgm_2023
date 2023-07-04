//
//  ViewController1.swift
//  ViewPager
//
//  Created by mac on 01/06/2023.
//  Copyright © 2023 sailabs. All rights reserved.
//

import UIKit


class ViewController1: UIViewController {
    static var onNextTap : ((Bool) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

    @IBAction func nextPageActions(_ sender: UIButton) {
        ViewController1.onNextTap?(true)
        
        
        
    }
    
    @IBAction func skipAction(_ sender: UIButton) {
        
        onSkipAction()
    }
}
