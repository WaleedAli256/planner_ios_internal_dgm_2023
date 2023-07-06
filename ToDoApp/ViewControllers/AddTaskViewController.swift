//
//  AddTaskViewController.swift
//  ToDoApp
//
//  Created by mac on 23/06/2023.
//

import UIKit

class AddTaskViewController: BaseViewController {
    
    static var onAddTask:((Bool) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
 
        self.navigationController?.navigationBar.isHidden = true
        CreateTaskViewController.onAddTaskTap = { res in
            self.removeFromParent()
            guard UIApplication.shared.delegate is AppDelegate else {
                return
            }
            guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
                return
            }
            sceneDelegate.setHomeVC()
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        self.navigationController?.navigationBar.isHidden = false
//    }

    @IBAction func addTaskAction(_ sender: UIButton) {
//        AddTaskViewController.onAddTask?(true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let creatTaskVC = storyboard.instantiateViewController(identifier: "CreateTaskViewController") as! CreateTaskViewController
        creatTaskVC.fromViewController = "Add Task View"
//        creatTaskVC.fromViewController = fromViewController
        self.navigationController?.pushViewController(creatTaskVC, animated: true)
    }
    
}
