//
//  HomeTableViewCell.swift
//  ToDoApp
//
//  Created by mac on 30/03/2023.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var colView: UICollectionView!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var tasksStackView: UIStackView!
    
    static var onDoneBlock : ((Int,Int,Bool) -> Void)?
    var didTapCategory:(() -> Void)?
    var checked = Set<IndexPath>()
    var selcted = -1
    var index = IndexPath()
    var selectedTableIndex = Int()
    var selectedCollectionIndex = Int()
    
    var tasks: [CatTasks] = []
    var myFinalCategories = [String:[Task]]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.colView.delegate = self
        self.colView.dataSource = self
                
//        for item in tasks {
//            if myFinalCategories[item.categoryName!] == nil{
//                myFinalCategories[item.categoryName!] = [item]
//            }else{
//                myFinalCategories[item.categoryName!]!.append(item)
//            }
//        }
        
//        for dic in myFinalCategories{
//            let task = (dic.value as? [Task])!
//            self.tasks.append(CatTasks(catName: dic.key, tasks: task))
//        }
//        for cat in tasks {
//            for task in cat.tasks {
//                self.loadTaskView(tag: 1, task: task)
//            }
//        }
    }
    
     func loadTaskView(tag : Int,task:Task){
        let cView = TasksView()
        cView.tag = tag
        cView.task = task
        
        self.tasksStackView.addArrangedSubview(cView)
         self.tasksStackView.spacing = 8
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func transformCellToLarge() {
        UIView.animate(withDuration: 0.1) {
            self.timeLbl.textColor = .black
            self.timeLbl.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        }
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    func transformCellToStandard() {
        UIView.animate(withDuration: 0.1) {
            self.timeLbl.textColor = UIColor(named: "LightDarkTextColor")!
            self.timeLbl.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        }
    }

}

extension HomeTableViewCell: UICollectionViewDelegate,UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tasks.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCategoryCell", for: indexPath) as? HomeCategoryCell else {
            return UICollectionViewCell()
        }
        cell.bgView.clipsToBounds = true
        cell.bgView.layer.cornerRadius = 4
        
        if index.row == selectedTableIndex{
            if selectedCollectionIndex == indexPath.row{
                cell.seletedCatView.isHidden = false
            }else{
                cell.seletedCatView.isHidden = true
            }
        }else{
            cell.seletedCatView.isHidden = true
        }
        let silk = self.tasks[indexPath.row]
        
        cell.catLbl.text = silk.catName
        if let color = silk.tasks.first?.colorCode {
            cell.bgView.backgroundColor = UIColor(hexString: color)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        HomeTableViewCell.onDoneBlock?(indexPath.row,index.row , true)
    }
}

class HomeCategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var catLbl: UILabel!
    @IBOutlet weak var seletedCatView: UIView!
        
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

struct CatTasks {
    var catName:String
    var tasks:[Task]
}
