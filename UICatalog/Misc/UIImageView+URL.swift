//
//  UIImageView+URL.swift
//  UICatalog
//
//  Created by k2o on 2016/11/18.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

extension UIImageView {
    func setImage(with url: URL) {
        let task = URLSession.shared.downloadImageTask(with: url) { (image, error) in
            DispatchQueue.main.async {
                self.image = image
            }
        }
        
        task.resume()
    }
}
