//
//  SignUpViewController.swift
//  OperatorClientApp
//
//  Created by mac on 17/08/2022.
//

import UIKit


class SignUpViewController: BaseViewController {
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtLName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPass: UITextField!

    @IBOutlet weak var btnImage: UIButton!
    @IBOutlet weak var btnImage2: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        Utilities.shareInstance.statusBarBackgroundColor(myView: self.view)
        self.btnImage.setImage(UIImage(named: "icon-eye-1"), for: .normal)
        self.btnImage2.setImage(UIImage(named: "icon-eye-1"), for: .normal)
  
        
//
//        [countryView].forEach {
//            $0?.dataSource = self
//        }
        
        self.txtName.delegate = self
        self.txtLName.delegate = self
        self.txtEmail.delegate = self
        self.txtPassword.delegate = self
        self.txtConfirmPass.delegate = self
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
    }
    
    private func validate() -> Bool
    {
//        if(txtName.text!.count < 1 )
//        {
//            self.showAlert(title: "Alert", message: "Please fill out the name field.")
//            return false
//        }
//
//        if(txtLName.text!.count < 1 )
//        {
//            self.BlurView.isHidden = false
//            self.lblAlertMsg.text = "Please fill out the name field."
//            return false
//        }
//
//        if(txtEmail.text!.count < 1 )
//        {
//            self.BlurView.isHidden = false
//            self.lblAlertMsg.text = "Please fill out the email field."
//            return false
//        }
//
//        if !Utilities.shareInstance.isValidEmail(self.txtEmail.text!) {
//            self.BlurView.isHidden = false
//            self.lblAlertMsg.text = "Please fill out correct email."
//            return false
//        }
//
//
//        if(txtPassword.text!.count < 1)
//        {
//            self.BlurView.isHidden = false
//            self.lblAlertMsg.text = "Please fill out password field."
//            return false
//        }
//
//        if(txtConfirmPass.text!.count < 1)
//        {
//            self.BlurView.isHidden = false
//            self.lblAlertMsg.text = "Please fill out Confirm password field."
//            return false
//        }
//
//        if(txtPassword.text!.count < 8 || txtConfirmPass.text!.count < 8)
//        {
//            self.BlurView.isHidden = false
//            self.lblAlertMsg.text = "The password must be at least 8 characters."
//            return false
//        }
//
//        if(txtPassword.text! != txtConfirmPass.text!)
//        {
//            self.BlurView.isHidden = false
//            self.lblAlertMsg.text = "Password and Confirm Password are not matched."
//            return false
//        }
//
        return true
    }
    
    @IBAction func onBtnRegisterTap(_ sender: UIButton) {
        
        if validate() {
            
        }
        
    }
    
    
    
    @IBAction func onBtnShowHidePass(_ sender: UIButton) {
        
        if sender.tag == 0 {
            self.txtPassword.isSecureTextEntry = true
            sender.tag = 1
            self.btnImage.setImage(UIImage(named: "icon-eye-1"), for: .normal)
        } else {
            self.txtPassword.isSecureTextEntry = false
            sender.tag = 0
            self.btnImage.setImage(UIImage(named: "icon-eye"), for: .normal)
        }
        
    }
    
    @IBAction func onBtnConfirPassShwHid(_ sender: UIButton) {
        
        if sender.tag == 0 {
            self.txtConfirmPass.isSecureTextEntry = true
            sender.tag = 1
            self.btnImage2.setImage(UIImage(named: "icon-eye-1"), for: .normal)
        } else {
            self.txtConfirmPass.isSecureTextEntry = false
            sender.tag = 0
            self.btnImage2.setImage(UIImage(named: "icon-eye"), for: .normal)
        }
        
    }
}

extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
            case txtName:
                self.txtLName.becomeFirstResponder()
            case txtLName:
                self.txtEmail.becomeFirstResponder()
            case txtEmail:
                self.txtPassword.becomeFirstResponder()
            case txtPassword:
                self.txtConfirmPass.becomeFirstResponder()
            case txtConfirmPass:
                self.txtConfirmPass.becomeFirstResponder()
            default:
                textField.resignFirstResponder()
            }
            return false
    }

}

