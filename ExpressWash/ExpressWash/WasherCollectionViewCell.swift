//
//  WasherCollectionViewCell.swift
//  ExpressWash
//
//  Created by Bobby Keffury on 4/27/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import UIKit

class WasherCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var largeRateLabel: UILabel!
    @IBOutlet weak var mediumRateLabel: UILabel!
    @IBOutlet weak var smallRateLabel: UILabel!

    override func awakeFromNib() {
        imageView.layer.cornerRadius = imageView.frame.size.height/2
        self.layer.cornerRadius = 15.0
        self.layer.borderColor = UIColor.init(named: "Light Blue")?.cgColor
        self.layer.borderWidth = 2.0
    }
}
