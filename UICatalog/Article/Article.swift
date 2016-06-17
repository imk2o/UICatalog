//
//  Article.swift
//  UICatalog
//
//  Created by k2o on 2016/06/17.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

struct Article {
    let id: Int
    let title: String
    let detail: String
    let imagePrefix: String
}

extension Article {
    func image(for size: String) -> UIImage? {
        return UIImage(named: "\(self.imagePrefix)_\(size)")
    }
}
