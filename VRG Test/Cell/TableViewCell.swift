//
//  TableViewCell.swift
//  VRG Test
//
//  Created by Pasha Moroz on 6/28/19.
//  Copyright © 2019 Pavel Moroz. All rights reserved.
//

import UIKit
import Alamofire

class TableViewCell: UITableViewCell {

    @IBOutlet var presentImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    
    func config(_ imageURL: String, aricle: Article) {
        
    self.titleLabel.text = aricle.title
        presentImageView.layer.cornerRadius = 10
        
        NetworkManager.fetchDataImage(url: imageURL) { (image) in
            
            DispatchQueue.main.async {
                self.presentImageView?.image = image
            }
        }
    }

}
