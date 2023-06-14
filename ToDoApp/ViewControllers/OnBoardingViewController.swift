//
//  OnBoardingViewController.swift
//  FoneWire
//
//  Created by mac on 18/05/2017.
//  Copyright © 2017 Trev Global Limited. All rights reserved.
//

import UIKit
import AdSupport

class OnBoardingViewController: UIViewController {
    
//    @IBOutlet weak var lblOnBoarding: UILabel!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var btnSignin: UIButton!
    @IBOutlet var btnSignup: UIButton!
    @IBOutlet weak var constraintDotsBottom: NSLayoutConstraint!
    var showLogin: Bool = false
//    var onBoardingStrings = ["Hello, replace your bank with\nour app!",
//                                      "Download FoneWire app & open an account in minutes without going to a bank",
//                                      "Activate your card from the app and use it all over the world!",
//                                      "Send money instantly and withdraw from an ATM with or without a card!",
//                                      "Realtime push notifications for all your transactions, on your phone or smartwatch"]
    
    var onBoardingPageViewController: OnBoardingPageViewController? {
        didSet {
            onBoardingPageViewController?.onBoardingDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let adID = getAdvertisingIdentifier() {
            print("Advertising Identifier: \(adID)")
        } else {
            print("Advertising tracking is disabled.")
        }
//        self.setupNavBar()
//        pageControl.numberOfPages = 3
        //Show Text & Image
//        self.lblOnBoarding.text = self.onBoardingStrings[0]
//        if self.showLogin == true {
//            self.perform(#selector(self.showLoginVC), with: nil, afterDelay: 0.5)
//        }
    }
    
    func getAdvertisingIdentifier() -> String? {
        guard ASIdentifierManager.shared().isAdvertisingTrackingEnabled else {
            return nil
        }
        
        let adIdentifier = ASIdentifierManager.shared().advertisingIdentifier
        return adIdentifier.uuidString
    }

    
    func setupNavBar() {
        self.navigationController?.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if IS_IPHONE5 {
//            self.constraintDotsBottom.constant = 12
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
//    func showLoginVC() {
//        self.performSegue(withIdentifier: "LoginSegue", sender: nil)
//    }
    
//    @IBAction func onBtnSignupTapped(_ sender: AnyObject) {
//        let countryNameVC = storyboard?.instantiateViewController(withIdentifier: "countryNameVC") as! CountryNamesViewController
//        self.navigationController?.show(countryNameVC, sender: self)
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let onBoardingPageViewController = segue.destination as? OnBoardingPageViewController {
            self.onBoardingPageViewController = onBoardingPageViewController
        }
    }
}

extension OnBoardingViewController: OnBoardingPageViewControllerDelegate {
    func onBoardingPageViewController(onBoardingPageViewController: OnBoardingPageViewController,
                                      didUpdatePageCount count: Int) {
        pageControl.numberOfPages = count
    }
    
    func onBoardingPageViewController(onBoardingPageViewController: OnBoardingPageViewController,
                                      didUpdatePageIndex index: Int) {
//        self.lblOnBoarding.text = self.onBoardingStrings[index]
        UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
//            self.lblOnBoarding.alpha = 1
        }, completion: nil)
        pageControl.currentPage = index
    }
    
    func onBoardingPageViewController(onBoardingPageViewController: OnBoardingPageViewController,
                                       willTransitionTo pendingViewControllers: [UIViewController]) {
        UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
//            self.lblOnBoarding.alpha = 0
        }, completion: nil)
    }
}

