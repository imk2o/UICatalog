//
//  PopoverParentViewController.swift
//  UICatalog
//
//  Created by k2o on 2017/06/11.
//  Copyright © 2017年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

class PopoverParentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "popToUp"?:
            self.preparePopoverViewController(
                segue.destination,
                sourceView: sender as? UIView,
                permittedArrowDirections: .down
            )
        case "popToDown"?:
            self.preparePopoverViewController(
                segue.destination,
                sourceView: sender as? UIView,
                permittedArrowDirections: .up
            )
        default:
            break
        }
    }

    func preparePopoverViewController(
        _ viewController: UIViewController,
        sourceView: UIView?,
        permittedArrowDirections: UIPopoverArrowDirection
    ) {
        guard let popoverPresentationController = viewController.popoverPresentationController else {
            return
        }

        // UIPopoverPresentationControllerDelegateの実装先
        popoverPresentationController.delegate = self
        // Popoverのアロー方向と位置を調整
        popoverPresentationController.permittedArrowDirections = permittedArrowDirections
        if let sourceView = sourceView {
            popoverPresentationController.sourceView = sourceView
            popoverPresentationController.sourceRect = sourceView.bounds
        }
    }
}

extension PopoverParentViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none		// こうしないとiPhoneでPopoverしない
    }
}
