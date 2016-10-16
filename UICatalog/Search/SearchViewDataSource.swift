//
//  SearchViewDataSource.swift
//  UICatalog
//
//  Created by k2o on 2016/08/19.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

class SearchViewDataSource: NSObject, UITableViewDataSource {
    fileprivate(set) var products: [AppleProduct]?
    
    func search(
        _ keyword: String,
        category: AppleProduct.Category? = nil,
        completion: () -> Void
    ) {
        self.products = AppleProductProvider.shared.search(with: keyword, category: category)
        
        completion()
    }
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        guard let product = self.products?[(indexPath as NSIndexPath).row] else {
            fatalError()
        }
        
        cell.textLabel?.text = product.name
        cell.detailTextLabel?.text = product.category.rawValue
        
        return cell
    }
}
