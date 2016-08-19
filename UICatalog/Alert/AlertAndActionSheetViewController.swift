//
//  AlertAndActionSheetViewController.swift
//  UICatalog
//
//  Created by k2o on 2016/08/19.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

class AlertAndActionSheetViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func alertButtonDidTap(sender: UIButton) {
        let alert = UIAlertController(title: "title", message: "message", preferredStyle: .Alert)
        
        // FIXME: TextField を追加したい場合は以下を有効に
        //alert.addTextFieldWithConfigurationHandler { (textField: UITextField) in
        //    // FIXME: TextField の初期値を設定...
        //}
        
        // FIXME: Cancel ボタンを追加したい場合は以下を有効に
        //alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .Default) { (action: UIAlertAction) in
            // FIXME: OK 選択時の挙動を実装...
            })
        
        self.presentViewController(alert, animated: true, completion: nil)
    }

    @IBAction func actionSheetButtonDidTap(sender: UIButton) {
        let actionSheet = UIAlertController(title: "title", message: "message", preferredStyle: .ActionSheet)
        
        for i in 1...3 {
            actionSheet.addAction(UIAlertAction(title: "Item\(i)", style: .Default) { (action) in
                // FIXME: アイテム選択時の挙動を実装...
                })
        }
        
        actionSheet.addAction(UIAlertAction(title: "Delete", style: .Destructive, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
}
