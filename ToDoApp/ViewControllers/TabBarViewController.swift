//
//  TabBarViewController.swift
//  ToDoApp
//
//  Created by mac on 09/05/2023.
//

import UIKit
import GoogleMobileAds
import StoreKit
import AdSupport
import AppTrackingTransparency

class TabBarViewController: UITabBarController,UITabBarControllerDelegate {
    
    var highInterstitial: GADInterstitialAd?
    var mediumInterstitial: GADInterstitialAd?
    var fullInterstitial: GADInterstitialAd?
    var clickCount = 0
    var selectedTabIndices = [Int]()
    var intertitialAdd: GADInterstitialAd?
    var taskCount = 0
    var addIds = ["ca-app-pub-8414160375988475/4551648","ca-app-pub-8414160375988475/4360076824","ca-app-pub-8414160375988475/6799850985"]
    var addIndex = 0
    var addRun : Bool = false
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 14, *) {
            self.requestTrackingPermission()
        } else {
            // Fallback on earlier versions
        }
        
    
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.backgroundColor = .systemBackground
            tabBarController?.tabBar.standardAppearance = appearance
            tabBarController?.tabBar.scrollEdgeAppearance = appearance
        } else {
            // Fallback on earlier versions
        }
        
//        if let advertisingId = getAdvertisingIdentifier() {
//            print("Advertising Identifier: \(advertisingId)")
//        } else {
//            print("Advertising tracking is disabled.")
//        }
        
        // Do any additional setup after loading the view.
//        let request = GADRequest()
//        GADInterstitialAd.load(withAdUnitID: "ca-app-pub-8414160375988475/4360076824",
//                                    request: request,
//                          completionHandler: { [self] ad, error in
//                            if let error = error {
//                              print("Failed to load interstitial ad with error: \(error.localizedDescription)")
//                                //load medium
//                              return
//                            }
//            self.highInterstitial = ad
//            self.highInterstitial?.fullScreenContentDelegate = self
//            })

    }
    
   

    @available(iOS 14, *)
    func requestTrackingPermission() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                // Handle the user's response to the tracking authorization request
                if status == .authorized {
                    // User granted permission, proceed to get the Advertising Identifier
                    if let advertisingId = self.getAdvertisingIdentifier() {
                        print("Advertising Identifier: \(advertisingId)")
                    } else {
                        print("Unable to retrieve Advertising Identifier.")
                    }
                } else {
                    // User denied permission, handle accordingly
                    print("User denied permission for tracking.")
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        
        
    }
        
    
    func getAdvertisingIdentifier() -> String? {
        guard ASIdentifierManager.shared().isAdvertisingTrackingEnabled else {
            return nil // Advertising tracking is disabled
        }

        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
    
    func loadMediumAdd(completion: @escaping(_ status: Bool) -> Void) {
//        Utilities.show_ProgressHud(view: self.view)
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: "ca-app-pub-8414160375988475/4360076824",
                                    request: request,
                          completionHandler: { [self] ad, error in
                            if let error = error {
                              print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                                //load all Adds
                                completion(false)
                              return
                            }
            self.mediumInterstitial = ad
            self.mediumInterstitial?.fullScreenContentDelegate = self
            completion(true)
            })
    }
    
    func loadMyAdds(_ id: String, completion: @escaping(_ status: Bool) -> Void) {
//        Utilities.show_ProgressHud(view: self.view)
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: id,
                                    request: request,
                          completionHandler: { [self] ad, error in
                            if let error = error {
//                                Utilities.hide_ProgressHud(view: self.view)
                              print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                                //load all Adds
                                completion(false)
                            }
            self.intertitialAdd = ad
            self.intertitialAdd?.fullScreenContentDelegate = self
            completion(true)
            })
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        tabBar.frame.size.height = 150
        tabBar.frame.origin.y = view.frame.height - 150
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        self.navigationController?.navigationBar.isHidden = true
//        self.navigationController?.navigationBar.barTintColor = UIColor.white
        guard let selectedIndex = tabBar.items?.firstIndex(of: item) else { return }
        
        // Check if the selected tab index is already in the selectedTabIndices array
    
        if selectedTabIndices.contains(selectedIndex) {
            selectedTabIndices = [selectedIndex]
            clickCount = 1
        } else {
            selectedTabIndices.append(selectedIndex)
            clickCount += 1
        }
        if clickCount == 3 && self.addRun == false {
            // Perform your action here
            //            if self.intertitialAdd != nil {
            //                self.intertitialAdd?.present(fromRootViewController: self)
            //            }
            self.addRun = true
            var myId = ""
            myId = addIds[addIndex]
            self.loadMyAdds(myId) { status in
                if status {
                    Utilities.hide_ProgressHud(view: self.view)
                    self.intertitialAdd?.present(fromRootViewController: self)
                } else {
                    if (self.addIndex < self.addIds.count - 1) {
                        self.addIndex += 1
                        myId = self.addIds[self.addIndex]
                        self.loadMyAdds(myId) { status in
                            if status {
                                Utilities.hide_ProgressHud(view: self.view)
                                self.intertitialAdd?.present(fromRootViewController: self)
                            } else {
                                self.addIndex += 1
                                myId = self.addIds[self.addIndex]
                                self.loadMyAdds(myId) { status in
                                    if status {
                                        Utilities.hide_ProgressHud(view: self.view)
                                        self.intertitialAdd?.present(fromRootViewController: self)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
        }
        //
    }
}


extension TabBarViewController: GADFullScreenContentDelegate {
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
//        self.loadMediumAdd()
       print("Ad did fail to present full screen content.")
        
//        if (self.addIndex < addIds.count - 1) {
//                        self.addIndex += 1
//            self.loadMyAdds("\(self.addIds[self.addIndex])")
//        }
     }

     /// Tells the delegate that the ad will present full screen content.
     func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
       print("Ad will present full screen content.")
     }

     /// Tells the delegate that the ad dismissed full screen content.
     func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
       print("Ad did dismiss full screen content.")
         
     }
}
