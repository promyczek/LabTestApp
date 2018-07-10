//
//  ArticleViewCell.swift
//  LabTestApp
//
//  Created by Anna Zamora on 23/02/2018.
//  Copyright © 2018 Anna Zamora. All rights reserved.
//

import UIKit

class ArticleViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
