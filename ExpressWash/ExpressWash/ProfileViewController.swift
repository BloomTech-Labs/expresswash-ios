//
//  ProfileViewController.swift
//  ExpressWash
//
//  Created by Bobby Keffury on 4/22/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    // MARK: - Properties

    // MARK: - Outlets

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var creditCardButton: UIButton!

    // MARK: - Views

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Methods

    // MARK: - Actions

    @IBAction func creditCardButtonTapped(_ sender: Any) {
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
}
