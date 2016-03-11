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
    @IBOutlet var likesLabel: UILabel!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var adressLabel: UILabel!
    
    var hasLikeditem = false
    var item: Item!
    var itemsStore: ItemsStore!
    var heartImage: UIImage?
    
    func setLabels() {
        
        let itemImage = item.editedImage
        
        titleLabel.text = item.itemTitle
        descriptionLabel.text = item.itemDescription
        likesLabel.text = String(item.likes)
        adressLabel.text = item.addressString
        
        imageView.image = itemImage
    }
    
    @IBAction func likeItem(sender: UIButton) {

        if hasLikeditem == false {
            item.likes += 1
            hasLikeditem = true
            heartImage = UIImage(named: "redheart.png")
        } else if hasLikeditem == true {
            item.likes -= 1
            hasLikeditem = false
            heartImage = UIImage(named: "heart.png")
        }
        
        likeButton.imageView!.image = heartImage
        likesLabel.text = String(item.likes)

    }
    
    override func viewDidLoad() {
        setLabels()
    }
    
    
}
