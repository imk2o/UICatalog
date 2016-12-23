//
//  DesignedComponentsViewController.swift
//  UICatalog
//
//  Created by k2o on 2016/12/23.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

class DesignedComponentsViewController: UIViewController {

    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func button2SelectedSwitchDidChange(_ sender: UISwitch) {
        self.button2.isSelected = sender.isOn
    }

    @IBAction func button3SwitchDidChange(_ sender: UISwitch) {
        self.button3.isEnabled = sender.isOn
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
