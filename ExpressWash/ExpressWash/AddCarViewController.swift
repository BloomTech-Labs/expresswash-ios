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

    private var carController = CarController()
    var user: User?

    // MARK: - Outlets

    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var captureImageButton: UIButton!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var makeTextField: UITextField!
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var licenseTextField: UITextField!
    @IBOutlet weak var colorTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var sizeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var addCarButton: UIButton!

    // MARK: - Views

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
    }

    // MARK: - Methods

    private func setupSubviews() {
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes, for: .normal)

        captureImageButton.isSelected = false
        addCarButton.layer.cornerRadius = 10.0
        setupCamera()
    }

    private func setupCamera() {
        //Set this up when backend allows it.
    }

    // MARK: - Actions

    @IBAction func addCarButtonTapped(_ sender: Any) {
        guard let year = yearTextField.text else { return }
        guard let make = makeTextField.text else { return }
        guard let model = modelTextField.text else { return }
        guard let licensePlate = licenseTextField.text else { return }
        guard let color = colorTextField.text else { return }
        guard let category = categoryTextField.text else { return }
        let segment = sizeSegmentedControl.selectedSegmentIndex
        guard let size = sizeSegmentedControl.titleForSegment(at: segment) else { return }

        guard let yearInt = Int16(year) else { return }

        let carRepresentation = CarRepresentation(carId: nil,
                                                  make: make,
                                                  model: model,
                                                  year: yearInt,
                                                  color: color,
                                                  licensePlate: licensePlate,
                                                  photo: "HANDLE THIS",
                                                  category: category,
                                                  size: size)

        carController.addCar(carRepresentation: carRepresentation) { (car, error) in
            if let error = error {
                print("Error creating car: \(error)")
                return
            }

            guard let car = car else { return }

            self.user?.addToCars(car)

            self.dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func captureImageButtonTapped(_ sender: Any) {
        if captureImageButton.isSelected {
            captureImageButton.isSelected = false
            //Show Camera
        } else {
            //Take Picture & Set it
            captureImageButton.isSelected = true
        }
    }
}
