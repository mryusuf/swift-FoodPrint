//
//  ViewController.swift
//  FoodPrint
//
//  Created by Indra Permana on 24/04/19.
//  Copyright © 2019 Indra Permana. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var articleCollectionView: UICollectionView!
    let cellScalingHeight: CGFloat = 1
    let cellScalingWidth: CGFloat = 1
    let image: UIImage = #imageLiteral(resourceName: "Screen Shot 2019-04-16 at 14.58.49")
    @IBOutlet weak var errorLabel: UILabel!
    
    // MARK: set newsapi.org key here
    final let apiKey = ""
    var url:URL?
    
    var articles = [Article]()
    var topArticle = [Article]()
    let screenHeight = UIScreen.main.bounds.height
    var scrollViewContentHeight: CGFloat = 0
    
    @IBOutlet weak var articleTableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.title = "FoodPrint"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        self.tabBarController?.tabBar.isHidden = false
        tabBarController?.tabBar.tintColor = #colorLiteral(red: 0.8405865431, green: 0.3502758741, blue: 0, alpha: 1)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        url = URL(string: "https://newsapi.org/v2/everything?q=makanan&apiKey=\(apiKey)")
        downloadJson()

        let insetY = (articleCollectionView.bounds.height - articleCollectionView.bounds.height) / 2.0
        
        let layout = articleCollectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: articleCollectionView.bounds.width, height: articleCollectionView.bounds.height)
        articleCollectionView?.contentInset = UIEdgeInsets(top: insetY, left: 20.0, bottom: insetY, right: 20.0)
        
        articleCollectionView?.dataSource = self
        articleCollectionView?.delegate = self
        
        articleTableView.separatorStyle = .none
        articleTableView.dataSource = self
        articleTableView.delegate = self
        articleTableView.bounces = false
        scrollView.delegate = self
        scrollView.bounces = false
        scrollViewContentHeight = UIScreen.main.bounds.height + articleTableView.estimatedRowHeight
    }

    
    public func cropPic(image: UIImage, width: Double, height: Double) ->UIImage {
        
        let cgimage = image.cgImage!
        let contextImage = UIImage(cgImage: cgimage)
        let contextSize: CGSize = contextImage.size
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgWidth: CGFloat = CGFloat(width)
        var cgHeight: CGFloat = CGFloat(height)
        
        if contextSize.width > contextSize.height {
            posX = ( (contextSize.width - contextSize.height) / 2)
            posY = 0
            cgWidth = contextSize.height
            cgHeight = contextSize.height
        } else {
            posX = 0
            posY = ( (contextSize.height - contextSize.width) / 2)
            cgWidth = contextSize.width
            cgHeight = contextSize.width
            
            
        }
        
        let rect: CGRect = CGRect(x: posX, y:posY, width: cgWidth, height: cgHeight)
        
        let imageRef: CGImage = cgimage.cropping(to: rect)!
        
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }
    
    
    func downloadJson() {
        guard let downloadUrl = url else { return }
        URLSession.shared.dataTask(with: downloadUrl) { (data, urlResponse, error) in
            guard let responsData = data, error == nil, urlResponse != nil else { print("Something Wrong")
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let downloadedArticles = try decoder.decode(Articles.self, from: responsData)
                if (downloadedArticles.totalResults ?? 0 > 0) {
                    self.articles = (downloadedArticles.articles ?? nil)!
                    if self.articles.count > 0 {
                        self.topArticle = [(self.articles[3])]
                        self.articles.remove(at: 3)
                        self.articles.remove(at: 0)
                    }
                    DispatchQueue.main.async {
                        self.articleCollectionView.reloadData()
                        self.articleTableView.reloadData()
                    }
                } else {
                    print("Error load data")
                    DispatchQueue.main.async {
                        self.scrollView.isHidden = true
                        self.errorLabel.text = "Error Mengambil Data"
                    }
                    
                }
                
            } catch {
                print("error occured")
            }
            }.resume()
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(topArticle.count)
        return topArticle.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticleCell", for: indexPath) as! ArticleHomeCollectionViewCell
        
        cell.articleTitle?.text = topArticle[indexPath.row].title
        let imageToURL: String? = (topArticle[indexPath.row].urlToImage != nil) ? topArticle[indexPath.row].urlToImage: ""
        if let imageURL = URL(string: imageToURL!) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.articleImage?.image = image

                    }
                }
            }
        } else {
            cell.articleImage?.image = #imageLiteral(resourceName: "nasi-3")
        }
        
        return cell
    }
    
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let target = storyboard?.instantiateViewController(withIdentifier: "ArticleDetailController") as? ArticleDetailController
        target?.content = topArticle[indexPath.row].content ?? target!.content
        target?.time = topArticle[indexPath.row].publishedAt ?? ""
        target?.author = topArticle[indexPath.row].author ?? ""
        target?.arcTitle = topArticle[indexPath.row].title ?? ""
        target?.urlToImage = topArticle[indexPath.row].urlToImage ?? ""
        
        self.navigationController?.pushViewController(target!, animated: true)
        
    }
    
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        
        if scrollView == self.scrollView {
            if yOffset >= scrollViewContentHeight - screenHeight {
                scrollView.isScrollEnabled = false
                articleTableView.isScrollEnabled = true
            }
        }
        
        if scrollView == self.articleTableView {
            if yOffset <= 0 {
                self.scrollView.isScrollEnabled = true
                self.articleTableView.isScrollEnabled = false
            }
        }
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count articles in tableview: \(articles.count)")
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticlesCell", for: indexPath) as? ArticlesTableViewCell else {
            return UITableViewCell()
        }
        
        cell.titleLabel?.text = articles[indexPath.row].title
        cell.dateLabel?.text = articles[indexPath.row].publishedAt
        let imageToURL: String? = (articles[indexPath.row].urlToImage != nil) ? articles[indexPath.row].urlToImage: ""
        if let imageURL = URL(string: imageToURL!) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    var image = UIImage(data: data)
                    image = self.cropPic(image: image!, width: 100, height: 100)
                    DispatchQueue.main.async {
                        cell.articleImage?.image = image
                        cell.articleImage?.layer.cornerRadius = 8.0
                    }
                }
            }
        } else {
            cell.articleImage?.image = #imageLiteral(resourceName: "nasi-3")
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let target = storyboard?.instantiateViewController(withIdentifier: "ArticleDetailController") as? ArticleDetailController
        target?.content = articles[indexPath.row].content ?? target!.content
        target?.time = articles[indexPath.row].publishedAt ?? ""
        target?.author = articles[indexPath.row].author ?? ""
        target?.arcTitle = articles[indexPath.row].title ?? ""
        target?.urlToImage = articles[indexPath.row].urlToImage ?? ""
        
        self.navigationController?.pushViewController(target!, animated: true)
        
    }
}
