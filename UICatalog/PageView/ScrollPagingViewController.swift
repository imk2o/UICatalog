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
    private var pageViewDataSource: ScrollPagingViewDataSource!
    private var pageViewController: UIPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let articles = ArticleProvider.shared.allArticles()
        self.pageViewDataSource = ScrollPagingViewDataSource(articles: articles)
        self.pageViewController.dataSource = self.pageViewDataSource
        self.pageViewController.delegate = self
        
        // NOTE: Under Top BarsがONのとき、最初のページ表示直後に適用されない問題があるため
        dispatch_async(dispatch_get_main_queue()) {
            let firstViewController = self.pageViewDataSource.firstViewController()
            self.pageViewController.setViewControllers([firstViewController], direction: .Forward, animated: false, completion: nil)
            self.navigationItem.title = firstViewController.title
        }
        
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: ">>", style: .Plain, target: self, action: #selector(toLastPage)),
            UIBarButtonItem(title: "<<", style: .Plain, target: self, action: #selector(toFirstPage))
        ]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if case .Some("PageViewController") = segue.identifier {
            guard let pageViewController = segue.destinationViewController as? UIPageViewController else {
                fatalError()
            }
            
            self.pageViewController = pageViewController
        }
    }
    
    func toFirstPage(sender: AnyObject) {
        let firstViewController = self.pageViewDataSource.firstViewController()
        self.pageViewController.setViewControllers([firstViewController], direction: .Reverse, animated: true, completion: nil)
    }
    
    func toLastPage(sender: AnyObject) {
        let lastViewController = self.pageViewDataSource.lastViewController()
        self.pageViewController.setViewControllers([lastViewController], direction: .Forward, animated: true, completion: nil)
    }
}

extension ScrollPagingViewController: UIPageViewControllerDelegate {
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        // NOTE: self.viewControllers?.firstが現在のページに対応するVC
        self.navigationItem.title = self.pageViewController.viewControllers?.first?.title
    }
}
