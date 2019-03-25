//
//  MainViewController.swift
//  UICatalog
//
//  Created by k2o on 2018/11/10.
//  Copyright © 2018 Yuichi Kobayashi. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        print(self.children)
        // Do any additional setup after loading the view.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(segue.identifier)
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
