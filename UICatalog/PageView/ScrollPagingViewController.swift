//
//  ScrollPagingViewController.swift
//  UICatalog
//
//  Created by k2o on 2016/08/18.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

// NOTE:
// * PageViewControllerのサブクラスではなく、Container Viewを用いてUIPageViewControllerを内包する
// (ビューの背景色調整やサブビューがレイアウトできるので比較的柔軟性が高い)
// * UIpageViewControllerの参照はprepareForSegueで得る
// (viewDidLoadより先に呼び出されるので問題ない)
class ScrollPagingViewController: UIViewController {
    fileprivate var pageViewDataSource: ScrollPagingViewDataSource!
    fileprivate var pageViewController: UIPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let articles = ArticleProvider.shared.allArticles()
        self.pageViewDataSource = ScrollPagingViewDataSource(articles: articles)
        self.pageViewController.dataSource = self.pageViewDataSource
        self.pageViewController.delegate = self
        
        // NOTE: Under Top BarsがONのとき、最初のページ表示直後に適用されない問題があるため
        DispatchQueue.main.async {
            let firstViewController = self.pageViewDataSource.firstViewController()
            self.pageViewController.setViewControllers([firstViewController], direction: .forward, animated: false, completion: nil)
            self.navigationItem.title = firstViewController.title
        }
        
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: ">>", style: .plain, target: self, action: #selector(toLastPage)),
            UIBarButtonItem(title: "<<", style: .plain, target: self, action: #selector(toFirstPage))
        ]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if case .some("PageViewController") = segue.identifier {
            guard let pageViewController = segue.destination as? UIPageViewController else {
                fatalError()
            }
            
            self.pageViewController = pageViewController
        }
    }
    
    func toFirstPage(_ sender: AnyObject) {
        let firstViewController = self.pageViewDataSource.firstViewController()
        self.pageViewController.setViewControllers([firstViewController], direction: .reverse, animated: true, completion: nil)
    }
    
    func toLastPage(_ sender: AnyObject) {
        let lastViewController = self.pageViewDataSource.lastViewController()
        self.pageViewController.setViewControllers([lastViewController], direction: .forward, animated: true, completion: nil)
    }
}

extension ScrollPagingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        // NOTE: self.viewControllers?.firstが現在のページに対応するVC
        self.navigationItem.title = self.pageViewController.viewControllers?.first?.title
    }
}
