//
//  AboutUsViewController.swift
//  ToDoApp
//
//  Created by mac on 25/04/2023.
//

import UIKit

class AboutUsViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavBar("About us")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
        
    @IBAction func backAction(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
}
