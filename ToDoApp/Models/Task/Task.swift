//
//  Task.swift
//  TODO APP
//
//  Created by Hassnain Khaliq on 01/04/2022.
//

import UIKit

struct Task: Codable{
    
    var id: String?
    var title: String?
    var userId: String?
    var categoryId: String?
    var categoryName: String?
    var descriptionField: String?
    var time: String?
    var date: String?
    var priority: String?
    var preReminder: String?
    var repitition: String?
    var colorCode: String?


    
//    enum CodingKeys: String, CodingKey {
//        case id = "id"
//        case category = "category"
//        case date = "date"
//        case description_field = "description_field"
//        case time = "time"
//        case is_remind = "is_remind"
//        case location = "location"
//        case timestamp = "timestamp"
//        case title = "title"
//    }
    
    init(fromDictionary dictionary: [String:Any]){
        id = dictionary["id"] as? String
        title = dictionary["title"] as? String
        userId = dictionary["userId"] as? String
        categoryId = dictionary["categoryId"] as? String
        categoryName = dictionary["categoryName"] as? String
        descriptionField = dictionary["descriptionField"] as? String
        time = dictionary["time"] as? String
        date = dictionary["date"] as? String
        priority = dictionary["priority"] as? String
        preReminder = dictionary["preReminder"] as? String
        repitition = dictionary["repitition"] as? String
        colorCode = dictionary["colorCode"] as? String
    }
    
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if id != nil{
            dictionary["id"] = id
        }
        if title != nil{
            dictionary["title"] = title
        }
        if userId != nil{
            dictionary["userId"] = userId
        }
        if categoryId != nil{
            dictionary["categoryId"] = categoryId
        }
        if categoryName != nil{
            dictionary["categoryName"] = categoryName
        }
        if descriptionField != nil{
            dictionary["descriptionField"] = descriptionField
        }
        if time != nil{
            dictionary["time"] = time
        }
        if date != nil{
            dictionary["date"] = date
        }
        if priority != nil{
            dictionary["priority"] = priority
        }
        if preReminder != nil{
            dictionary["preReminder"] = preReminder
        }
        if repitition != nil{
            dictionary["repitition"] = repitition
        }
        if colorCode != nil{
            dictionary["colorCode"] = colorCode
        }
        return dictionary
    }
}
