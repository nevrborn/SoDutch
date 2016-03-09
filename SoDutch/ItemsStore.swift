//
//  ItemsStore.swift
//  SoDutch
//
//  Created by Jarle Matland on 07.03.2016.
//  Copyright © 2016 Donkey Monkey. All rights reserved.
//

import UIKit
import CoreLocation

class ItemsStore {
    
    // Create an array where all the items are stored in
    var allItems = [Item]()
    
    // Function that will retrieve all stored items in allItems[]
    init() {
        if let archivedItems = NSKeyedUnarchiver.unarchiveObjectWithFile(itemArchiveURL.path!) as? [Item] {
            allItems += archivedItems
        }
    }
    
    // Creates a unique URL to store the items to
    let itemArchiveURL: NSURL = {
        let documentsDirectories = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.URLByAppendingPathComponent("items.achive")
    }()
    
    // Adds an item to the allitems[] array
    func addItem(newTitle: String, newDescription: String, newLocation: CLLocation) -> Item {
        
        let newItem = Item(title: newTitle, itemDescription: newDescription, location: newLocation)
        
        allItems.append(newItem)
        
        return newItem
    }
    
    // Saves the changes made to the allItems[] array
    func saveChanges() -> Bool {
        print("Saving items to: \(itemArchiveURL.path!)")
        return NSKeyedArchiver.archiveRootObject(allItems, toFile: itemArchiveURL.path!)
    }
    
    
}
