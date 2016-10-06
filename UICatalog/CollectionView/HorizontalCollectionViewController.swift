//
//  HorizontalCollectionViewController.swift
//  UICatalog
//
//  Created by k2o on 2016/10/06.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

class HorizontalCollectionViewController: UIViewController {
    /// なんちゃって無限ループの数(あまり大きくしすぎるとクラッシュするかも)
    private let numberOfSectionsForFiniteLoop = 100
    
    private var products: [AppleProduct]!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var autoSelectionSwitch: UISwitch!
    @IBOutlet weak var finiteLoopSwitch: UISwitch!
    
    private var autoSelectionEnabled: Bool {
        return self.autoSelectionSwitch.on
    }
    
    private var finiteLoopEnabled: Bool {
        return self.finiteLoopSwitch.on
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.products = AppleProductProvider.shared.allProducts()
        
        //self.collectionView.decelerationRate = 0.5

        // Self sizing cell
        if let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = flowLayout.itemSize
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Finite Loop用に初期スクロール位置をアイテム群の中央付近に調整
        self.view.layoutIfNeeded()
        self.setScrollPositionByFiniteLoopEnabled()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func finiteLoopDidSwitch() {
        self.collectionView.reloadData()
        self.collectionView.collectionViewLayout.invalidateLayout()
        self.setScrollPositionByFiniteLoopEnabled()
    }

    /// Finite Loop切替時の初期スクロール位置を設定
    private func setScrollPositionByFiniteLoopEnabled() {
        let indexPath: NSIndexPath
        if self.finiteLoopEnabled {
            indexPath = NSIndexPath(forItem: 0, inSection: self.numberOfSectionsForFiniteLoop / 2)
        } else {
            indexPath = NSIndexPath(forItem: 0, inSection: 0)
        }
        self.collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: false)
    }
}

extension HorizontalCollectionViewController: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.finiteLoopEnabled ? self.numberOfSectionsForFiniteLoop : 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as? HorizontalCollectionViewCell else {
            fatalError()
        }
        let product = self.products[indexPath.item]
        
        cell.label.text = product.name
        
        return cell
    }
}

extension HorizontalCollectionViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        // 選択アイテムが中央に表示されるようスクロール
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: true)
    }
}

// NOTE: ドラッグ終了または慣性スクロール終了後に自動選択を行う
extension HorizontalCollectionViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate && self.autoSelectionEnabled {
            self.selectItemAutomatically()
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if self.autoSelectionEnabled {
            self.selectItemAutomatically()
        }
    }
    
    private func selectItemAutomatically() {
        let rect = self.collectionView.bounds
        let center = CGPoint(x: rect.midX, y: rect.midY)
        // TODO: centerがちょうどspacingやinsetsに当たるとnilを返すため、矩形判定などに変えるべき
        if let indexPath = self.collectionView.indexPathForItemAtPoint(center) {
            self.collectionView.selectItemAtIndexPath(indexPath, animated: true, scrollPosition: .CenteredHorizontally)
        }
        
    }
}
