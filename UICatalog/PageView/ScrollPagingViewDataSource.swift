//
//  ScrollPagingViewDataSource.swift
//  UICatalog
//
//  Created by k2o on 2016/08/18.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

class ScrollPagingViewDataSource: NSObject, UIPageViewControllerDataSource {
    fileprivate let articles: [Article]
    fileprivate var numberOfPages: Int {
        return self.articles.count
    }
    
    init(articles: [Article]) {
        self.articles = articles
    }
    
    func firstViewController() -> UIViewController {
        return self.viewController(at: 0)
    }
    
    func lastViewController() -> UIViewController {
        return self.viewController(at: self.numberOfPages - 1)
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
        ) -> UIViewController? {
        let index = self.indexOf(viewController)
        if index == 0 {
            return nil
            // Infinite loop
            //return self.viewController(at: self.numberOfPages - 1)
        }
        
        return self.viewController(at: index - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = self.indexOf(viewController)
        if index == self.numberOfPages - 1 {
            return nil
            // Infinite loop
            //return self.viewController(at: 0)
        }
        
        return self.viewController(at: index + 1)
    }
    
    fileprivate func viewController(at index: Int) -> UIViewController {
        let storyboard = UIStoryboard(name: "PageView", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "PageContentView") as? PageContentViewController else {
            fatalError()
        }
        
        let image = self.articles[index].image(for: "large")
        viewController.configure(with: index, image: image)
        
        return viewController
    }
    
    fileprivate func indexOf(_ viewController: UIViewController) -> Int {
        guard let viewController = viewController as? PageContentViewController else {
            fatalError()
        }
        
        return viewController.pageIndex
    }
}
