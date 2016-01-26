//
//  CategoryViewCell.swift
//  iMoney
//
//  Created by Yaxin Cheng on 2016-01-25.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import UIKit

class CategoryViewCell: UITableViewCell {

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
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
        if titleLabel != nil {
            titleLabel.text = title
        }
        if iconView != nil {
            switch title {
            case "Vegetables":
                iconView.image = UIImage(named: "vege")
            case "Groceries":
                iconView.image = UIImage(named: "grocery")
            default:
                break
            }
        }
    }
}
