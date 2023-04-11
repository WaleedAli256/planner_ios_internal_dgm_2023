//
//  TaskCell.swift
//  ToDoApp
//
//  Created by mac on 10/04/2023.
//

import UIKit

class TaskCell: UITableViewCell {
    
    @IBOutlet weak var lblDetail: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
