//
//  TransitionCoverViewController.swift
//  UICatalog
//
//  Created by k2o on 2016/10/19.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

class TransitionCoverViewController: UIViewController {
    var presentationEdge: SemiCoveredPresentationController.Edge = .bottom
    
    override func awakeFromNib() {
        // 基本的に遷移先画面に対してtransitionDelegateを設定
        self.transitioningDelegate = self
        // カスタムのUIPresentationControllerを使用する場合は以下を指定
        self.modalPresentationStyle = .custom
        
        // 上記はいずれも遷移元VCのprepareForSegueで設定しても可
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension TransitionCoverViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        // カスタムUIPresentationControllerを返す
        return SemiCoveredPresentationController(
            presentedViewController: presented,
            presenting: presenting,
            edge: self.presentationEdge
        )
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // present用のカスタムアニメーションを返す
        return SemiCoveredViewTransition(forPresent: true, edge: self.presentationEdge)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // dismiss用のカスタムアニメーションを返す
        return SemiCoveredViewTransition(forPresent: false, edge: self.presentationEdge)
    }
}
