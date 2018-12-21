//
//  SharedCellTableViewController.swift
//  UICatalog
//
//  Created by k2o on 2016/12/06.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

class SharedCellTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var articles: [Article] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Self sizing
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableView.automaticDimension
        
        self.articles = ArticleProvider.shared.allArticles()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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

extension SharedCellTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? SharedTableViewCell else {
            fatalError()
        }
        let article = self.articles[indexPath.row]
        
        cell.configure(withText: article.detail, image: article.image(for: "small"))
        
        return cell
    }
}
