//
//  AppleProduct.swift
//  UICatalog
//
//  Created by k2o on 2016/08/19.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

struct AppleProduct {
    enum Category: String {
        case Uncategorized
        case Mac
        case iPhone
        case iPad
    }
    
    let id: Int
    let name: String
    let category: Category
}

