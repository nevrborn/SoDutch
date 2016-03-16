//
//  PageDataViewController.swift
//  SoDutch
//
//  Created by Jarle Matland on 10.03.2016.
//  Copyright © 2016 Donkey Monkey. All rights reserved.
//

import UIKit

class PageDataViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    var imageObject: UIImage?
    var titleObject: String?
    var descriptionObject: String?
    var itemKey: String?
    
    var itemsStore: ItemsStore!
    var item: Item!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.imageView.image = imageObject
        self.titleLabel.text = titleObject
        self.descriptionLabel.text = descriptionObject
        
    }
    
}
