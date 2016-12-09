//
//  SharedCell.swift
//  UICatalog
//
//  Created by k2o on 2016/12/06.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

/// UITableViewCell, UICollectionViewCellの共通セル。
class SharedCell: UIView {
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    static func instantiateFromNib() -> SharedCell {
        let nib = UINib(nibName: String(describing: self), bundle: nil)
        guard let cell = nib.instantiate(withOwner: nil, options: nil).first as? SharedCell else {
            fatalError()
        }
        
        return cell
    }
}
