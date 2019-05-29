//
//  TextTruncationViewController.swift
//  UICatalog
//
//  Created by k2o on 2019/05/29.
//  Copyright © 2019 Yuichi Kobayashi. All rights reserved.
//

import UIKit

class TextTruncationViewController: UIViewController {
    @IBOutlet weak var wordLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func textDidInput(_ sender: UITextField) {
        self.wordLabel.text = sender.text
    }
}
