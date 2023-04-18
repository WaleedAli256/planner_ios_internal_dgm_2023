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
            self.timeLbl.text = self.task?.time
            self.repeatLbl.text = self.task?.repetition
            self.preReminderLbl.text = self.task?.preReminder
        }
    }
}
