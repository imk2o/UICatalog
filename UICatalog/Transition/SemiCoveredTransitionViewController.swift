//
//  SemiCoveredTransitionViewController.swift
//  UICatalog
//
//  Created by k2o on 2016/10/16.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

class SemiCoveredTransitionViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 四辺のどこから画面を表示するか調整
        switch segue.identifier {
        case "PresentFromTop"?:
            let destinationVC = segue.destination as! TransitionCoverViewController
            destinationVC.presentationEdge = .top
        case "PresentFromRight"?:
            let destinationVC = segue.destination as! TransitionCoverViewController
            destinationVC.presentationEdge = .right
        case "PresentFromBottom"?:
            let destinationVC = segue.destination as! TransitionCoverViewController
            destinationVC.presentationEdge = .bottom
        case "PresentFromLeft"?:
            let destinationVC = segue.destination as! TransitionCoverViewController
            destinationVC.presentationEdge = .left
        default:
            break
        }
    }
}
