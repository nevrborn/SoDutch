//
//  PageViewController.swift
//  SoDutch
//
//  Created by Jarle Matland on 10.03.2016.
//  Copyright © 2016 Donkey Monkey. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDelegate {
    
    var pageViewController: UIPageViewController?
    
    var itemsStore: ItemsStore!
    var item: Item!
    
    override func viewDidLoad() {
        
        // Sets the functionality of the swipe list
        self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pageViewController!.delegate = self
        
        let startingViewController: PageDataViewController = self.modelController.viewControllerAtIndex(0, storyboard: self.storyboard!)!
        let viewControllers = [startingViewController]
        self.pageViewController!.setViewControllers(viewControllers, direction: .forward, animated: false, completion: {done in })
        
        self.pageViewController!.dataSource = self.modelController
        
        self.addChildViewController(self.pageViewController!)
        self.view.addSubview(self.pageViewController!.view)
        
        let width = startingViewController.view.frame.width
        let height = startingViewController.view.frame.height

        self.pageViewController!.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        self.pageViewController!.didMove(toParentViewController: self)
        
        self.view.gestureRecognizers = self.pageViewController!.gestureRecognizers
    }
    
    // Sets spine location of the interface
    func pageViewController(_ pageViewController: UIPageViewController, spineLocationFor orientation: UIInterfaceOrientation) -> UIPageViewControllerSpineLocation {
        
        let currentViewController = self.pageViewController!.viewControllers![0]
        let viewControllers = [currentViewController]
        self.pageViewController!.setViewControllers(viewControllers, direction: .forward, animated: false, completion: {done in })
        
        self.pageViewController!.isDoubleSided = false
        return .min
    }

    var modelController: ItemsStore {
        // Return the model controller object, creating it if necessary.
        if _modelController == nil {
            _modelController = ItemsStore()
        }
        return _modelController!
    }
    
    var _modelController: ItemsStore? = nil
    
}
