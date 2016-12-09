//
//  SharedCellCollectionViewController.swift
//  UICatalog
//
//  Created by k2o on 2016/12/06.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

class SharedCellCollectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate var articles: [Article] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.articles = ArticleProvider.shared.allArticles()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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

extension SharedCellCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.articles.count
    }
 
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? SharedCollectionViewCell else {
            fatalError()
        }

        let article = self.articles[indexPath.row]
        cell.configure(withText: article.detail, image: article.image(for: "small"))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            fatalError()
        }
        
        let width = (collectionView.bounds.width - (flowLayout.minimumInteritemSpacing + flowLayout.sectionInset.left + flowLayout.sectionInset.right)) / 2
        
        return CGSize(width: width, height: 150)
    }
}
