//
//  TasksView.swift
//  ToDoApp
//
//  Created by Asif on 10/04/2023.
//

import UIKit
import Foundation

class TasksView: UIView{
    
    var myVC = UIViewController()
    var task: Task?
    
    @IBOutlet weak var priorityLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var repeatLbl: UILabel!
    @IBOutlet weak var preReminderLbl: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var priorityBgView: UIView!
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    private func commonInit(){
        let bundle = Bundle.init(for: TasksView.self)
        if let viewToAdd = bundle.loadNibNamed("TasksView", owner: self, options: nil), let contentView = viewToAdd.first as? UIView{
            addSubview(contentView)
            contentView.frame = self.bounds
            contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        }
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.priorityLbl.text = self.task?.priority
            self.titleLbl.text = self.task?.title
            self.descLbl.text = self.task?.description
            
            let originalDateFormat = "MM/dd/yyyy h:mm a"
            let desiredDateFormat = "EE,d MMM h:mm a"
            let originalDateString = self.task?.date

            if let formattedDate = Utilities.changeDateFormat(fromFormat: originalDateFormat, toFormat: desiredDateFormat, dateString: originalDateString!) {
                print("Formatted Date: \(formattedDate)")
                self.timeLbl.text = formattedDate
            } else {
                print("Failed to format date")
            }
            
//            self.timeLbl.text = self.task?.date
            self.repeatLbl.text = self.task?.repetition
            self.preReminderLbl.text = self.task?.preReminder
            if let color = self.task?.priorityColorCode {
                if self.priorityLbl.text == "High" {
                    self.priorityBgView.backgroundColor = UIColor(named: "high-color")
                } else if self.priorityLbl.text == "Medium" {
                    self.priorityBgView.backgroundColor = UIColor(named: "medium-color")
                    
                } else if self.priorityLbl.text == "Low" {
                    self.priorityBgView.backgroundColor = UIColor(named: "low-colorP")
                    
                }
                self.priorityLbl.textColor = UIColor(named: color)
            }
            
            if let color = self.task?.colorCode {
                self.bgView.backgroundColor = UIColor(hexString: color)
            }
        }
    }
    
//    func changeDateFormat(fromFormat: String, toFormat: String, dateString: String) -> String? {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = fromFormat
//        
//        if let date = dateFormatter.date(from: dateString) {
//            dateFormatter.dateFormat = toFormat
//            let formattedDate = dateFormatter.string(from: date)
//            return formattedDate
//        } else {
//            return nil
//        }
//    }
        
}
