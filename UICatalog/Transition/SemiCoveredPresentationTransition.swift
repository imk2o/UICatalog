//
//  SemiCoveredPresentationTransition.swift
//  UICatalog
//
//  Created by k2o on 2016/10/24.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

class SemiCoveredPresentationController: UIPresentationController {
    enum Edge {
        case top
        case right
        case bottom
        case left
    }
    
    private var overlayView: UIView!
    private let edge: Edge
    private let coverRatio: CGFloat
    
    init(presentedViewController presented: UIViewController, presenting: UIViewController?,
         edge: Edge, coverRatio: CGFloat = 0.8) {
        self.edge = edge
        self.coverRatio = coverRatio
        super.init(presentedViewController: presented, presenting: presenting)
    }
    
    override func presentationTransitionWillBegin() {
        // present時、遷移元VCと遷移先VCのビューの間に半透明ビューを挟むとともに、
        // 遷移アニメーションとタップハンドラを設定する
        let containerView = self.containerView!
        
        self.overlayView = UIView(frame: containerView.bounds)
        self.overlayView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SemiCoveredPresentationController.overlayViewDidTouch)))
        self.overlayView.backgroundColor = UIColor.black
        self.overlayView.alpha = 0.0
        containerView.insertSubview(self.overlayView, at: 0)
        
        self.presentedViewController.transitionCoordinator?.animate(
            alongsideTransition: { (context) in
                self.overlayView.alpha = 0.5
            }, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        // dismiss時の半透明ビューのアニメーション
        self.presentedViewController.transitionCoordinator?.animate(
            alongsideTransition: { (context) in
                self.overlayView.alpha = 0.0
            }, completion: nil)
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            self.overlayView.removeFromSuperview()
        }
    }
    
    override func size(
        forChildContentContainer container: UIContentContainer,
        withParentContainerSize parentSize: CGSize
        ) -> CGSize {
        // 遷移先VCのビューの大きさを求める
        // 実装しなければ画面全体に表示される
        switch self.edge {
        case .left, .right:
            return CGSize(width: parentSize.width * self.coverRatio, height: parentSize.height)
        case .top, .bottom:
            return CGSize(width: parentSize.width, height: parentSize.height * self.coverRatio)
        }
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        // 遷移先VCのビューを、画面上のどこに表示するかを求める
        guard let containerBounds = self.containerView?.bounds else {
            fatalError()
        }
        
        let size = self.size(forChildContentContainer: self.presentedViewController, withParentContainerSize: containerBounds.size)
        switch self.edge {
        case .top:
            return CGRect(
                origin: CGPoint.zero,
                size: size
            )
        case .right:
            return CGRect(
                origin: CGPoint(x: containerBounds.width - size.width, y: 0),
                size: size
            )
        case .bottom:
            return CGRect(
                origin: CGPoint(x: 0, y: containerBounds.height - size.height),
                size: size
            )
        case .left:
            return CGRect(
                origin: CGPoint.zero,
                size: size
            )
        }
    }
    
    override func containerViewWillLayoutSubviews() {
        self.overlayView.frame = containerView!.bounds
        self.presentedView?.frame = self.frameOfPresentedViewInContainerView
    }
    
    override func containerViewDidLayoutSubviews() {
    }
    
    func overlayViewDidTouch() {
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }
}

class SemiCoveredViewTransition: NSObject, UIViewControllerAnimatedTransitioning {
    /// 遷移時間.
    let forPresent: Bool
    let edge: SemiCoveredPresentationController.Edge
    let duration: TimeInterval
    
    init(forPresent: Bool, edge: SemiCoveredPresentationController.Edge, duration: TimeInterval = 0.3) {
        self.forPresent = forPresent
        self.edge = edge
        self.duration = duration
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval
    {
        // アニメーション時間を返す
        return self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning)
    {
        // アニメーションを行う
        if self.forPresent {
            self.presentTrantision(using: transitionContext)
        } else {
            self.dismissTrantision(using: transitionContext)
        }
    }
    
    private func presentTrantision(using transitionContext: UIViewControllerContextTransitioning) {
        //let fromVC = transitionContext.viewController(forKey: .from)!
        let toVC = transitionContext.viewController(forKey: .to)!
        let containerView = transitionContext.containerView
        
        // edgeに対応する始終点を求める
        let screenBounds = UIScreen.main.bounds
        let toViewBounds = toVC.view.bounds
        let (startOrigin, goalOrigin) = { () -> (CGPoint, CGPoint) in
            switch self.edge {
            case .top:
                return (
                    CGPoint(x: 0, y: -toViewBounds.height),
                    CGPoint.zero
                )
            case .right:
                return (
                    CGPoint(x: screenBounds.width, y: 0),
                    CGPoint(x: screenBounds.width - toViewBounds.width, y: 0)
                )
            case .bottom:
                return (
                    CGPoint(x: 0, y: screenBounds.height),
                    CGPoint(x: 0, y: screenBounds.height - toViewBounds.height)
                )
            case .left:
                return (
                    CGPoint(x: -toViewBounds.width, y: 0),
                    CGPoint.zero
                )
            }
        }()
        
        toVC.view.frame.origin = startOrigin
        // present時は遷移先VCのビューをcontainerViewに追加しないと表示されない
        containerView.addSubview(toVC.view)
        UIView.animate(
            withDuration: self.duration,
            animations: {
                toVC.view.frame.origin = goalOrigin
            }, completion: { (finished) in
                transitionContext.completeTransition(finished)
            }
        )
    }
    
    private func dismissTrantision(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: .from)!
        //let toVC = transitionContext.viewController(forKey: .to)!
        //let containerView = transitionContext.containerView
        
        // edgeに対応する終点を求める
        let screenBounds = UIScreen.main.bounds
        let toViewBounds = fromVC.view.bounds
        let goalOrigin = { () -> CGPoint in
            switch self.edge {
            case .top:
                return CGPoint(x: 0, y: -toViewBounds.height)
            case .right:
                return CGPoint(x: screenBounds.width, y: 0)
            case .bottom:
                return CGPoint(x: 0, y: screenBounds.height)
            case .left:
                return CGPoint(x: -toViewBounds.width, y: 0)
            }
        }()
        
        UIView.animate(
            withDuration: self.duration,
            animations: {
                fromVC.view.frame.origin = goalOrigin
            }, completion: { (finished) in
                transitionContext.completeTransition(finished)
            }
        )
    }
}
