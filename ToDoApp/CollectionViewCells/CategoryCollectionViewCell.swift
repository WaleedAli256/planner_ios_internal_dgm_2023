//
//  CategoryCollectionViewCell.swift
//  ToDoApp
//
//  Created by mac on 31/03/2023.
//

import UIKit

protocol CategoryCollectionViewCellDelegate: AnyObject {
    func editOrDelete(_ actionType: String, _ actionIndex: Int, _ cellIndex: IndexPath)
}

class CategoryCollectionViewCell: UICollectionViewCell, UITableViewDelegate {
    
    @IBOutlet weak var catImage: UIImageView!
    @IBOutlet weak var catName: UILabel!
    @IBOutlet weak var catDesc: UILabel!
    @IBOutlet weak var catBGView: UIView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var btndropdown: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    var actionIndex = 0
    var actionType = ""
    var titles = ["Edit","Delete"]
    var delegate: CategoryCollectionViewCellDelegate?
    let dropDown = MakeDropDown()
    var dropDownRowHeight: CGFloat = 40
    var indexPath: IndexPath?
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

extension CategoryCollectionViewCell: MakeDropDownDataSourceProtocol{

func getDataToDropDown(cell: UITableViewCell, indexPos: Int, makeDropDownIdentifier: String) {
    if makeDropDownIdentifier == "DROP_DOWN"{
        let customCell = cell as! DropDownTableViewCell
        //            customCell.cityImage.image = self.cityModelArr[indexPos].cityImage
        customCell.cityNameLabel.text = self.titles[indexPos]
    }

}

func numberOfRows(makeDropDownIdentifier: String) -> Int {
    return 2
}

func selectItemInDropDown(indexPos: Int, makeDropDownIdentifier: String) {
    self.actionIndex = indexPos
    self.actionType = titles[indexPos]
    self.delegate?.editOrDelete(self.actionType, self.actionIndex, self.indexPath!)
    self.dropDown.hideDropDown()

    }

}
