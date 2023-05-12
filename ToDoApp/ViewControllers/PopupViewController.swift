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
    
    @IBOutlet weak var lblAlertMsg: UILabel!
    @IBOutlet weak var lblMsgName: UILabel!
    var alertMg = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.lblAlertMsg.text = alertMg
    }
    
    @IBAction func crossBtnAction(_ sender: UIButton) {
        
        if delegate != nil {
            self.delegate?.dimissSuperView()
        }
    }

}
