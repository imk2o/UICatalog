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
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard
            let collectionView = self.collectionView,
            var answer = super.layoutAttributesForElements(in: rect)
        else {
            return super.layoutAttributesForElements(in: rect)
        }
        let contentOffset = collectionView.contentOffset
        var missingSections = Set<Int>()

        for layoutAttributes in answer {
            if
                layoutAttributes.representedElementCategory == .cell &&
                layoutAttributes.representedElementKind != UICollectionView.elementKindSectionHeader
            {
                missingSections.insert((layoutAttributes.indexPath as NSIndexPath).section)
            }
        }

        let appendSectionLayoutAttributes = missingSections.compactMap { (section) -> UICollectionViewLayoutAttributes? in
            let indexPath = IndexPath(item: 0, section: section)
            return self.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        }
        answer.append(contentsOf: appendSectionLayoutAttributes)
        
        for layoutAttributes in answer where layoutAttributes.representedElementKind == UICollectionView.elementKindSectionHeader {
            let section = (layoutAttributes.indexPath as NSIndexPath).section
            let numberOfItemsInSection = collectionView.numberOfItems(inSection: section)
            
            let firstObjectIndexPath = IndexPath(item:0, section:section)
            let lastObjectIndexPath = IndexPath(item:max(0, numberOfItemsInSection - 1), section:section)

            // セクション内の最初と最後の要素を求める
            let cellsExist: Bool
            let firstObjectAttrs: UICollectionViewLayoutAttributes
            let lastObjectAttrs: UICollectionViewLayoutAttributes
            if numberOfItemsInSection > 0 { // use cell data if items exist
                cellsExist = true
                firstObjectAttrs = self.layoutAttributesForItem(at: firstObjectIndexPath)!
                lastObjectAttrs = self.layoutAttributesForItem(at: lastObjectIndexPath)!
            } else { // else use the header and footer
                cellsExist = false
                firstObjectAttrs = self.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at:firstObjectIndexPath)!
                lastObjectAttrs = self.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, at:lastObjectIndexPath)!
            }

            // ヘッダ位置を調整
            let topHeaderHeight = cellsExist ? layoutAttributes.frame.height : 0
            let bottomHeaderHeight = layoutAttributes.frame.height
            let frameWithEdgeInsets = layoutAttributes.frame.inset(by: collectionView.contentInset)
            
            var origin = frameWithEdgeInsets.origin
            let sectionInset = self.sectionInset
            origin.y = min(
                max(
                    contentOffset.y + collectionView.contentInset.top,
                    firstObjectAttrs.frame.minY - topHeaderHeight - sectionInset.top
                ),
                lastObjectAttrs.frame.maxY - bottomHeaderHeight + sectionInset.bottom
            )
            
            layoutAttributes.zIndex = 1024		// FIXME self.headerViewZIndex;
            layoutAttributes.frame.origin = origin
        }
    
        return answer
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
