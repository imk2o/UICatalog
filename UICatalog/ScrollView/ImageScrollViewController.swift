//
//  ImageScrollViewController.swift
//  UICatalog
//
//  Created by k2o on 2022/02/12.
//  Copyright © 2022 imk2o. All rights reserved.
//

import UIKit
import AVFoundation

class ImageScrollViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // https://qiita.com/takehilo/items/17ee84059332650a21a7

    @IBAction func crop(_ sender: Any) {
        guard let image = imageView.image else { return }

        // [1]
        let cropAreaRect = scrollView.bounds

        // [2]
        let imageViewScale = max(
            (image.size.width * image.scale) / imageView.frame.width,
            (image.size.height * image.scale) / imageView.frame.height
        )

        // [3]
        let imageOriginInImageView = AVMakeRect(aspectRatio: image.size, insideRect: imageView.frame).origin

        // [4]
        let cropZone = CGRect(
            x: (cropAreaRect.origin.x - imageOriginInImageView.x) * imageViewScale,
            y: (cropAreaRect.origin.y - imageOriginInImageView.y) * imageViewScale,
            width: cropAreaRect.width * imageViewScale,
            height: cropAreaRect.height * imageViewScale
        )

        guard let croppedCGImage = image.cgImage?.cropping(to: cropZone) else { return }

        // [5]
        share(image: UIImage(cgImage: croppedCGImage))
    }
    
    private func share(image: UIImage) {
        let activityViewController = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )

        present(activityViewController, animated: true, completion: nil)
    }
}

extension ImageScrollViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
