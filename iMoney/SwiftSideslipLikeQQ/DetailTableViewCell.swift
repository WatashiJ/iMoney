//
//  DetailTableViewCell.swift
//  iMoney
//
//  Created by Yaxin Cheng on 2016-01-19.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    var title: String! {
        didSet {
            setEverything()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if title != nil {
            setEverything()
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setEverything() {
        if iconView != nil {
            iconView.tintColor = Common.commonColour
            iconView.image = Common.icons[title]
        }
    }

}
