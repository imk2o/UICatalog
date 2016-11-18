//
//  PropotionalSizingCollectionViewController.swift
//  UICatalog
//
//  Created by k2o on 2016/11/18.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

class PropotionalSizingCollectionViewController: UIViewController {

    var computedCellSize: CGSize?
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.register(PropotionalSizingCell.nib, forCellWithReuseIdentifier: "Cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PropotionalSizingCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? PropotionalSizingCell else {
            fatalError()
        }
        
        let imageSize = 200 + indexPath.item
        let imageURL = URL(string: "https://placekitten.com/\(imageSize)/\(imageSize)")!
        cell.configure(with: imageURL)
        
        return cell
    }
}

extension PropotionalSizingCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 一度計算したらキャッシュし、負荷を軽減
        // TODO: landscape表示に対応している場合は再計算を行うこと
        if let cellSize = self.computedCellSize {
            return cellSize
        } else {
            // PropotionalSizingCell.nibから原型セルを生成し、2列表示に適切なサイズを求める
            guard
                let prototypeCell = PropotionalSizingCell.nib.instantiate(withOwner: nil, options: nil).first as? PropotionalSizingCell,
                let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
            else {
                fatalError()
            }
            
            let cellSize = prototypeCell.propotionalScaledSize(for: flowLayout, numberOfColumns: 2)
            self.computedCellSize = cellSize
            
            return cellSize
        }
    }
}
