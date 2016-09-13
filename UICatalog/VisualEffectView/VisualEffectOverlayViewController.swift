//
//  VisualEffectOverlayViewController.swift
//  UICatalog
//
//  Created by k2o on 2016/09/12.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

class VisualEffectOverlayViewController: UIViewController {

    @IBOutlet weak var visualEffectView: UIVisualEffectView!
//    @IBOutlet weak var visualEffectVibrancyView: UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setBlurEffectStyle(nil, animated: false)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        dispatch_async(dispatch_get_main_queue()) {
            self.setBlurEffectStyle(.Light, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func dismiss(sender: UIButton) {
        self.setBlurEffectStyle(.None, animated: true) { 
            self.dismissViewControllerAnimated(false, completion: nil)
        }
    }
    
    @IBAction func editStyle(sender: UIButton) {
        let items: [(String, UIBlurEffectStyle?)] = [
            ("ExtraLight", .ExtraLight),
            ("Light", .Light),
            ("Dark", .Dark),
            ("None", nil)
        ]
        self.pickItem(
            from: items,
            title: nil,
            message: "UIView.animateWithDuration()でBlur Styleを変えることでアニメーションします。nilにすると、ぼかし半径を変えながらアニメーションします。"
        ) { (title, value) in
            dispatch_async(dispatch_get_main_queue()) {
                self.setBlurEffectStyle(value, animated: true)
            }
        }
    }

    private func setBlurEffectStyle(style: UIBlurEffectStyle?, animated: Bool, completion handler: (() -> Void)? = nil) {
        if animated {
            UIView.animateWithDuration(
                0.5,
                animations: {
                    self.setBlurEffectStyle(style, animated: false)
                },
                completion: { (finished) in
                    handler?()
                }
            )
        } else {
            let blurEffect = style.map { UIBlurEffect(style: $0) }
            self.visualEffectView.effect = blurEffect
            // TODO: Vibrancy Effectはアニメーションしない？
            //self.visualEffectVibrancyView.effect = blurEffect.map { UIVibrancyEffect(forBlurEffect: $0) }
            
            handler?()
        }
    }
}
