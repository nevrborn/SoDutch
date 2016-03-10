//
//  DetailViewController.swift
//  SoDutch
//
//  Created by Jarle Matland on 10.03.2016.
//  Copyright © 2016 Donkey Monkey. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController{
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    var item: Item!
    var itemsStore: ItemsStore!
    
    func setLabels() {
        
        let itemImage = item.editedImage
        
        titleLabel.text = item.itemTitle
        descriptionLabel.text = item.itemDescription
        
        imageView.image = itemImage
    }
    
    override func viewDidLoad() {
        setLabels()
    }
    
   
}
