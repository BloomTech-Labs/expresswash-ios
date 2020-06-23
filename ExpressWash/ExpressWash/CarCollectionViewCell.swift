//
//  CarCollectionViewCell.swift
//  ExpressWash
//
//  Created by Bobby Keffury on 5/16/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import UIKit

class CarCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var modelLabel: UILabel!

    override func awakeFromNib() {
        imageView.layer.cornerRadius = 5.0
    }

    @IBAction func carTapped(_ sender: Any) {
        addButtonTapAction?()
    }

    var addButtonTapAction : (() -> Void)?
}
