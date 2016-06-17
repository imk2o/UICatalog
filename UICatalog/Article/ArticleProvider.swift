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

    private (set) var articles: [Int: Article] = [:]
    
    private init() {
        self.load()
    }
    
    func allArticles() -> [Article] {
        return self.articles.sort { (pair1, pair2) -> Bool in
            return pair1.0 < pair2.0
        }.map { (id, article) -> Article in
            return article
        }
    }
    
    func article(forID id: Int) -> Article? {
        return self.articles[id]
    }
}

private extension ArticleProvider {
    func load() {
        guard
            let url = NSBundle.mainBundle().URLForResource("articles", withExtension: "json"),
            let data = NSData(contentsOfURL: url),
            let json = (try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)) as? [String: AnyObject]
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

private extension Article {
    init(id: Int, json: [String: AnyObject]) {
        self.id = id
        self.title = json["title"] as? String ?? ""
        self.detail = json["detail"] as? String ?? ""
        self.imagePrefix = json["image_prefix"] as? String ?? ""
    }
}