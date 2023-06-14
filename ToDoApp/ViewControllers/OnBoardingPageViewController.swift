//
//  OnBoardingPageViewController.swift
//  FoneWire
//
//  Created by Muhammad Junaid Butt on 27/06/2018.
//  Copyright © 2018 Trev Global Limited. All rights reserved.
//

import UIKit

class OnBoardingPageViewController: UIPageViewController {

    weak var onBoardingDelegate: OnBoardingPageViewControllerDelegate?
    
    private(set) lazy var pages: [UIViewController] = {
        // The view controllers will be shown in this order
        return [self.onBoardingContentController(identifier: "ViewController1"),
                self.onBoardingContentController(identifier: "ViewController2"),
                self.onBoardingContentController(identifier: "ViewController3"),
               ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
        if let initialViewController = pages.first {
            self.scrollToViewController(viewController: initialViewController)
        }
        
        onBoardingDelegate?.onBoardingPageViewController(onBoardingPageViewController: self, didUpdatePageCount: pages.count)
    }
    
    /**
     Scrolls to the next view controller.
     */
    func scrollToNextViewController() {
        if let visibleViewController = viewControllers?.first,
            let nextViewController = pageViewController(self, viewControllerAfter: visibleViewController) {
            self.scrollToViewController(viewController: nextViewController)
        }
    }
    
    /**
     Scrolls to the view controller at the given index. Automatically calculates
     the direction.
     
     - parameter newIndex: the new index to scroll to
     */
    func scrollToViewController(index newIndex: Int) {
        if let firstViewController = viewControllers?.first,
            let currentIndex = self.pages.index(of: firstViewController) {
            let direction: UIPageViewController.NavigationDirection = newIndex >= currentIndex ? .forward : .reverse
            let nextViewController = self.pages[newIndex]
            self.scrollToViewController(viewController: nextViewController, direction: direction)
        }
    }
    
    private func onBoardingContentController(identifier: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
    
    /**
     Scrolls to the given 'viewController' page.
     
     - parameter viewController: the view controller to show.
     */
    private func scrollToViewController(viewController: UIViewController,
                                        direction: UIPageViewController.NavigationDirection = .forward) {
        DispatchQueue.main.async {
            self.onBoardingDelegate!.onBoardingPageViewController(onBoardingPageViewController: self,
                                                                    willTransitionTo: [viewController])
            self.setViewControllers([viewController], direction: direction, animated: true, completion: { (finished) in
                self.notifyTutorialDelegateOfNewIndex()
            })
        }
    }
    
    /**
     Notifies '_tutorialDelegate' that the current page index was updated.
     */
    func notifyTutorialDelegateOfNewIndex() {
        if let firstViewController = viewControllers?.first, let index = self.pages.index(of: firstViewController) {
            onBoardingDelegate?.onBoardingPageViewController(onBoardingPageViewController: self, didUpdatePageIndex: index)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension OnBoardingPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        self.notifyTutorialDelegateOfNewIndex()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        onBoardingDelegate?.onBoardingPageViewController(onBoardingPageViewController: self,
                                                           willTransitionTo: pendingViewControllers)
    }
}

extension OnBoardingPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = self.pages.index(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else { return nil }
        
        guard self.pages.count > previousIndex else { return nil }
        
        return self.pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = self.pages.index(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < self.pages.count else { return nil }
        
        guard self.pages.count > nextIndex else { return nil }
        
        return self.pages[nextIndex]
    }
}

protocol OnBoardingPageViewControllerDelegate: class {
    /**
     Called when the number of pages is updated.
     
     - parameter tutorialPageViewController: the TutorialPageViewController instance
     - parameter count: the total number of pages.
     */
    func onBoardingPageViewController(onBoardingPageViewController: OnBoardingPageViewController,
                                      didUpdatePageCount count: Int)
    
    /**
     Called when the current index is updated.
     
     - parameter tutorialPageViewController: the TutorialPageViewController instance
     - parameter index: the index of the currently visible page.
     */
    func onBoardingPageViewController(onBoardingPageViewController: OnBoardingPageViewController,
                                      didUpdatePageIndex index: Int)
    
    func onBoardingPageViewController(onBoardingPageViewController: OnBoardingPageViewController,
                                      willTransitionTo pendingViewControllers: [UIViewController])
}
