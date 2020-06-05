//
//  ReceiptDetailViewController.swift
//  ExpressWash
//
//  Created by Bobby Keffury on 6/3/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import UIKit

class ReceiptDetailViewController: UIViewController {

    // MARK: - Properties

    var job: Job?

    // MARK: - Outlets

    @IBOutlet weak var washDateLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cityStateLabel: UILabel!
    @IBOutlet weak var timeTakenLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var beforeImageView: UIImageView!
    @IBOutlet weak var afterImageView: UIImageView!
    @IBOutlet weak var washerProfileImageView: UIImageView!
    @IBOutlet weak var washerNameLabel: UILabel!
    @IBOutlet weak var washerRatingLabel: UILabel!
    @IBOutlet weak var washerAboutMeTextView: UITextView!

    @IBOutlet weak var rateWasherButton: UIButton!

    // MARK: - Views

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Methods

    // MARK: - Actions

    @IBAction func rateWasherButtonClicked(_ sender: Any) {
    }
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}
