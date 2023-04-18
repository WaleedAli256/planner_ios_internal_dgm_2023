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
    var description: String?
    var time: String?
    var date: String?
    var priority: String?
    var preReminder: String?
    var repetition: String?
    var colorCode: String?
    
    
    init(userId:  String? = nil, description:  String? = nil, date:  String? = nil, categoryName:  String? = nil, id:  String? = nil, colorCode:  String? = nil) {
        self.date = date
        self.userId = userId
        self.description = description
        self.id = id
        self.colorCode = colorCode
        self.categoryName = categoryName
    }
    
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
        description = dictionary["description"] as? String
        time = dictionary["time"] as? String
        date = dictionary["date"] as? String
        priority = dictionary["priority"] as? String
        preReminder = dictionary["preReminder"] as? String
        repetition = dictionary["repetition"] as? String
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
        if colorCode != nil{
            dictionary["colorCode"] = colorCode
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
        if description != nil{
            dictionary["description"] = description
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
        if repetition != nil{
            dictionary["repetition"] = repetition
        }
        return dictionary
    }
}
