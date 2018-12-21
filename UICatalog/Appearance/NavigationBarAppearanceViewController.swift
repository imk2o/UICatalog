//
//  NavigationBarAppearanceViewController.swift
//  UICatalog
//
//  Created by k2o on 2016/09/05.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

class NavigationBarAppearanceViewController: UITableViewController {
    fileprivate let barStyleItems = [
        ("Default", UIBarStyle.default),
        ("Black", UIBarStyle.black)
    ]
    
    fileprivate var statusBarHidden: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
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
            if let translucent = self.navigationController?.navigationBar.isTranslucent {
                cell.accessoryType = translucent ? .checkmark : .none
            }
        case "HiddenCell"?:
            if let hidden = self.navigationController?.isNavigationBarHidden {
                cell.accessoryType = hidden ? .checkmark : .none
            }
        default:
            break
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            fatalError()
        }
        
        switch cell.reuseIdentifier {
        case "BarStyleCell"?:
            self.pickItem(from: self.barStyleItems) { (title, style) in
                self.navigationController?.navigationBar.barStyle = style
                cell.detailTextLabel?.text = title
            }
        case "TranslucentCell"?:
            if let translucent = self.navigationController?.navigationBar.isTranslucent {
                self.navigationController?.navigationBar.isTranslucent = !translucent
                cell.accessoryType = !translucent ? .checkmark : .none
            }
        case "NavigationBarTintColorCell"?:
            self.navigationController?.navigationBar.tintColor = UIColor.red
        case "NavigationBarBarTintColorCell"?:
            self.navigationController?.navigationBar.barTintColor = UIColor.yellow
        case "NavigationBarTitleTextColorCell"?:
            self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.blue]
        case "HiddenCell"?:
            if let hidden = self.navigationController?.isNavigationBarHidden {
                self.navigationController?.setNavigationBarHidden(!hidden, animated: true)
                cell.accessoryType = !hidden ? .checkmark : .none
            }
        case "StatusBarHiddenCell"?:
            self.statusBarHidden = !self.statusBarHidden
            self.setNeedsStatusBarAppearanceUpdate()
            cell.accessoryType = self.statusBarHidden ? .checkmark : .none
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override var prefersStatusBarHidden : Bool {
        return self.statusBarHidden
    }
}
