//
//  GridCollectionViewController.swift
//  UICatalog
//
//  Created by k2o on 2016/08/18.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

class GridCollectionViewController: UIViewController {
    private var articles: [Article] = []

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.articles = ArticleProvider.shared.allArticles()
        
        // NOTE:
        // Interface BuilderでFloatingHeaderFlowLayoutにカスタマイズしているため、
        // ヘッダビューが上部に固定される
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - UICollectionViewDataSource
extension GridCollectionViewController: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 3	// FIXME
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Header", forIndexPath: indexPath)
            
            // FIXME: configure header view
            headerView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
            
            return headerView
        case UICollectionElementKindSectionFooter:
            fatalError()
        default:
            fatalError()
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15	// self.articles.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as? GridCollectionViewCell else {
            fatalError()
        }
        
        // configure cell
        let index = (indexPath.item + indexPath.section) % self.articles.count
        let article = self.articles[index]
        cell.configure(with: article.image(for: "small"))

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension GridCollectionViewController: UICollectionViewDelegateFlowLayout {
    private var numberOfColumns: Int {
        return 4	// FIXME
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            fatalError()
        }
        
        // 画面サイズに関係なく、列数がnumberOfColumnsになるよう、セルサイズを調整
        let numberOfSpaces = self.numberOfColumns - 1
        let size = (self.view.bounds.width - (flowLayout.minimumInteritemSpacing * CGFloat(numberOfSpaces))) / CGFloat(self.numberOfColumns)
        
        return CGSize(width: size, height: size)
    }
}
