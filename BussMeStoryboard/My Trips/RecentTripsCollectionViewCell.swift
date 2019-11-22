//
//  RecentTripsCollectionViewCell.swift
//  BussMeStoryboard
//
//  Created by Kevin Susanto on 22/11/19.
//  Copyright © 2019 Ricky Effendi. All rights reserved.
//

import UIKit

class RecentTripsCollectionViewCell: UICollectionViewCell {
    @IBOutlet var busCode: UIImageView!
    @IBOutlet var indicator: UIImageView!
    @IBOutlet var routeLabel: UILabel!
    @IBOutlet var startPoint: UILabel!
    @IBOutlet var endPoint: UILabel!
    
    func displayContent(image:UIImage, title:String) {
        busCode.image = image
        routeLabel.text = title
    }
    
}
