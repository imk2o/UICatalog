//
//  UIView+Extension.swift
//  UICatalog
//
//  Created by k2o on 2016/12/09.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

extension UIView {
    func addSubviewAndFitConstraints(_ subview: UIView) {
        self.addSubview(subview)
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        self.addConstraint(NSLayoutConstraint(
            item: subview, attribute: .top,
            relatedBy: .equal,
            toItem: self, attribute: .top,
            multiplier: 1.0, constant: 0.0
        ))
        
        self.addConstraint(NSLayoutConstraint(
            item: subview, attribute: .left,
            relatedBy: .equal,
            toItem: self, attribute: .left,
            multiplier: 1.0, constant: 0.0
        ))
        
        self.addConstraint(NSLayoutConstraint(
            item: subview, attribute: .bottom,
            relatedBy: .equal,
            toItem: self, attribute: .bottom,
            multiplier: 1.0, constant: 0.0
        ))
        
        self.addConstraint(NSLayoutConstraint(
            item: subview, attribute: .right,
            relatedBy: .equal,
            toItem: self, attribute: .right,
            multiplier: 1.0, constant: 0.0
        ))
    }
}
