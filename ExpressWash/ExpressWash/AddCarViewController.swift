//
//  AddCarViewController.swift
//  ExpressWash
//
//  Created by Bobby Keffury on 5/29/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import UIKit

class AddCarViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var makeTextField: UITextField!
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var licenseTextField: UITextField!
    @IBOutlet weak var colorTextField: UITextField!
    @IBOutlet weak var categorySegmentedControl: UISegmentedControl!
    @IBOutlet weak var addCarButton: UIButton!

    // MARK: - Outlets

    // MARK: - Views

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Methods

    // MARK: - Actions

    @IBAction func addCarButtonTapped(_ sender: Any) {
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
}
