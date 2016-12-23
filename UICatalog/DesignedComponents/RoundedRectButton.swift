//
//  RoundedRectButton.swift
//  UICatalog
//
//  Created by k2o on 2016/12/23.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedRectButton: UIButton {

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
    
    @IBInspectable
    var highlightedBackgroundColor: UIColor? = nil

    override var isHighlighted: Bool {
        didSet {
            self.backgroundColor(self.highlightedBackgroundColor, beArrange: self.isHighlighted)
        }
    }

    @IBInspectable
    var selectedBackgroundColor: UIColor? = nil
    
    override var isSelected: Bool {
        didSet {
            self.backgroundColor(self.selectedBackgroundColor, beArrange: self.isSelected)
        }
    }
    
    @IBInspectable
    var disabledBackgroundColor: UIColor? = nil
    
    override var isEnabled: Bool {
        didSet {
            self.backgroundColor(self.disabledBackgroundColor, beArrange: !self.isEnabled)
        }
    }
    
    private var savedBackgrondColor: UIColor? = nil
    override var backgroundColor: UIColor? {
        didSet {
            self.savedBackgrondColor = self.backgroundColor
        }
    }
    
    private func backgroundColor(_ color: UIColor?, beArrange: Bool) {
        if beArrange {
            if let color = color {
                super.backgroundColor = color
            }
        } else {
            super.backgroundColor = self.savedBackgrondColor
        }
    }
}
