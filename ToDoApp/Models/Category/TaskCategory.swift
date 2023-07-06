//
//  Category.swift
//  ToDoApp
//
//  Created by Asif on 14/04/2023.
//

import Foundation

struct TaskCategory {
    var image: Int?
    var userId: String?
    var description: String?
    var name: String?
    var taskCount: String?
    var id: String?
    var colorCode: String?
    var isFavourite:Bool?
    
    init(fromDictionary dictionary: [String:Any]){
        id = dictionary["id"] as? String
        name = dictionary["name"] as? String
        image = dictionary["image"] as? Int
        userId = dictionary["userId"] as? String
        taskCount = dictionary["taskCount"] as? String
        colorCode = dictionary["colorCode"] as? String
        description = dictionary["description"] as? String
        isFavourite = dictionary["isFavourite"] as? Bool
    }
    
    init(image: Int? = nil, userId:  String? = nil, description:  String? = nil, name:  String? = nil, taskCount:  String? = nil, id:  String? = nil, colorCode:  String? = nil, isFavourite:Bool = false) {
        self.name = name
        self.image = image
        self.userId = userId
        self.description = description
        self.taskCount = taskCount
        self.id = id
        self.colorCode = colorCode
        self.isFavourite = isFavourite
    }
}
