//
//  NavigationBarAppearanceViewController.swift
//  UICatalog
//
//  Created by k2o on 2016/09/05.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

class NavigationBarAppearanceViewController: UITableViewController {
    private let barStyleItems = [
        ("Default", UIBarStyle.Default),
        ("Black", UIBarStyle.Black)
    ]
    
    private var statusBarHidden: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        
        switch cell.reuseIdentifier {
        case "BarStyleCell"?:
            guard let barStyle = self.navigationController?.navigationBar.barStyle else {
                break
            }
            self.barStyleItems.filter { (title, style) -> Bool in
                return style == barStyle
            }.first.map {
                cell.detailTextLabel?.text = $0.0
            }
        case "TranslucentCell"?:
            if let translucent = self.navigationController?.navigationBar.translucent {
                cell.accessoryType = translucent ? .Checkmark : .None
            }
        case "HiddenCell"?:
            if let hidden = self.navigationController?.navigationBarHidden {
                cell.accessoryType = hidden ? .Checkmark : .None
            }
        default:
            break
        }

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let cell = tableView.cellForRowAtIndexPath(indexPath) else {
            fatalError()
        }
        
        switch cell.reuseIdentifier {
        case "BarStyleCell"?:
            self.pickItem(from: self.barStyleItems) { (title, style) in
                self.navigationController?.navigationBar.barStyle = style
                cell.detailTextLabel?.text = title
            }
        case "TranslucentCell"?:
            if let translucent = self.navigationController?.navigationBar.translucent {
                self.navigationController?.navigationBar.translucent = !translucent
                cell.accessoryType = !translucent ? .Checkmark : .None
            }
        case "NavigationBarTintColorCell"?:
            self.navigationController?.navigationBar.tintColor = UIColor.redColor()
        case "NavigationBarBarTintColorCell"?:
            self.navigationController?.navigationBar.barTintColor = UIColor.yellowColor()
        case "NavigationBarTitleTextColorCell"?:
            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blueColor()]
        case "HiddenCell"?:
            if let hidden = self.navigationController?.navigationBarHidden {
                self.navigationController?.setNavigationBarHidden(!hidden, animated: true)
                cell.accessoryType = !hidden ? .Checkmark : .None
            }
        case "StatusBarHiddenCell"?:
            self.statusBarHidden = !self.statusBarHidden
            self.setNeedsStatusBarAppearanceUpdate()
            cell.accessoryType = self.statusBarHidden ? .Checkmark : .None
        default:
            break
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return self.statusBarHidden
    }
}
