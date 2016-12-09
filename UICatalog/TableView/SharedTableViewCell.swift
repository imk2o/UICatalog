//
//  SharedTableViewCell.swift
//  UICatalog
//
//  Created by k2o on 2016/12/06.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

class SharedTableViewCell: UITableViewCell {
    var body: SharedCell? {
        return self.contentView.subviews.first as? SharedCell
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        let body = SharedCell.instantiateFromNib()
        // body(SharedCell)をセルいっぱいに表示するConstraintを与える
        self.contentView.addSubviewAndFitConstraints(body)
    }

    func configure(withText text: String, image: UIImage? = nil) {
        guard let body = self.body else {
            return
        }
        
        body.imageView.image = image
        body.textLabel.text = text
    }
}
