//
//  AppearanceViewController.swift
//  UICatalog
//
//  Created by k2o on 2016/09/04.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

class UIAppearanceViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)

        let customized: Bool
        switch cell.reuseIdentifier {
        case "NavigationBarTintColorCell"?:
            customized = self.appearanceCustomized("UINavigationBar.tintColor")
        case "NavigationBarBarTintColorCell"?:
            customized = self.appearanceCustomized("UINavigationBar.barTintColor")
        case "NavigationBarTitleTextColorCell"?:
            customized = self.appearanceCustomized("UINavigationBar.titleTextColor")
        default:
            customized = false
        }
        
        cell.accessoryType = customized ? .Checkmark : .None

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let cell = tableView.cellForRowAtIndexPath(indexPath) else {
            fatalError()
        }
        
        let customized: Bool
        switch cell.reuseIdentifier {
        case "NavigationBarTintColorCell"?:
            customized = self.toggleAppearance(UIColor.redColor(), for: "UINavigationBar.tintColor")
        case "NavigationBarBarTintColorCell"?:
            customized = self.toggleAppearance(UIColor.yellowColor(), for: "UINavigationBar.barTintColor")
        case "NavigationBarTitleTextColorCell"?:
            customized = self.toggleAppearance(UIColor.blueColor(), for: "UINavigationBar.titleTextColor")
        default:
            customized = false
        }

        cell.accessoryType = customized ? .Checkmark : .None
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

private extension UIAppearanceViewController {
    func appearanceCustomized(key: String) -> Bool {
        return UserDefaultsManager.shared.contains(for: key)
    }
    
    func toggleAppearance(color: UIColor, for key: String) -> Bool {
        if self.appearanceCustomized(key) {
            UserDefaultsManager.shared.remove(for: key)
            return false
        } else {
            UserDefaultsManager.shared.set(value: color, for: key)
            return true
        }
    }
}
