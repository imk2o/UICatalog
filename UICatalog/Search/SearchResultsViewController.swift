//
//  SearchResultsViewController.swift
//  UICatalog
//
//  Created by k2o on 2020/06/23.
//  Copyright © 2020 imk2o. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var dataSource: SearchViewDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = SearchViewDataSource()
        self.tableView.dataSource = self.dataSource
    }

    func search(keyword: String, completion handler: () -> Void) {
        self.dataSource.search(keyword) {
            self.tableView.reloadData()
            handler()
        }
    }
}
