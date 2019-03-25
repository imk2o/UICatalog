//
//  SwitchChildrenViewController.swift
//  UICatalog
//
//  Created by k2o on 2016/08/19.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

class SwitchChildrenViewController: UIViewController {
    fileprivate var firstViewController: UIViewController!
    fileprivate var secondViewController: UIViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.firstViewController = self.storyboard?.instantiateViewController(withIdentifier: "FirstView")
        self.secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "SecondView")
        
        self.switchChildView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func switchButtonDidTap(_ sender: UIBarButtonItem) {
        self.switchChildView()
    }
}

fileprivate extension SwitchChildrenViewController {
    func switchChildView() {
        switch self.currentChildViewController {
        case self.firstViewController?:
            self.setCurrentChild(self.secondViewController, animated: true) {
                print("Show Second View (with animation)")
            }
        case self.secondViewController?, .none:
            self.setCurrentChild(self.firstViewController, animated: false) {
                print("Show First View (no animation)")
            }
        default:
            break
        }
    }
    
    var currentChildViewController: UIViewController? {
        return self.children.first
    }
    
    func setCurrentChild(
        _ newChildViewController: UIViewController,
        animated: Bool,
        completion: (() -> Void)? = nil
    ) {
        // Child view controllerの追加手順
        // ・self.addChildViewController(childVC)
        // ・self.view.addSubview(childVC.view)
        // ・childVC.didMove(toParentViewController: self)
        //
        // Child view controllerの削除手順
        // ・childVC.willMove(toParentViewController: self)
        // ・childVC.view.removeFromSuperview()
        // ・childVC.removeFromParentViewController()
        if let oldChildViewController = self.currentChildViewController {
            oldChildViewController.willMove(toParent: self)
            self.addChild(newChildViewController)
            
            let (duration, options) = animated ?
                (0.25, UIView.AnimationOptions.transitionCrossDissolve) :
                (0.0, UIView.AnimationOptions())
            
            self.transition(
                from: oldChildViewController,
                to: newChildViewController,
                duration: duration,
                options: options,
                animations: nil,
                completion: { (finished) in
                    oldChildViewController.view.removeFromSuperview()
                    oldChildViewController.removeFromParent()
                    newChildViewController.didMove(toParent: self)
                    completion?()
                }
            )
        } else {
            self.addChild(newChildViewController)
            self.view.addSubview(newChildViewController.view)
            newChildViewController.didMove(toParent: self)
            completion?()
        }
    }
}
