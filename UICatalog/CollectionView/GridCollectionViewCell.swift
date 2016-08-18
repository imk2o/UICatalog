//
//  GridCollectionViewCell.swift
//  UICatalog
//
//  Created by k2o on 2016/08/18.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

class GridCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func configure(with image: UIImage?) {
        self.imageView.image = image
    }
}
