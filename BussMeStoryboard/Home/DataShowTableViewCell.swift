//
//  DataShowTableViewCell.swift
//  BussMeStoryboard
//
//  Created by Ricky Effendi on 05/11/19.
//  Copyright © 2019 Ricky Effendi. All rights reserved.
//

import UIKit

class DataShowTableViewCell: UITableViewCell {
    @IBOutlet weak var lblLokasi: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblSender: UILabel!
    @IBOutlet weak var lblWaktu: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
