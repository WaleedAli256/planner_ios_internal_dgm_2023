//
//  TestViewController.swift
//  ToDoApp
//
//  Created by mac on 07/04/2023.
//

import UIKit

class TestViewController: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    var selectedIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


}



extension TestViewController: UITableViewDelegate,UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 6
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tblView.dequeueReusableCell(withIdentifier: "TestTableCell", for: indexPath) as? TestTableCell else {
            return UITableViewCell()
        }
        if selectedIndex == indexPath.row {
            cell.lblDetail.isHidden = false
            cell.lblDetail.text = "Detail here for to do task daily weekly or yearly you can manage in the detail text"
        }else{
            cell.lblDetail.isHidden = true
            cell.lblDetail.text = ""
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if selectedIndex == indexPath.row{
            selectedIndex = -1
        }else{
            self.selectedIndex = indexPath.row
        }

        self.tblView.reloadData()
    }
}
