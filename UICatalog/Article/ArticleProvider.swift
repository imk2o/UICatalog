//
//  ArticleProvider.swift
//  UICatalog
//
//  Created by k2o on 2016/06/17.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

class ArticleProvider {
    static let shared = ArticleProvider()

    fileprivate (set) var articles: [Int: Article] = [:]
    
    fileprivate init() {
        self.load()
    }
    
    func allArticles() -> [Article] {
        return self.articles.sorted { (pair1, pair2) -> Bool in
            return pair1.0 < pair2.0
        }.map { (id, article) -> Article in
            return article
        }
    }
    
    func article(forID id: Int) -> Article? {
        return self.articles[id]
    }
}

fileprivate extension ArticleProvider {
    func load() {
        guard
            let url = Bundle.main.url(forResource: "articles", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let json = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: AnyObject]
        else {
            return
        }
        
        for (key, value) in json {
            guard
                let id = Int(key),
                let articleJSON = value as? [String: AnyObject]
            else {
                continue
            }
            
            self.articles[id] = Article(id: id, json: articleJSON)
        }
    }
}

fileprivate extension Article {
    init(id: Int, json: [String: AnyObject]) {
        self.id = id
        self.title = json["title"] as? String ?? ""
        self.detail = json["detail"] as? String ?? ""
        self.imagePrefix = json["image_prefix"] as? String ?? ""
    }
}
