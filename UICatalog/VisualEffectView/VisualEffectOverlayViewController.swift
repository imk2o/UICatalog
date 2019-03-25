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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.async {
            self.setBlurEffectStyle(.light, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func dismiss(_ sender: UIButton) {
        self.setBlurEffectStyle(.none, animated: true) { 
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func editStyle(_ sender: UIButton) {
        let items: [(String, UIBlurEffect.Style?)] = [
            ("ExtraLight", .extraLight),
            ("Light", .light),
            ("Dark", .dark),
            ("None", nil)
        ]
        self.pickItem(
            from: items,
            title: nil,
            message: "UIView.animateWithDuration()でBlur Styleを変えることでアニメーションします。nilにすると、ぼかし半径を変えながらアニメーションします。"
        ) { (title, value) in
            DispatchQueue.main.async {
                self.setBlurEffectStyle(value, animated: true)
            }
        }
    }

    fileprivate func setBlurEffectStyle(_ style: UIBlurEffect.Style?, animated: Bool, completion handler: (() -> Void)? = nil) {
        if animated {
            UIView.animate(
                withDuration: 0.5,
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
