//
//  PageContentViewController.swift
//  UICatalog
//
//  Created by k2o on 2016/08/18.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

class PageContentViewController: UIViewController {
    fileprivate(set) var pageIndex: Int!
    fileprivate var image: UIImage?
    
    @IBOutlet weak var imageView: UIImageView!
    
    fileprivate var pageNumber: Int {
        return self.pageIndex + 1
    }

    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        let title = "Page\(self.pageNumber)"
        self.title = title
        
        self.imageView.image = image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configure(with pageIndex: Int, image: UIImage?) {
        self.pageIndex = pageIndex
        self.image = image
    }
}
