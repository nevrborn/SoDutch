//
//  ItemsStore.swift
//  SoDutch
//
//  Created by Jarle Matland on 07.03.2016.
//  Copyright © 2016 Donkey Monkey. All rights reserved.
//

import UIKit
import CoreLocation

class ItemsStore: NSObject, UIPageViewControllerDataSource {
    
    var allItems = [Item]()
    
    // Function that will retrieve all stored items in allItems[]
    override init() {
        if let archivedItems = NSKeyedUnarchiver.unarchiveObject(withFile: itemArchiveURL.path) as? [Item] {
            allItems += archivedItems
        }
    }
    
    // Creates a unique URL to store the items to
    let itemArchiveURL: URL = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("items.achive")
    }()
    
    // Adds an item to the allitems[] array
    func addItem(_ newTitle: String, newDescription: String, newLocation: CLLocation) -> Item {
        
        let newItem = Item(title: newTitle, itemDescription: newDescription, location: newLocation)
        allItems.append(newItem)
        
        return newItem
    }
    
    // Saves the changes made to the allItems[] array
    func saveChanges() -> Bool {
        return NSKeyedArchiver.archiveRootObject(allItems, toFile: itemArchiveURL.path)
    }
    
    
    // ** Functions to control the page based view ***
    
    func viewControllerAtIndex(_ index: Int, storyboard: UIStoryboard) -> PageDataViewController? {
        // Return the data view controller for the given index.
        if (allItems.count == 0) || (index >= allItems.count) {
            return nil
        }
        
        // Create a new view controller and pass suitable data.
        let dataViewController = storyboard.instantiateViewController(withIdentifier: "PageDataViewController") as! PageDataViewController
        dataViewController.imageObject = allItems[index].editedImage
        dataViewController.titleObject = allItems[index].itemTitle
        dataViewController.descriptionObject = allItems[index].itemDescription
        dataViewController.item = allItems[index]
        return dataViewController
    }
    
    func indexOfViewController(_ viewController: PageDataViewController) -> Int {
        // Return the index of the given data view controller.
        return allItems.index(of: viewController.item) ?? NSNotFound
    }
    
    // Returns view controller before current view controller
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! PageDataViewController)
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index -= 1
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }
    
    // Returns view controller after current view controller
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! PageDataViewController)
        if index == NSNotFound {
            return nil
        }
        
        index += 1
        if index == allItems.count {
            return nil
        }
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }
    
    
}
