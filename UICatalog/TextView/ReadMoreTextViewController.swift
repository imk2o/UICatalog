//
//  ReadMoreTextViewController.swift
//  UICatalog
//
//  Created by k2o on 2016/10/02.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

class ReadMoreTextViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var readMoreButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.textView.textContainer.lineBreakMode = .ByTruncatingTail
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func readMore(sender: UIButton) {
        self.textViewHeightConstraint.active = false
        self.readMoreButton.hidden = true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
