//
//  CustomTabBarController.swift
//  ToDoApp
//
//  Created by mac on 30/03/2023.
//

import UIKit

class CustomTabBarController: UITabBarController {

    // MARK: - View Life Cycle
       override func viewDidLoad() {
           super.viewDidLoad()
           
           tabBar.isTranslucent = false
           tabBar.tintColor = #colorLiteral(red: 0.3882352941, green: 0.5647058824, blue: 0.9215686275, alpha: 1)
           
           delegate = self
           
           // Instantiate view controllers
           let homeNav = self.storyboard?.instantiateViewController(withIdentifier: "HomeNav") as! UINavigationController
           
           let settingsNav = self.storyboard?.instantiateViewController(withIdentifier: "SettingsNav") as! UINavigationController
           
           let newPostVC = self.storyboard?.instantiateViewController(withIdentifier: "NewPostNav") as! UINavigationController
           
           
           // Create TabBar items
           homeNav.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
           
           settingsNav.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "gearshape"), selectedImage: UIImage(systemName: "gearshape.fill"))
           
           newPostVC.tabBarItem = UITabBarItem(title: nil, image: nil, selectedImage: nil)
           
           
           // Assign viewControllers to tabBarController
           let viewControllers = [homeNav, newPostVC, settingsNav]
           self.setViewControllers(viewControllers, animated: false)
           
           
           guard let tabBar = self.tabBar as? CustomTabBar else { return }
           
           tabBar.didTapButton = { [unowned self] in
               self.routeToCreateNewAd()
           }
       }
       
       func routeToCreateNewAd() {
           let createAdNavController = self.storyboard?.instantiateViewController(withIdentifier: "NewPostNav") as! UINavigationController
           createAdNavController.modalPresentationCapturesStatusBarAppearance = true
           self.present(createAdNavController, animated: true, completion: nil)
       }
   }

   // MARK: - UITabBarController Delegate
   extension CustomTabBarController: UITabBarControllerDelegate {
       func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
           guard let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController) else {
               return true
           }
           
           // Your middle tab bar item index.
           // In my case it's 1.
           if selectedIndex == 1 {
               return false
           }
           
           return true
       }


}
