//
//  SearchViewController.swift
//  UICatalog
//
//  Created by k2o on 2016/08/19.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    fileprivate var searchController: UISearchController!
    fileprivate var dataSource: SearchViewDataSource!

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = SearchViewDataSource()
        self.tableView.dataSource = self.dataSource
        
        // 検索結果表示を別VCで行う場合はsearchResultsControllerを渡す
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchBar.delegate = self
        self.searchController.searchResultsUpdater = self
        
        // 絞り込みボタンの表示
        self.searchController.searchBar.scopeButtonTitles = [
            "すべて",
            AppleProduct.Category.Mac.rawValue,
            AppleProduct.Category.iPhone.rawValue,
            AppleProduct.Category.iPad.rawValue
        ]
        
        // NOTE: 任意のビューにaddSubviewする場合はsearchBar.frameに大きさを設定すること
        self.tableView.tableHeaderView = self.searchController.searchBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

fileprivate extension SearchViewController {
    var selectedCategory: AppleProduct.Category? {
        guard let scopeButtonTitles = self.searchController.searchBar.scopeButtonTitles else {
            return nil
        }
        let scope = scopeButtonTitles[self.searchController.searchBar.selectedScopeButtonIndex]
        
        return AppleProduct.Category(rawValue: scope)
    }
    
    func search() {
        self.dataSource.search(
            searchController.searchBar.text!,
            category: self.selectedCategory
        ) {
            self.tableView.reloadData()
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        self.search()
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        self.search()
    }
}
