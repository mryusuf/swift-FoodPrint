//
//  Articles.swift
//  FoodPrint
//
//  Created by Indra Permana on 26/04/19.
//  Copyright © 2019 Indra Permana. All rights reserved.
//

import UIKit

struct Articles: Codable {
    let status: String?
    let totalResults: Int?
    let articles: [Article]?
   
}

struct Source: Codable {
    let id: String?
    let name: String?
 
}

struct Article: Codable {
    let source: Source
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
  
}
