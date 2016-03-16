//
//  DetailViewController.swift
//  SoDutch
//
//  Created by Jarle Matland on 10.03.2016.
//  Copyright © 2016 Donkey Monkey. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var adressLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    var item: Item!
    var itemsStore: ItemsStore!
    

    @IBAction func goToMap(sender: UIButton) {
        
        let tabBarController = self.tabBarController
        let mapDetailViewController = tabBarController?.childViewControllers[0] as! MapViewController
        
        mapDetailViewController.itemTitleFromDetailView = titleLabel.text!
        
        mapDetailViewController.comingFromDetailView = true
        
        tabBarController?.selectedIndex = 0
    }
    
    func setLabels() {
        
        let itemImage = item.editedImage
        
        titleLabel.text = item.itemTitle
        descriptionLabel.text = item.itemDescription
        adressLabel.text = item.addressString
        dateLabel.text = item.dateCreated
        
        imageView.image = itemImage
        
        imageView.layer.shadowColor = UIColor.blackColor().CGColor
        imageView.layer.shadowOpacity = 1
        imageView.layer.shadowOffset = CGSizeMake(4, 5)
        imageView.layer.shadowRadius = 10
    }
    
    override func viewDidLoad() {
        setLabels()
    }
    
    
}
