//
//  VisualEffectViewController.swift
//  UICatalog
//
//  Created by k2o on 2016/09/12.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

class VisualEffectViewController: UIViewController {

    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func editButtonDidTap(sender: UIBarButtonItem) {
        let items: [(String, UIBlurEffectStyle?)] = [
            ("ExtraLight", .ExtraLight),
            ("Light", .Light),
            ("Dark", .Dark),
            ("None", nil)
        ]
        self.pickItem(from: items) { (title, value) in
            dispatch_async(dispatch_get_main_queue()) {
                self.setBlurEffectStyle(value)
            }
        }
    }

    private func setBlurEffectStyle(style: UIBlurEffectStyle?) {
        UIView.animateWithDuration(1.0) { 
            self.visualEffectView.effect = style.map { UIBlurEffect(style: $0) }
        }
    }
}
