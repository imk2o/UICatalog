//
//  PropotionalSizingCell.swift
//  UICatalog
//
//  Created by k2o on 2016/11/18.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

class PropotionalSizingCell: UICollectionViewCell, PrototypeViewSizing {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        self.imageView.image = nil
    }
    
    func configure(with imageURL: URL) {
        self.imageView.setImage(with: imageURL)
        self.titleLabel.text = imageURL.absoluteString
    }
}
