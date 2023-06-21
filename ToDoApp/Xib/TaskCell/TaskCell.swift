//
//  TaskCell.swift
//  ToDoApp
//
//  Created by mac on 10/04/2023.
//

import UIKit

class TaskCell: UITableViewCell {
   
    @IBOutlet weak var lblTimeDate: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblpriority: UILabel!
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var priorityView: UIView!
    @IBOutlet weak var btndropdown: UIButton!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var topView: UIView!
    
    
//    var actionIndex = -1
//    var actionType = ""
//    var titles = ["Delete"]
//    var delegate: TaskCellDelegate?
//    var delegate2: TaskCellDelegate2?
//    let dropDown = MakeDropDown()
    var dropDownRowHeight: CGFloat = 30
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.popupView.isHidden = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func deleteTaskAction(_ sender: UIButton) {
//        self.popupView.isHidden = false
        // Get the collection view from the cell's superviews
//        if delegate != nil {
//            self.delegate?.btnDelete(sender.tag)
//        }
    }
    
    @IBAction func btnDeleteCellAction(_ sender: UIButton) {
//        if delegate2 != nil {
//            self.delegate2?.btnDeleted(sender.tag)
//        }
//
//        guard let tablviewCell = superview as? UITableView else {
//            return
//        }
//        // Get the cell's index path using convert(_:to:)
//        guard let indexPath = tablviewCell.indexPath(for: self) else {
//            return
//        }
//        self.indexPath = indexPath
        
        
    }
    
//    func setUpInputDropDown(){
//            dropDown.makeDropDownIdentifier = "DROP_DOWN"
//            dropDown.cellReusableIdentifier = "DropDownTableViewCell"
//
//        dropDown.makeDropDownDataSourceProtocol = self
////            let cgreact = CGRect(x: self.dropDownView.frame.minX, y: , width: <#T##Int#>, height: <#T##Int#>)
//            dropDown.setUpDropDown(viewPositionReference: (btndropdown.frame), offset: 0)
//            dropDown.nib = UINib(nibName: "DropDownTableViewCell", bundle: nil)
//            dropDown.setRowHeight(height: self.dropDownRowHeight)
//            dropDown.width = 130
//            dropDown.clipsToBounds = true
//            dropDown.layer.cornerRadius = 5
//            self.addSubview(dropDown)
//        }
}

//extension TaskCell: MakeDropDownDataSourceProtocol{
//
//func getDataToDropDown(cell: UITableViewCell, indexPos: Int, makeDropDownIdentifier: String) {
//
//    if makeDropDownIdentifier == "DROP_DOWN"{
//        let customCell = cell as! DropDownTableViewCell
////        customCell.cityImage.image = self.cityModelArr[indexPos].cityImage
//        customCell.cityNameLabel.text = self.titles[indexPos]
//    }
//}
//
//func numberOfRows(makeDropDownIdentifier: String) -> Int {
//    return 1
//}
//
//func selectItemInDropDown(indexPos: Int, makeDropDownIdentifier: String) {
//
//    self.actionIndex = indexPos
//    self.actionType = titles[indexPos]
//
//    self.delegate?.editOrDelete(self.actionType, self.actionIndex, self.indexPath!)
//    self.dropDown.hideDropDown()
//    }
//}
