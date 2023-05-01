//
//  SettingViewController.swift
//  ToDoApp
//
//  Created by mac on 10/04/2023.
//

import UIKit
import StoreKit

class SettingViewController: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    
    var selectedIndex = -1
    
    var labelText = ["About","Rate us","Share app","Privacy policy"]
    var tblImages = ["icon-about","icon-rate","icon-share","icon-privacy"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblView.delegate = self
        self.tblView.dataSource = self
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
    }
    
    func shareMyApp() {
        
        if let urlStr = NSURL(string: "https://apps.apple.com/us/app/idxxxxxxxx?ls=1&mt=8") {
            let objectsToShare = [urlStr]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                if let popup = activityVC.popoverPresentationController {
                    popup.sourceView = self.view
                    popup.sourceRect = CGRect(x: self.view.frame.size.width / 2, y: self.view.frame.size.height / 4, width: 0, height: 0)
                }
            }
            
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    
    func rateUsApp() {
        
        guard let url = URL(string: "https://centumsols.com/privacy-policy") else {
                  return //be safe
                }
//           let url = URL(string: "https://centumsols.com/privacy-policy")
           if #available(iOS 10.0, *) {
               UIApplication.shared.open(url, options: [:], completionHandler: nil)
           } else {
               UIApplication.shared.openURL(url)
           }
    }
    

}


extension SettingViewController: UITableViewDelegate,UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.labelText.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tblView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as? SettingsCell else {
            return UITableViewCell()
        }
        
        cell.aboutlbl.text = labelText[indexPath.row]
        cell.iconImg.image = UIImage(named: tblImages[indexPath.row])
        if selectedIndex == indexPath.row {
            cell.aboutlbl.textColor = UIColor.white
            cell.iconImg.tintColor = UIColor.white
            cell.innerView.backgroundColor = UIColor(named: "primary-color")
            cell.dividerView.backgroundColor = UIColor(named: "low-color")?.withAlphaComponent(0.2)
            
            if indexPath.row == 0 {
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "AboutUsViewController") as! AboutUsViewController
                self.navigationController?.pushViewController(controller, animated: true)
                
            } else if indexPath.row == 1 {
                SKStoreReviewController.requestReview()
                
            } else if indexPath.row == 2 {
                self.shareMyApp()
                
            } else if indexPath.row == 3 {
                self.rateUsApp()
            }
            
            
        }else{
            cell.aboutlbl.textColor = UIColor.black
            cell.iconImg.tintColor = UIColor(named: "primary-color")
            cell.innerView.backgroundColor = UIColor(named: "ViewBGLight")
            cell.dividerView.backgroundColor = UIColor(named: "low-color")

            
        }
       
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if selectedIndex == indexPath.row {
            selectedIndex = -1
        } else {
            selectedIndex = indexPath.row
        }

        self.tblView.reloadData()
    }
}


class SettingsCell: UITableViewCell {
        
    @IBOutlet weak var aboutlbl: UILabel!
    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var dividerView: UIView!
    @IBOutlet weak var innerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
