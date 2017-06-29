//
//  TableViewCell.swift
//  day05
//
//  Created by Cristian Cosneanu on 4/26/17.
//  Copyright © 2017 Cristian Cosneanu. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var delBTN: UIButton!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var swit: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
