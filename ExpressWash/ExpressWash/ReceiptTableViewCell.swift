//
//  ReceiptTableViewCell.swift
//  ExpressWash
//
//  Created by Bobby Keffury on 5/12/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import UIKit

class ReceiptTableViewCell: UITableViewCell {

    @IBOutlet weak var washerImage: UIImageView!
    @IBOutlet weak var washerName: UILabel!
    @IBOutlet weak var washerRating: UILabel!
    @IBOutlet weak var timeTakenLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var beforeImageView: UIImageView!
    @IBOutlet weak var afterImageView: UIImageView!

    override func awakeFromNib() {
        washerImage.layer.cornerRadius = washerImage.frame.size.height/2
        beforeImageView.layer.cornerRadius = 5.0
        afterImageView.layer.cornerRadius = 5.0
    }
}
