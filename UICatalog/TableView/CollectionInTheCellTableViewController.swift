//
//  CollectionInTheCellTableViewController.swift
//  UICatalog
//
//  Created by k2o on 2019/03/25.
//  Copyright © 2019 Yuichi Kobayashi. All rights reserved.
//

import UIKit

class CollectionInTheCellTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(OuterTableViewCell.nib, forCellReuseIdentifier: "Cell")
    }
}

extension CollectionInTheCellTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! OuterTableViewCell
        
        cell.configure(text: "Cell\(indexPath.row)", count: indexPath.row + 1)
        
        return cell
    }
}
