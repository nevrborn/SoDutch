//
//  AppDelegate.swift
//  SoDutch
//
//  Created by Jarle Matland on 06.03.2016.
//  Copyright © 2016 Donkey Monkey. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var locationManager: CLLocationManager?
    
    let itemsStore = ItemsStore()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        
        let tabController = window!.rootViewController as! UITabBarController
        
        let viewControllerMap = tabController.viewControllers![0] as! MapViewController
        viewControllerMap.itemsStore = itemsStore
        
        let viewControllerItem = tabController.viewControllers![1] as! AddItemViewController
        viewControllerItem.itemsStore = itemsStore
        
        let viewControllerListContainer = tabController.viewControllers![2].childViewControllers[0] as! ListContainerViewController
        viewControllerListContainer.itemsStore = itemsStore
        
        let viewControllerList = storyboard.instantiateViewController(withIdentifier: "ItemViewController") as! ItemViewController
        viewControllerList.itemsStore = itemsStore
        
        let viewControllerPage = storyboard.instantiateViewController(withIdentifier: "PageViewController") as! PageViewController
        viewControllerPage.itemsStore = itemsStore
        
        let viewControllerPageData = storyboard.instantiateViewController(withIdentifier: "PageDataViewController") as! PageDataViewController
        viewControllerPageData.itemsStore = itemsStore
        
        return true
    }
    
}

