//
//  ArticleHomeCollectionViewCell.swift
//  FoodPrint
//
//  Created by Indra Permana on 25/04/19.
//  Copyright © 2019 Indra Permana. All rights reserved.
//

import UIKit

class ArticleHomeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var backgroundColorView: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColorView.backgroundColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 0.5473298373)
        articleTitle.font = UIFont.boldSystemFont(ofSize: 20)
        layer.shadowRadius = 1
        layer.shadowOpacity = 0.55
        layer.shadowOffset = CGSize (width: 2, height: 4)
        
        self.clipsToBounds = false
    }
    
}
