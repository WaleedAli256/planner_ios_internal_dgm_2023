//
//  Utilities.swift
//  TODO APP
//
//  Created by Hassnain Khaliq on 01/04/2022.
//

import UIKit
import Foundation
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
    
    static func setStringForKey(_ value:String?, key:String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    static func getStringForKey(_ key:String)->String? {
        return UserDefaults.standard.string(forKey: key)
    }
    
    static func getIsFirstTime() -> Bool
    {
        let isFirstTime = UserDefaults.standard.value(forKey: Constants.UserDefaults.isFirstTime) as? Bool
        return isFirstTime ?? true
    }
    
    static func setIntForKey(_ value:Int?, key:String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    static func getIntForKey(_ key:String)->String? {
        return UserDefaults.standard.string(forKey: key)
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
    
    static func changeDateFormat(fromFormat: String, toFormat: String, dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = toFormat
            let formattedDate = dateFormatter.string(from: date)
            return formattedDate
        } else {
            return nil
        }
    }
        
struct Connectivity {
    static let sharedInstance = NetworkReachabilityManager()!
    static var isConnectedToInternet:Bool {
        return self.sharedInstance.isReachable
        }
    
    }
}

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
