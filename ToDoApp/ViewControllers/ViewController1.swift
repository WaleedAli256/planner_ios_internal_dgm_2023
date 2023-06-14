//
//  ViewController1.swift
//  ViewPager
//
//  Created by mac on 01/06/2023.
//  Copyright © 2023 sailabs. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class ViewController1: UIViewController {

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

    @IBAction func pushAction(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let searchTaskVC = storyboard.instantiateViewController(identifier: "ViewController2") as! ViewController2
        self.navigationController?.pushViewController(searchTaskVC, animated: true)
    }
}
