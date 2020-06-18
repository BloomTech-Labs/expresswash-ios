//
//  AddCarViewController.swift
//  ExpressWash
//
//  Created by Bobby Keffury on 5/29/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import UIKit

class AddCarViewController: UIViewController, UINavigationControllerDelegate,
UIImagePickerControllerDelegate, UITextFieldDelegate {

    // MARK: - Properties

    var carController = CarController()
    var photoController = PhotoController()
    var user: User?

    // MARK: - Outlets

    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var showCameraTapped: UIButton!
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

        addCarButton.layer.cornerRadius = 10.0
        carImageView.layer.cornerRadius = 10.0
        licenseTextField.delegate = self
    }

    private func setupCamera() {
        let camera = UIImagePickerController()
        camera.sourceType = .camera
        camera.allowsEditing = true
        camera.delegate = self
        present(camera, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }

        carImageView.image = image
    }

    func tieCar(carRep: CarRepresentation, carId: Int) {
        carController.tieCar(carRep, with: carId) { (_, error) in
            if let error = error {
                print("Error tying car to user: \(error)")
                return
            }
        }
    }

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let maxLength = 7
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }

    // MARK: - Actions

    @IBAction func addCarButtonTapped(_ sender: Any) {
        guard let year = yearTextField.text,
              let make = makeTextField.text,
              let model = modelTextField.text,
              let licensePlate = licenseTextField.text,
              let color = colorTextField.text,
              let category = categoryTextField.text else { return }

        let segment = sizeSegmentedControl.selectedSegmentIndex
        guard let size = sizeSegmentedControl.titleForSegment(at: segment),
              let yearInt = Int16(year),
              let clientID = UserController.shared.sessionUser.user?.userId else { return }

        let carRepresentation = CarRepresentation(carId: nil,
                                                  clientId: Int(clientID),
                                                  make: make,
                                                  model: model,
                                                  year: yearInt,
                                                  color: color,
                                                  licensePlate: licensePlate,
                                                  photo: nil,
                                                  category: category,
                                                  size: size)

        carController.addCar(carRepresentation: carRepresentation) { (car, error) in
            if let error = error {
                print("Error creating car: \(error)")
                return
            }

            guard let car = car else { return }

            DispatchQueue.main.async {
                if let photo = self.carImageView.image {
                    DispatchQueue.global(qos: .background).async {
                        self.photoController.uploadPhoto(photo, httpMethod: "POST", endpoint: .imagesCar,
                                                         theID: Int(car.carId)) { (data, error) in
                            if let error = error {
                                print("Error uploading car photo: \(error)")
                                return
                            }

                            guard let data = data else { return }

                            if let car = self.carController.decodeCar(with: data) {
                                guard let user = self.user else { return }
                                user.addToCars(car)
                                self.tieCar(carRep: carRepresentation, carId: Int(car.carId))

                                let moc = CoreDataStack.shared.mainContext
                                do {
                                    try moc.save()
                                } catch {
                                    print("Error saving added car: \(error)")
                                }
                            }
                        }
                    }
                }
            }

            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    @IBAction func captureImageButtonTapped(_ sender: Any) {
        setupCamera()
    }
}
