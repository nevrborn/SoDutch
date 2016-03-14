//
//  PageDataViewController.swift
//  SoDutch
//
//  Created by Jarle Matland on 10.03.2016.
//  Copyright © 2016 Donkey Monkey. All rights reserved.
//

import UIKit

class PageDataViewController: UIViewController {
    
    var imageObject: UIImage?
    var infoObject: String?
    var descriptionObject: String?
    
    var itemsStore: ItemsStore!
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    @IBAction func listViewSegment(sender: UISegmentedControl) {
        
        let segmentedControl = sender
        
        if segmentedControl.selectedSegmentIndex == 0 {
            performSegueWithIdentifier("GoToListView", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "GoToListView" {
            
            let itemViewController = segue.destinationViewController as! ItemViewController
            
            itemViewController.itemsStore = itemsStore
            
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.imageView.image = imageObject
        self.infoLabel!.text = infoObject
    }

}
