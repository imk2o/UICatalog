//
//  CollectionViewFlowLayoutWithDecorations.swift
//  UICatalog
//
//  Created by k2o on 2017/10/31.
//  Copyright © 2017年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

/// 行間・列間に区切り線を付加するコレクションビュー・レイアウト
@IBDesignable
class CollectionViewFlowLayoutWithDecorations: UICollectionViewFlowLayout {
    enum DecorationViewElementKind: String {
        case horizontalSeparator
        case verticalSeparator
        case sectionBackground
        
        static var all: [DecorationViewElementKind] {
            return [.horizontalSeparator, .verticalSeparator, .sectionBackground]
        }
        
        static var separators: [DecorationViewElementKind] {
            return [.horizontalSeparator, .verticalSeparator]
        }
    }
    
    /// 列数
    @IBInspectable
    var numberOfColumns: Int = 3
    
    /// 区切り線の太さ(0の場合は表示しない)
    @IBInspectable
    var separatorSize: CGSize = CGSize(width: 0.375, height: 0.375)
    
    /// セクションごとに背景をつけるか？
    @IBInspectable
    var showsSectionBackground: Bool = true
    
    override func awakeFromNib() {
        // 区切り線となるビューを登録
        let separatorNib = UINib(nibName: "SeparatorDecorationView", bundle: nil)
        self.register(
            separatorNib,
            forDecorationViewOfKind: DecorationViewElementKind.horizontalSeparator.rawValue
        )
        self.register(
            separatorNib,
            forDecorationViewOfKind: DecorationViewElementKind.verticalSeparator.rawValue
        )
        let backgroundNib = UINib(nibName: "SectionBackgroundView", bundle: nil)
        self.register(
            backgroundNib,
            forDecorationViewOfKind: DecorationViewElementKind.sectionBackground.rawValue
        )
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let layoutAttributesArray = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        
        // 各Itemに対応するセパレータのLayoutAttributesを求め、追加する
        var decorationLayoutAttributesArray: [UICollectionViewLayoutAttributes] = []
        var sectionIndexes: Set<Int> = []
        for layoutAttributes in layoutAttributesArray {
            let indexPath = layoutAttributes.indexPath
            decorationLayoutAttributesArray += DecorationViewElementKind.separators.flatMap {
                return self.layoutAttributesForDecorationView(ofKind: $0.rawValue, at: indexPath)
            }
            sectionIndexes.insert(indexPath.section)
        }

        // セクションごとに1つ、背景用のLayoutAttributesを追加
        for sectionIndex in sectionIndexes {
            let indexPath = IndexPath(item: 0, section: sectionIndex)
            guard let layoutAttributes = self.layoutAttributesForDecorationView(ofKind: DecorationViewElementKind.sectionBackground.rawValue, at: indexPath) else {
                continue
            }
            decorationLayoutAttributesArray += [layoutAttributes]
        }
        
        return layoutAttributesArray + decorationLayoutAttributesArray
    }
    
    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        switch DecorationViewElementKind(rawValue: elementKind) {
        case .horizontalSeparator?:
            // 2行目以降の最初の列に対するItemの上部に水平線を引く
            guard
                self.separatorSize.height > 0,
                indexPath.item > 0 && (indexPath.item % self.numberOfColumns == 0),
                let collectionView = self.collectionView,
                let itemLayoutAttributes = self.layoutAttributesForItem(at: indexPath)
                else {
                    return nil
            }
            
            let layoutAttributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: elementKind, with: indexPath)
            layoutAttributes.frame = CGRect(
                x: self.sectionInset.left,
                y: itemLayoutAttributes.frame.origin.y - ((self.minimumLineSpacing + self.separatorSize.height) / 2).rounded(.down),
                width: collectionView.bounds.width - (self.sectionInset.left + self.sectionInset.right),
                height: self.separatorSize.height
            )
            
            return layoutAttributes
        case .verticalSeparator?:
            // 最初の行以外に対するItemの左部に垂直な線を引く
            guard
                self.separatorSize.width > 0,
                (indexPath.item % self.numberOfColumns) > 0,
                let itemLayoutAttributes = self.layoutAttributesForItem(at: indexPath)
                else {
                    return nil
            }
            
            let layoutAttributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: elementKind, with: indexPath)
            layoutAttributes.frame = CGRect(
                x: itemLayoutAttributes.frame.origin.x - ((self.minimumInteritemSpacing + self.separatorSize.width) / 2).rounded(.down),
                y: itemLayoutAttributes.frame.origin.y,
                width: self.separatorSize.width,
                height: itemLayoutAttributes.frame.size.height
            )
            
            return layoutAttributes
        case .sectionBackground?:
            // セクション内の最初の要素の上端、最後の要素の下端の間を背景領域とする
            guard
                self.showsSectionBackground,
                let collectionView = self.collectionView
            else {
                return nil
            }
            
            let sectionIndex = indexPath.section
            let firstItemIndexPath = IndexPath(item: 0, section: sectionIndex)
            let lastItemIndexPath = IndexPath(
                item: collectionView.numberOfItems(inSection: sectionIndex) - 1,
                section: sectionIndex
            )
            
            guard
                let firstItemLayoutAttributes = self.layoutAttributesForItem(at: firstItemIndexPath),
                let lastItemLayoutAttributes = self.layoutAttributesForItem(at: lastItemIndexPath)
            else {
                return nil
            }
            
            let topOfSection = firstItemLayoutAttributes.frame.minY - self.sectionInset.top
            let bottomOfSection = lastItemLayoutAttributes.frame.maxY + self.sectionInset.bottom
            let layoutAttributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: elementKind, with: indexPath)
            layoutAttributes.frame = CGRect(
                x: 0,
                y: topOfSection,
                width: collectionView.bounds.width,
                height: bottomOfSection - topOfSection
            )
            layoutAttributes.zIndex = -1		// Itemや区切り線より後ろに表示
            
            return layoutAttributes
        default:
            return nil
        }
    }
    
    // TODO: Itemのinsert, deleteを行う場合は
    // - indexPathsToInsertForDecorationView(ofKind:)
    // - indexPathsToDeleteForDecorationView(ofKind:)
    // も実装する必要がある
}

