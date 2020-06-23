//
//  SearchMenuViewController.swift
//  UICatalog
//
//  Created by k2o on 2020/06/23.
//  Copyright © 2020 imk2o. All rights reserved.
//

import UIKit

class SearchMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func search(_ sender: Any) {
        let searchController = ModalSearchController()
        
        // タブの上にモーダル表示
        self.tabBarController?.present(searchController, animated: true)
    }
}
