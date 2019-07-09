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
    
    private struct Constants {
        
        static let cornerRaius: CGFloat = 10
    }
    
    @IBOutlet var presentImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        presentImageView.layer.cornerRadius = Constants.cornerRaius
    }
    
    #warning("TODO - image url")
//        func config(_ imageURL: String, aricle: Article) {
//            titleLabel.text = aricle.title
//            guard let imageURL = URL(string: aricle.media?.first?.mediaMetadata?.first?.url ?? "") else {
//
//                return
//            }
//            Nuke.loadImage(with: imageURL, into: presentImageView)
//        }
//
//        func configFavoriteCell(aricle: Article) {
//            titleLabel.text = aricle.title
//            guard let articleImage = aricle.imageURL else { return }
//            guard let imageURL = URL(string: articleImage) else {
//
//                return
//            }
//            Nuke.loadImage(with: imageURL, into: presentImageView)
//        }
    
            func configFavoriteCell(aricle: ArticleProtocol) {
                titleLabel.text = aricle.title
                guard let articleImage = aricle.imageURL else { return }
                guard let imageURL = URL(string: articleImage) else {
    
                    return
                }
                Nuke.loadImage(with: imageURL, into: presentImageView)
            }
    
    
}
