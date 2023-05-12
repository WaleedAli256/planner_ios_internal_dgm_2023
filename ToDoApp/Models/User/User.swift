//
//  User.swift
//  TODO APP
//
//  Created by Hassnain Khaliq on 01/04/2022.
//

import UIKit

class User: NSObject,NSCoding {

    var id: String?
    var name: String?
    var deviceType: String?
    var userType: Int?
    var email: String?
    var image_url: String?
//    var tasks: [Task]!
//    var categories: [Category]!
    
    init(fromDictionary dictionary: [String:Any]){
        
        id = dictionary["id"] as? String
        name = dictionary["name"] as? String
        deviceType = dictionary["deviceType"] as? String
        userType = dictionary["isAnonmusUser"] as? Int
        image_url = dictionary["image_url"] as? String
        email = dictionary["email"] as? String
        
//        tasks = [Task]()
//        if let taskArray = dictionary["tasks"] as? [[String:Any]]{
//            for dic in taskArray{
//                let value = Task.init(fromDictionary: dic)
//                tasks.append(value)
//            }
//        }
        
//       categories = [Category]()
//        if let categoryArray = dictionary["categories"] as? [[String:Any]] {
//            for dic in categoryArray {
//
//            }
//        }
        
    }
    
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if id != nil{
            dictionary["id"] = id
        }
        if name != nil{
            dictionary["name"] = name
        }
        if deviceType != nil{
            dictionary["deviceType"] = deviceType
        }
        if userType != nil{
            dictionary["isAnonmusUser"] = userType
        }
        if email != nil{
            dictionary["email"] = email
        }
        if image_url != nil{
            dictionary["image_url"] = image_url
        }
//        if tasks != nil{
//            var dictionaryElements = [[String:Any]]()
//            for interestElement in tasks {
//                dictionaryElements.append(interestElement.toDictionary())
//            }
//            dictionary["tasks"] = dictionaryElements
//        }
//        if categories != nil{
//            var dictionaryElements = [[String:Any]]()
//            for interestElement in categories {
//                dictionaryElements.append(interestElement.toDictionary())
//            }
//            dictionary["categories"] = dictionaryElements
//        }
        return dictionary
    }
    
    @objc required init(coder aDecoder: NSCoder)
    {
        id = aDecoder.decodeObject(forKey: "id") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        deviceType = aDecoder.decodeObject(forKey: "deviceType") as? String
        userType = aDecoder.decodeObject(forKey: "isAnonmusUser") as? Int
        email = aDecoder.decodeObject(forKey: "email") as? String
        image_url = aDecoder.decodeObject(forKey: "image_url") as? String
//        tasks = aDecoder.decodeObject(forKey: "tasks") as? [Task]
//        categories = aDecoder.decodeObject(forKey: "categories") as? [Category]
//        quickTasks = aDecoder.decodeObject(forKey: "quickTasks") as? [QuickTask]
    }
    
    @objc func encode(with aCoder: NSCoder)
    {
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if deviceType != nil{
            aCoder.encode(name, forKey: "deviceType")
        }
        if userType != nil{
            aCoder.encode(name, forKey: "isAnonmusUser")
        }
        if email != nil{
            aCoder.encode(email, forKey: "email")
        }
        if image_url != nil{
            aCoder.encode(image_url, forKey: "image_url")
        }
//        if tasks != nil{
//            aCoder.encode(tasks, forKey: "tasks")
//        }
//        if categories != nil{
//            aCoder.encode(categories, forKey: "categories")
//        }

    }
}
