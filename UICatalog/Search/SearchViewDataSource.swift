//
//  SearchViewDataSource.swift
//  UICatalog
//
//  Created by k2o on 2016/08/19.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

class SearchViewDataSource: NSObject, UITableViewDataSource {
    private(set) var products: [AppleProduct]?
    
    func search(
        keyword: String,
        category: AppleProduct.Category? = nil,
        completion: () -> Void
    ) {
        self.products = AppleProductProvider.shared.search(with: keyword, category: category)
        
        completion()
    }
    
    // MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        guard let product = self.products?[indexPath.row] else {
            fatalError()
        }
        
        cell.textLabel?.text = product.name
        cell.detailTextLabel?.text = product.category.rawValue
        
        return cell
    }
}
