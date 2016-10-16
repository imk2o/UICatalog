//
//  HorizontalCollectionViewCell.swift
//  UICatalog
//
//  Created by k2o on 2016/10/06.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

class HorizontalCollectionViewCell: UICollectionViewCell {
        
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        let selectedBackgroundView = UIView(frame: self.bounds)
        selectedBackgroundView.backgroundColor = UIColor.yellow
        self.selectedBackgroundView = selectedBackgroundView
    }
}
