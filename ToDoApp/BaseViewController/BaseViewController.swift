//
//  BaseViewController.swift
//  ToDoApp
//
//  Created by mac on 11/04/2023.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    func showAlert(title:String, message: String) {
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func setNavBar(_ navTitle: String,_ profilPic: String) {
        
//        let image = UIImage(named: imageName)
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
//        imageView.image = profilPic
//        // Create a UIBarButtonItem with a custom view
//        let imageBarButton = UIBarButtonItem(customView: imageView)
        
        let rightBarButton = UIBarButtonItem(image: UIImage(named: profilPic), style: .plain, target: self,
                                            action: nil)
//        navigationController?.navigationBar.isTranslucent = false
//        navigationController?.navigationBar.backgroundColor = UIColor(named: "bg-color")
        navigationItem.rightBarButtonItem = rightBarButton
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = navTitle
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "TextColor")!]
        self.navigationController?.navigationBar.tintColor = UIColor(named: "TextColor")
        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
    }
    
    func setNavBar(_ navTitle: String) {
        
//        let image = UIImage(named: imageName)
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
//        imageView.image = profilPic
//        // Create a UIBarButtonItem with a custom view
//        let imageBarButton = UIBarButtonItem(customView: imageView)
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = navTitle
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "TextColor")!,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 18.0, weight: .medium)]
        self.navigationController?.navigationBar.tintColor = UIColor(named: "TextColor")
        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
