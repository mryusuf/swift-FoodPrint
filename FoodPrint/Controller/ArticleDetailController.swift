//
//  ArticleDetailController.swift
//  FoodPrint
//
//  Created by Indra Permana on 28/04/19.
//  Copyright © 2019 Indra Permana. All rights reserved.
//

import UIKit

class ArticleDetailController: UIViewController {
    
    
    @IBOutlet weak var articleContent: UILabel!
    @IBOutlet weak var articleTime: UILabel!
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var articleImage: UIImageView!
    
    var content = "Maaf, Konten tidak tersedia :("
    var time = ""
    var author = ""
    var arcTitle = ""
    var urlToImage = ""
   
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.view.tintColor = .white
        self.navigationItem.largeTitleDisplayMode = .never
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        articleContent.text = content
        articleTime.text = "\(time) by \(author)"
        articleTitle.text = arcTitle
        
        if urlToImage != "" {
        if let imageURL = URL(string: urlToImage) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        self.articleImage.image = image!
                    }
                }
            }
        }
        }else {
            articleImage.image = #imageLiteral(resourceName: "article_detail_default")
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
    }
}
