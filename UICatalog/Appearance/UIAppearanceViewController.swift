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

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

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
        
        cell.accessoryType = customized ? .checkmark : .none

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            fatalError()
        }
        
        let customized: Bool
        switch cell.reuseIdentifier {
        case "NavigationBarTintColorCell"?:
            customized = self.toggleAppearance(UIColor.red, for: "UINavigationBar.tintColor")
        case "NavigationBarBarTintColorCell"?:
            customized = self.toggleAppearance(UIColor.yellow, for: "UINavigationBar.barTintColor")
        case "NavigationBarTitleTextColorCell"?:
            customized = self.toggleAppearance(UIColor.blue, for: "UINavigationBar.titleTextColor")
        default:
            customized = false
        }

        cell.accessoryType = customized ? .checkmark : .none
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

fileprivate extension UIAppearanceViewController {
    func appearanceCustomized(_ key: String) -> Bool {
        return UserDefaultsManager.shared.contains(for: key)
    }
    
    func toggleAppearance(_ color: UIColor, for key: String) -> Bool {
        if self.appearanceCustomized(key) {
            UserDefaultsManager.shared.remove(for: key)
            return false
        } else {
            UserDefaultsManager.shared.set(value: color, for: key)
            return true
        }
    }
}
