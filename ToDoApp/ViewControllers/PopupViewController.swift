//
//  PopupViewController.swift
//  ToDoApp
//
//  Created by mac on 02/05/2023.
//

import UIKit

protocol PopupViewControllerDelegate {
    
    func dimissSuperView()
}

class PopupViewController: UIViewController {
    
    var delegate: PopupViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func crossBtnAction(_ sender: UIButton) {
        
        if delegate != nil {
            self.delegate?.dimissSuperView()
        }
    }

}
