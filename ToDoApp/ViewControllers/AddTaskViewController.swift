//
//  AddTaskViewController.swift
//  ToDoApp
//
//  Created by mac on 23/06/2023.
//

import UIKit

class AddTaskViewController: UIViewController {
    
//    static var onAddTaskTap:((Bool) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

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

    @IBAction func addTaskAction(_ sender: UIButton) {
//        AddTaskViewController.onAddTaskTap?(true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let creatTaskVC = storyboard.instantiateViewController(identifier: "CreateTaskViewController") as! CreateTaskViewController
        creatTaskVC.fromViewController = "Add Task View"
//        creatTaskVC.fromViewController = fromViewController
        self.navigationController?.pushViewController(creatTaskVC, animated: true)
    }
    
}
