//
//  Utilities.swift
//  TODO APP
//
//  Created by Hassnain Khaliq on 01/04/2022.
//

import UIKit
//import NotificationBannerSwift
import MBProgressHUD
import Alamofire

class Utilities: NSObject {
    
    func applyGradientColor(view: UIView, startPoints: CGPoint, endPoints: CGPoint ) -> CAGradientLayer {

        let colorTop =  UIColor(red: 156.0/255.0, green: 0.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 239.0/255.0, green: 101.0/255.0, blue: 220.0/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [colorTop,colorBottom]
        gradientLayer.frame = view.bounds
        return gradientLayer
    }
    
    static func setIsFirstTime(isFirstTime: Bool)
    {
        UserDefaults.standard.setValue(isFirstTime, forKey: Constants.UserDefaults.isFirstTime)
        UserDefaults.standard.synchronize()
    }
    
    static func getIsFirstTime() -> Bool
    {
        let isFirstTime = UserDefaults.standard.value(forKey: Constants.UserDefaults.isFirstTime) as? Bool
        return isFirstTime ?? true
    }
    
    func setCurrentUser(currentUser: User)
    {
        let userDefaults = UserDefaults.standard
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: currentUser)
        userDefaults.set(encodedData, forKey: Constants.UserDefaults.currentUser)
        userDefaults.synchronize()
    }
    
    func getCurrentUser() -> User
    {
        let userDefaults = UserDefaults.standard
        let decoded  = userDefaults.data(forKey: Constants.UserDefaults.currentUser)
        let user = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as! User
        return user
    }
    
    func deleteCurrentUser()
    {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: Constants.UserDefaults.currentUser)
        userDefaults.setValue(nil, forKey: Constants.UserDefaults.currentUser)
        userDefaults.setValue(true, forKey: Constants.UserDefaults.isFirstTime)
        userDefaults.synchronize()
    }

    static func show_ProgressHud(view: UIView)
    {
        DispatchQueue.main.async {
            MBProgressHUD.showAdded(to: view, animated: true)
        }
    }
    
    static func hide_ProgressHud(view: UIView)
    {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: view, animated: false)
        }
    }


struct Connectivity {
    static let sharedInstance = NetworkReachabilityManager()!
    static var isConnectedToInternet:Bool {
        return self.sharedInstance.isReachable
        }
    
    }
}
