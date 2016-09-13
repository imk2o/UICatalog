//
//  FloatingHeaderFlowLayout.swift
//  UICatalog
//
//  Created by k2o on 2016/09/13.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

/// ヘッダビューを上部に固定表示するカスタムレイアウト
/// (参考: https://github.com/griffin-stewie/CSNFloatingHeaderViewFlowLayout)
class FloatingHeaderFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard
            let collectionView = self.collectionView,
            var answer = super.layoutAttributesForElementsInRect(rect)
        else {
            return super.layoutAttributesForElementsInRect(rect)
        }
        let contentOffset = collectionView.contentOffset
        var missingSections = Set<Int>()

        for layoutAttributes in answer {
            if
                layoutAttributes.representedElementCategory == UICollectionElementCategory.Cell &&
                layoutAttributes.representedElementKind != UICollectionElementKindSectionHeader
            {
                missingSections.insert(layoutAttributes.indexPath.section)
            }
        }

        let appendSectionLayoutAttributes = missingSections.flatMap { (section) -> UICollectionViewLayoutAttributes? in
            let indexPath = NSIndexPath(forItem: 0, inSection: section)
            return self.layoutAttributesForSupplementaryViewOfKind(UICollectionElementKindSectionHeader, atIndexPath: indexPath)
        }
        answer.appendContentsOf(appendSectionLayoutAttributes)
        
        for layoutAttributes in answer where layoutAttributes.representedElementKind == UICollectionElementKindSectionHeader {
            let section = layoutAttributes.indexPath.section
            let numberOfItemsInSection = collectionView.numberOfItemsInSection(section)
            
            let firstObjectIndexPath = NSIndexPath(forItem:0, inSection:section)
            let lastObjectIndexPath = NSIndexPath(forItem:max(0, numberOfItemsInSection - 1), inSection:section)

            // セクション内の最初と最後の要素を求める
            let cellsExist: Bool
            let firstObjectAttrs: UICollectionViewLayoutAttributes
            let lastObjectAttrs: UICollectionViewLayoutAttributes
            if numberOfItemsInSection > 0 { // use cell data if items exist
                cellsExist = true
                firstObjectAttrs = self.layoutAttributesForItemAtIndexPath(firstObjectIndexPath)!
                lastObjectAttrs = self.layoutAttributesForItemAtIndexPath(lastObjectIndexPath)!
            } else { // else use the header and footer
                cellsExist = false
                firstObjectAttrs = self.layoutAttributesForSupplementaryViewOfKind(UICollectionElementKindSectionHeader, atIndexPath:firstObjectIndexPath)!
                lastObjectAttrs = self.layoutAttributesForSupplementaryViewOfKind(UICollectionElementKindSectionFooter, atIndexPath:lastObjectIndexPath)!
            }

            // ヘッダ位置を調整
            let topHeaderHeight = cellsExist ? layoutAttributes.frame.height : 0
            let bottomHeaderHeight = layoutAttributes.frame.height
            let frameWithEdgeInsets = UIEdgeInsetsInsetRect(layoutAttributes.frame,
                                                            collectionView.contentInset)
            
            var origin = frameWithEdgeInsets.origin
            let sectionInset = self.sectionInset
            origin.y = min(
                max(
                    contentOffset.y + collectionView.contentInset.top,
                    CGRectGetMinY(firstObjectAttrs.frame) - topHeaderHeight - sectionInset.top
                ),
                CGRectGetMaxY(lastObjectAttrs.frame) - bottomHeaderHeight + sectionInset.bottom
            )
            
            layoutAttributes.zIndex = 1024		// FIXME self.headerViewZIndex;
            layoutAttributes.frame.origin = origin
        }
    
        return answer
    }

    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
}
