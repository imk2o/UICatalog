//
//  OuterTableViewCell.swift
//  UICatalog
//
//  Created by k2o on 2019/03/25.
//  Copyright © 2019年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

/// Table ViewとCollection Viewを内包するCell。
class OuterTableViewCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!

    private var count: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.tableView.register(InnerTableViewCell.nib, forCellReuseIdentifier: "Cell")
        self.collectionView.register(InnerCollectionViewCell.nib, forCellWithReuseIdentifier: "Cell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(text: String, count: Int) {
        self.label.text = text
        self.count = count

        // 内包Table Viewを更新
        self.tableView.reloadData()
        self.tableView.layoutIfNeeded()
        // 内包Collection Viewを更新
        self.collectionView.reloadData()
        self.collectionView.layoutIfNeeded()
    }
    
    private func itemText(at indexPath: IndexPath) -> String {
        return "Item\(indexPath.item)"
    }
    
    private func tagText(at indexPath: IndexPath) -> String {
        return "Tag\(indexPath.item)"
    }
}

// MARK: - 内包Table ViewのData Source。
extension OuterTableViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! InnerTableViewCell
        
        cell.configure(text: self.itemText(at: indexPath))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Header\(section)"
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "Footer\(section)"
    }
}

// MARK: - 内包Collection ViewのData Source。
extension OuterTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! InnerCollectionViewCell
        
        cell.configure(text: self.tagText(at: indexPath))
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return InnerCollectionViewCell.computeSize(text: self.tagText(at: indexPath))
    }
}
