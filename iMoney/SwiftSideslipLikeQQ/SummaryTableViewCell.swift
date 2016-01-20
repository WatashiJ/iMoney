//
//  SummaryTableViewCell.swift
//  iMoney
//
//  Created by Yaxin Cheng on 2016-01-19.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import UIKit

class SummaryTableViewCell: UITableViewCell {

    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var summaryLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
