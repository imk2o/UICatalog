//
//  RoundedRectLabel.swift
//  UICatalog
//
//  Created by k2o on 2016/12/23.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedRectLabel: UILabel {

    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        } set {
            self.layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor {
        get {
            return self.layer.borderColor.map { UIColor(cgColor: $0) } ?? UIColor.clear
        } set {
            self.layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        } set {
            self.layer.borderWidth = newValue
        }
    }

    var contentEdgeInsets: UIEdgeInsets = UIEdgeInsets.zero
    
    @IBInspectable
    var topInset: CGFloat {
        get {
            return self.contentEdgeInsets.top
        } set {
            self.contentEdgeInsets.top = newValue
        }
    }
    
    @IBInspectable
    var leftInset: CGFloat {
        get {
            return self.contentEdgeInsets.left
        } set {
            self.contentEdgeInsets.left = newValue
        }
    }
    
    @IBInspectable
    var bottomInset: CGFloat {
        get {
            return self.contentEdgeInsets.bottom
        } set {
            self.contentEdgeInsets.bottom = newValue
        }
    }

    @IBInspectable
    var rightInset: CGFloat {
        get {
            return self.contentEdgeInsets.right
        } set {
            self.contentEdgeInsets.right = newValue
        }
    }
    
    override func drawText(in rect: CGRect) {
        let extendedRect = rect.inset(by: self.contentEdgeInsets)
        super.drawText(in: extendedRect)
    }
    
    override var intrinsicContentSize: CGSize {
        let intrinsicContentSize = super.intrinsicContentSize
        return CGSize(
            width: intrinsicContentSize.width + self.leftInset + self.rightInset,
            height: intrinsicContentSize.height + self.topInset + self.bottomInset
        )
    }
}
