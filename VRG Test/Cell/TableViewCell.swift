//
//  TableViewCell.swift
//  VRG Test
//
//  Created by Pasha Moroz on 6/28/19.
//  Copyright © 2019 Pavel Moroz. All rights reserved.
//

import UIKit
import Alamofire
import Nuke

class TableViewCell: UITableViewCell {
    
    @IBOutlet var presentImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    
    func config(_ imageURL: String, aricle: Article) {
        titleLabel.text = aricle.title
        presentImageView.layer.cornerRadius = 10
        guard let imageURL = URL(string: aricle.media?.first?.mediaMetadata?.first?.url ?? "") else {
            
            return
        }
        Nuke.loadImage(with: imageURL, into: presentImageView)
    }
    
    func configFavoriteCell(aricle: Articles) {
        titleLabel.text = aricle.title
        presentImageView.layer.cornerRadius = 10
        guard let imageURL = URL(string: aricle.image!) else {
            
            return
        }
        Nuke.loadImage(with: imageURL, into: presentImageView)
    }
}
