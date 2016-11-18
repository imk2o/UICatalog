//
//  URLSession+DownloadImage.swift
//  UICatalog
//
//  Created by k2o on 2016/11/18.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import Foundation
import UIKit

extension URLSession {
    func downloadImageTask(with url: URL, completionHandler handler: @escaping (UIImage?, Error?) -> Void) -> URLSessionTask {
        return self.downloadTask(with: url) { (location, _, error) in
            guard
                let location = location,
                let imageData = try? Data(contentsOf: location)
            else {
                handler(nil, error)
                return
            }
            
            handler(UIImage(data: imageData), nil)
        }
    }
}
