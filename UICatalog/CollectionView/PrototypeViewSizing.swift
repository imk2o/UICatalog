//
//  PrototypeViewSizing.swift
//  UICatalog
//
//  Created by k2o on 2016/11/18.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

protocol PrototypeViewSizing: class {
}

extension PrototypeViewSizing where Self: UICollectionViewCell {
    /// 原型ビューに準拠した大きさを求める。
    /// self自身のレイアウトを変更するため、表示に利用していないビューから呼び出すこと。
    ///
    /// - Parameters:
    ///   - flowLayout: フローレイアウト
    ///   - nColumns: 列数
    /// - Returns: 大きさを返す
    func propotionalScaledSize(
        for flowLayout: UICollectionViewFlowLayout,
        numberOfColumns nColumns: Int
    ) -> CGSize {
        // 幅は必ず指定のwidthに合わせ、高さはLayout Constraintに則った値とするサイズを求める
        let width = flowLayout.preferredItemWidth(forNumberOfColumns: nColumns)
        self.bounds.size = CGSize(width: width, height: 0)
        self.layoutIfNeeded()
        
        return self.systemLayoutSizeFitting(
            UILayoutFittingExpandedSize,
            withHorizontalFittingPriority: UILayoutPriorityRequired,
            verticalFittingPriority: UILayoutPriorityDefaultLow
        )
    }
    
    /// 原型ビューを横に伸ばした大きさを求める。
    ///
    /// - Parameters:
    ///   - flowLayout: フローレイアウト
    /// - Returns: 大きさを返す
    func horizontalScaledSize(for flowLayout: UICollectionViewFlowLayout) -> CGSize {
        return self.propotionalScaledSize(for: flowLayout, numberOfColumns: 1)
    }
}

private extension UICollectionViewFlowLayout {
    /// 列数に対するアイテムの推奨サイズ(幅)を求める。
    ///
    /// - Parameter nColumns: 列数
    /// - Returns: 幅を返す
    func preferredItemWidth(forNumberOfColumns nColumns: Int) -> CGFloat {
        guard nColumns > 0 else {
            return 0
        }
        guard let collectionView = self.collectionView else {
            fatalError()
        }
        
        let collectionViewWidth = collectionView.bounds.width
        let inset = self.sectionInset
        let spacing = self.minimumInteritemSpacing
        
        // コレクションビューの幅から、各余白を除いた幅を均等に割る
        return (collectionViewWidth - (inset.left + inset.right + spacing * CGFloat(nColumns - 1))) / CGFloat(nColumns)
    }
}
