//
//  ItemViewController.swift
//  SoDutch
//
//  Created by Jarle Matland on 08.03.2016.
//  Copyright © 2016 Donkey Monkey. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var itemsStore = ItemsStore()
    var imageStore = ImageStore()
    
    @IBOutlet var tableView: UITableView!
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsStore.allItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as! ItemCell
        
        let itemTitle = itemsStore.allItems[indexPath.row].itemTitle
        let itemDescription = itemsStore.allItems[indexPath.row].itemDescription
        //let itemImage = itemsStore.allItems[indexPath.row].editedImage!
        
        // Configure Cell
        cell.itemTitle.text = itemTitle
        cell.itemDescription.text = itemDescription
        //cell.itemImage.image = itemImage
        
        
        return cell
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    
    
}
