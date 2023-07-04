//
//  TaskCell2.swift
//  ToDoApp
//
//  Created by mac on 26/06/2023.
//

import UIKit

class TaskCell2: UITableViewCell {

    @IBOutlet weak var lblCatName: UILabel!
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblDueTime: UILabel!
    @IBOutlet weak var lblTimeRange: UILabel!
    @IBOutlet weak var taskViewBgColor: UIView!
    @IBOutlet weak var leftLineImg: UIImageView!
    @IBOutlet weak var constraintIineImgWidth: NSLayoutConstraint!
    @IBOutlet weak var constraintIineImgHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
