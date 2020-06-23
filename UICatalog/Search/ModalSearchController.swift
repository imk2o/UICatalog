//
//  ModalSearchController.swift
//  UICatalog
//
//  Created by k2o on 2020/06/23.
//  Copyright © 2020 imk2o. All rights reserved.
//

import UIKit

class ModalSearchController: UISearchController {

    init() {
        let storyboard = UIStoryboard(name: "Search", bundle: nil)
        guard let resultsController = storyboard.instantiateViewController(withIdentifier: "SearchResultsView") as? SearchResultsViewController else {
            fatalError()
        }

        super.init(searchResultsController: resultsController)
        
        self.searchBar.placeholder = "キーワードを入力"
        self.searchBar.delegate = self
        
        self.hidesNavigationBarDuringPresentation = false
        self.obscuresBackgroundDuringPresentation = true
        
        // 検索結果を得るまでは非表示
        if #available(iOS 13.0, *) {
            self.showsSearchResultsController = false
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    private func search() {
        guard let searchResultsViewController = self.searchResultsController as? SearchResultsViewController else {
            return
        }
        
        searchResultsViewController.search(keyword: self.searchBar.text ?? "") {
            if #available(iOS 13.0, *) {
                self.showsSearchResultsController = true
            }
        }
    }
}

extension ModalSearchController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // 検索ワードがクリアされたら結果画面も非表示にする
        if searchText.isEmpty {
            if #available(iOS 13.0, *) {
                self.showsSearchResultsController = false
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.search()
    }
}

