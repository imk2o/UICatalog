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
    
    fileprivate (set) var products: [Int: AppleProduct] = [:]
    
    fileprivate init() {
        self.load()
    }
    
    func allProducts() -> [AppleProduct] {
        return self.products.sorted { (pair1, pair2) -> Bool in
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

fileprivate extension AppleProductProvider {
    func load() {
        guard
            let url = Bundle.main.url(forResource: "products", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let json = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: AnyObject]
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

fileprivate extension AppleProduct {
    init(id: Int, json: [String: AnyObject]) {
        self.id = id
        self.name = json["name"] as? String ?? ""
        let category = json["category"] as? String ?? ""
        self.category = Category(rawValue: category) ?? .Uncategorized
    }
}

fileprivate extension String {
    func caseInsensitiveContainsString(_ other: String) -> Bool {
        return self.lowercased().contains(other.lowercased())
    }
}
