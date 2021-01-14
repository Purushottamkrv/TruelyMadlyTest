//
//  ContactListTableCell.swift
//  iOS Contact List
//
//  Created by Purushottam on 11/01/21.
//  Copyright © 2021 Purushottam. All rights reserved.
//

import UIKit

class ContactListTableCell: UITableViewCell {
    @IBOutlet weak var contactNameLabel:UILabel!
    @IBOutlet weak var contactImageView:UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
