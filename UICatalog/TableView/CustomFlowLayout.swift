//
//  CustomFlowLayout.swift
//  UICatalog
//
//  Created by k2o on 2019/03/25.
//  Copyright © 2019年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

// ・必ずfixedSpacing()がtrueの場合、必ずinteritemSpacing間隔で配置する
// https://stackoverflow.com/questions/24608568/fixed-spacing-between-item-in-uicollectionview-with-flow-layout
class CustomFlowLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let layoutAttributesArray = (super.layoutAttributesForElements(in: rect)?.compactMap { (layoutAttributes) -> UICollectionViewLayoutAttributes? in
            if case .cell = layoutAttributes.representedElementCategory {
                return self.layoutAttributesForItem(at: layoutAttributes.indexPath)
            } else {
                return layoutAttributes
            }
        }) else {
            return nil
        }
        
        return layoutAttributesArray
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let layoutAttributes = super.layoutAttributesForItem(at: indexPath) else {
            return nil
        }
        
        if self.fixedSpacing(at: indexPath) {
            let sectionInset = self.finalSectionInset(at: indexPath.section)
            
            if indexPath.item == 0 {
                // 最初のアイテムは必ず左に寄せる
                layoutAttributes.setFrameLeft(sectionInset.left)
            } else {
                let previousIndexPath = IndexPath(
                    item: indexPath.item - 1,
                    section: indexPath.section
                )
                guard
                    let collectionView = self.collectionView,
                    let previousItemFrame = self.layoutAttributesForItem(at: previousIndexPath)?.frame
                    else {
                        return nil
                }
                let rowFrame = CGRect(
                    x: sectionInset.left,
                    y: layoutAttributes.frame.origin.y,
                    width: collectionView.frame.width - (sectionInset.left + sectionInset.right),
                    height: layoutAttributes.frame.height
                )
                
                // 前のアイテムと同じ行に表示される場合、間隔をおいてその隣に寄せる
                // 異なる行であれば左に寄せる
                if previousItemFrame.intersects(rowFrame) {
                    let frameLeft = previousItemFrame.maxX + self.finalInteritemSpacing(at: indexPath.section)
                    layoutAttributes.setFrameLeft(frameLeft)
                } else {
                    layoutAttributes.setFrameLeft(sectionInset.left)
                }
            }
        }
        
        return layoutAttributes
    }
    
    private var collectionViewDelegate: UICollectionViewDelegateFlowLayout? {
        return self.collectionView?.delegate as? UICollectionViewDelegateFlowLayout
    }
    
    private func fixedSpacing(at indexPath: IndexPath) -> Bool {
        return true
    }
    
    // 最終的なアイテム間隔を求める
    private func finalInteritemSpacing(at section: Int) -> CGFloat {
        if
            let collectionView = self.collectionView,
            let interitemSpacing = self.collectionViewDelegate?.collectionView?(collectionView, layout: self, minimumInteritemSpacingForSectionAt: section)
        {
            return interitemSpacing
        } else {
            return self.minimumInteritemSpacing
        }
    }
    
    // 最終的なセクションマージンを求める
    private func finalSectionInset(at section: Int) -> UIEdgeInsets {
        if
            let collectionView = self.collectionView,
            let sectionInset = self.collectionViewDelegate?.collectionView?(collectionView, layout: self, insetForSectionAt: section)
        {
            return sectionInset
        } else {
            return self.sectionInset
        }
    }
}

private extension UICollectionViewLayoutAttributes {
    func setFrameLeft(_ left: CGFloat) {
        self.frame.origin.x = left
    }
}
