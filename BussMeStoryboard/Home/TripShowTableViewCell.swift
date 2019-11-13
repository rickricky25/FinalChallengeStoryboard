//
//  TripShowTableViewCell.swift
//  BussMeStoryboard
//
//  Created by Ricky Effendi on 11/11/19.
//  Copyright © 2019 Ricky Effendi. All rights reserved.
//

import UIKit

class TripShowTableViewCell: UITableViewCell {
    @IBOutlet weak var lblSumber: UILabel!
    @IBOutlet weak var lblTujuan: UILabel!
    @IBOutlet weak var lblWaktu: UILabel!
    @IBOutlet weak var lblDurasi: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
