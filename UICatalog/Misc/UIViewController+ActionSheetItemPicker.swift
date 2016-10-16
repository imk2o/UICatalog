//
//  UIViewController+ActionSheetItemPicker.swift
//  UICatalog
//
//  Created by k2o on 2016/09/05.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

extension UIViewController {
    func pickItem<Value>(
        from items: [(String, Value)],
             title: String? = nil,
             message: String? = nil,
             completion handler: @escaping (String, Value) -> Void)
    {
        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        for item in items {
            actionSheet.addAction(UIAlertAction(title: item.0, style: .default) { (action) in
                handler(item.0, item.1)
            })
        }
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
}
