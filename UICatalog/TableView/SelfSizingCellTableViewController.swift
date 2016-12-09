//
//  SelfSizingCellTableViewController.swift
//  UICatalog
//
//  Created by k2o on 2016/06/17.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

class SelfSizingCellTableViewController: UIViewController {
    fileprivate var articles: [Article] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.estimatedRowHeight = 120
        self.tableView.rowHeight = UITableViewAutomaticDimension

        self.articles = ArticleProvider.shared.allArticles()
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
}

extension SelfSizingCellTableViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ArticleTableViewCell else {
            fatalError()
        }
        let article = self.articles[indexPath.row]
        
        cell.configure(with: article)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return [
            "Self sizing cellを有効にする場合はまず以下を行います。",
            "・`UITableView#estimatedRowHeight`におおよそのセルの高さを設定",
            "・`UITableView#rowHeight`に`UITableViewAutomaticDimension`を設定",
            "",
            "UITableViewCellのAuto Layoutは以下に注意します。",
            "・伸張する必要のないUILabelは`Content Hugging Priority`を251より大きくする",
            "・すべてのテキストを表示するUILabelは`Lines`を0にする",
            "・伸張するラベルと画像を並べる場合、label.height >= imageView.heightとなるConstraintを設定する"
            ].joined(separator: "\n")
    }
}
