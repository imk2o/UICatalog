//
//  AppleProductProvider.swift
//  UICatalog
//
//  Created by k2o on 2016/08/19.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

class AppleProductProvider {
    static let shared = AppleProductProvider()
    
    private (set) var products: [Int: AppleProduct] = [:]
    
    private init() {
        self.load()
    }
    
    func allProducts() -> [AppleProduct] {
        return self.products.sort { (pair1, pair2) -> Bool in
            return pair1.0 < pair2.0
            }.map { (id, product) -> AppleProduct in
                return product
        }
    }
    
    func search(with keyword: String, category: AppleProduct.Category? = nil) -> [AppleProduct] {
        return self.allProducts().filter { (product) -> Bool in
            guard product.name.caseInsensitiveContainsString(keyword) else {
                return false
            }
            if let category = category {
                guard product.category == category else {
                    return false
                }
            }
            return true
        }
    }
    
    func product(forID id: Int) -> AppleProduct? {
        return self.products[id]
    }
}

private extension AppleProductProvider {
    func load() {
        guard
            let url = NSBundle.mainBundle().URLForResource("products", withExtension: "json"),
            let data = NSData(contentsOfURL: url),
            let json = (try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)) as? [String: AnyObject]
            else {
                return
        }
        
        for (key, value) in json {
            guard
                let id = Int(key),
                let productJSON = value as? [String: AnyObject]
                else {
                    continue
            }
            
            self.products[id] = AppleProduct(id: id, json: productJSON)
        }
    }
}

private extension AppleProduct {
    init(id: Int, json: [String: AnyObject]) {
        self.id = id
        self.name = json["name"] as? String ?? ""
        let category = json["category"] as? String ?? ""
        self.category = Category(rawValue: category) ?? .Uncategorized
    }
}

private extension String {
    func caseInsensitiveContainsString(other: String) -> Bool {
        return self.lowercaseString.containsString(other.lowercaseString)
    }
}
