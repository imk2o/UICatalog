//
//  InnerCollectionViewCell.swift
//  UICatalog
//
//  Created by k2o on 2019/03/25.
//  Copyright © 2019年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

/// Cell内Collection View用のCell。
class InnerCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(text: String) {
        self.label.text = text
    }
    
    static private let prototype: InnerCollectionViewCell = {
        return instantiateFromNib()
    }()
    
    static func computeSize(text: String) -> CGSize {
        let prototypeCell = self.prototype
        prototypeCell.configure(text: text)
        prototypeCell.layoutIfNeeded()
        
        let size = prototypeCell.systemLayoutSizeFitting(
            CGSize(
                width: UIView.layoutFittingExpandedSize.width,
                height: prototypeCell.bounds.height
            ),
            withHorizontalFittingPriority: .defaultLow,
            verticalFittingPriority: .required
        )
        
        return CGSize(
            width: size.width.rounded(.up),
            height: size.height.rounded(.up)
        )
    }
}

