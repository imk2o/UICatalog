//
//  InnerTableViewCell.swift
//  UICatalog
//
//  Created by k2o on 2019/03/25.
//  Copyright © 2019年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

/// Cell内Table View用のCell。
class InnerTableViewCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(text: String) {
        self.label.text = text
    }
}
