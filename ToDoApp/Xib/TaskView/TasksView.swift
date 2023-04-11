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
    
    @IBOutlet weak var priorityLbl: UILabel!
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    override required init?(coder: NSCoder) {
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
    }
}
