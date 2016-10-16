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
    fileprivate let numberOfSectionsForFiniteLoop = 100
    
    fileprivate var products: [AppleProduct]!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var autoSelectionSwitch: UISwitch!
    @IBOutlet weak var finiteLoopSwitch: UISwitch!
    
    fileprivate var autoSelectionEnabled: Bool {
        return self.autoSelectionSwitch.isOn
    }
    
    fileprivate var finiteLoopEnabled: Bool {
        return self.finiteLoopSwitch.isOn
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

    override func viewWillAppear(_ animated: Bool) {
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
    fileprivate func setScrollPositionByFiniteLoopEnabled() {
        let indexPath: IndexPath
        if self.finiteLoopEnabled {
            indexPath = IndexPath(item: 0, section: self.numberOfSectionsForFiniteLoop / 2)
        } else {
            indexPath = IndexPath(item: 0, section: 0)
        }
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }
}

extension HorizontalCollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.finiteLoopEnabled ? self.numberOfSectionsForFiniteLoop : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? HorizontalCollectionViewCell else {
            fatalError()
        }
        let product = self.products[(indexPath as NSIndexPath).item]
        
        cell.label.text = product.name
        
        return cell
    }
}

extension HorizontalCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // 選択アイテムが中央に表示されるようスクロール
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

// NOTE: ドラッグ終了または慣性スクロール終了後に自動選択を行う
extension HorizontalCollectionViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate && self.autoSelectionEnabled {
            self.selectItemAutomatically()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.autoSelectionEnabled {
            self.selectItemAutomatically()
        }
    }
    
    fileprivate func selectItemAutomatically() {
        let rect = self.collectionView.bounds
        let center = CGPoint(x: rect.midX, y: rect.midY)
        // TODO: centerがちょうどspacingやinsetsに当たるとnilを返すため、矩形判定などに変えるべき
        if let indexPath = self.collectionView.indexPathForItem(at: center) {
            self.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        }
        
    }
}
