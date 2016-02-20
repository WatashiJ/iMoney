//
//  SwitchSettingViewCell.swift
//  iMoney
//
//  Created by Yaxin Cheng on 2016-02-20.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import UIKit

class SwitchSettingViewCell: UITableViewCell {

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var controlSwitch: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func switchStatusChanged(sender: UISwitch) {
        switch infoLabel.text! {
        case "Group By Date":
            let userDefault = NSUbiquitousKeyValueStore.defaultStore()
            userDefault.setBool(sender.on, forKey: "groupByDate")
        default: break
        }
    }
}
