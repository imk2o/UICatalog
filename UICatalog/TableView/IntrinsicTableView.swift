//
//  IntrinsicTableView.swift
//  UICatalog
//
//  Created by k2o on 2019/03/25.
//  Copyright © 2019年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

/// intrinsicContentSizeが、すべてのセルを露出する大きさとなるTable View。
class IntrinsicTableView: UITableView {
    override var contentSize: CGSize {
        didSet {
            if !self.isScrollEnabled {
                self.invalidateIntrinsicContentSize()
            }
        }
    }
    
    override var intrinsicContentSize: CGSize {
        if self.isScrollEnabled {
            return super.intrinsicContentSize
        } else {
            self.layoutIfNeeded()
            return CGSize(width: UIView.noIntrinsicMetric, height: self.contentSize.height)
        }
    }
}
