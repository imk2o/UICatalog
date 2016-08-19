//
//  SwitchChildrenViewController.swift
//  UICatalog
//
//  Created by k2o on 2016/08/19.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

class SwitchChildrenViewController: UIViewController {
    private var firstViewController: UIViewController!
    private var secondViewController: UIViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.firstViewController = self.storyboard?.instantiateViewControllerWithIdentifier("FirstView")
        self.secondViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SecondView")
        
        self.switchChildView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func switchButtonDidTap(sender: UIBarButtonItem) {
        self.switchChildView()
    }
}

private extension SwitchChildrenViewController {
    func switchChildView() {
        switch self.currentChildViewController {
        case self.firstViewController?:
            self.setCurrentChild(self.secondViewController, animated: true) {
                print("Show Second View (with animation)")
            }
        case self.secondViewController?, .None:
            self.setCurrentChild(self.firstViewController, animated: false) {
                print("Show First View (no animation)")
            }
        default:
            break
        }
    }
    
    var currentChildViewController: UIViewController? {
        return self.childViewControllers.first
    }
    
    func setCurrentChild(
        newChildViewController: UIViewController,
        animated: Bool,
        completion: (() -> Void)? = nil
    ) {
        if let oldChildViewController = self.currentChildViewController {
            oldChildViewController.willMoveToParentViewController(self)
            self.addChildViewController(newChildViewController)
            
            let (duration, options) = animated ?
                (0.25, UIViewAnimationOptions.TransitionCrossDissolve) :
                (0.0, UIViewAnimationOptions.TransitionNone)
            
            self.transitionFromViewController(
                oldChildViewController,
                toViewController: newChildViewController,
                duration: duration,
                options: options,
                animations: nil,
                completion: { (finished) in
                    oldChildViewController.removeFromParentViewController()
                    newChildViewController.didMoveToParentViewController(self)
                    completion?()
                }
            )
        } else {
            self.addChildViewController(newChildViewController)
            self.view.addSubview(newChildViewController.view)
            newChildViewController.didMoveToParentViewController(self)
            completion?()
        }
    }
}