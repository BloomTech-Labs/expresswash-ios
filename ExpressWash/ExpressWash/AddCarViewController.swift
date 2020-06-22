//
//  AddCarViewController.swift
//  ExpressWash
//
//  Created by Bobby Keffury on 5/29/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import UIKit
import AVFoundation

class AddCarViewController: UIViewController, UINavigationControllerDelegate,
UIImagePickerControllerDelegate, UITextFieldDelegate {

    // MARK: - Properties

    var carController = CarController()
    var photoController = PhotoController()
    var carImagePicker = UIImagePickerController()
    var user: User?
    var car: Car?

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
    @IBOutlet weak var deleteCarButton: UIButton!

    // MARK: - Views

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
        if car != nil {
            updateViews()
        }
    }

    // MARK: - Methods

    private func setupSubviews() {
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes, for: .normal)

        addCarButton.layer.cornerRadius = 10.0
        addCarButton.isEnabled = true
        carImageView.layer.cornerRadius = 10.0
        deleteCarButton.layer.cornerRadius = 10.0
        deleteCarButton.isEnabled = false
        deleteCarButton.alpha = 0

        licenseTextField.delegate = self
        yearTextField.delegate = self
    }

    private func setupCamera() {

        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            carImagePicker.delegate = self
            carImagePicker.sourceType = .camera
            carImagePicker.allowsEditing = false

            present(carImagePicker, animated: true, completion: nil)
        } else {
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {

                    if UIImagePickerController.isSourceTypeAvailable(.camera) {
                        DispatchQueue.main.async {
                            self.carImagePicker.delegate = self
                            self.carImagePicker.sourceType = .camera
                            self.carImagePicker.allowsEditing = false

                            self.present(self.carImagePicker, animated: true, completion: nil)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.carImagePicker.delegate = self
                            self.carImagePicker.sourceType = .savedPhotosAlbum
                            self.carImagePicker.allowsEditing = false

                            self.present(self.carImagePicker, animated: true, completion: nil)
                        }
                    }
                } else {
                    return
                }
            }
        }
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            carImageView.image = image
        }

        self.dismiss(animated: true, completion: nil)
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
        var maxLength = 7

        if textField == licenseTextField {
            maxLength = 7
        } else if textField == yearTextField {
            maxLength = 4
        }
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }

    private func updateViews() {
        guard let car = car else { return }

        carImageView.image = UIImage.cached(from: car.photo ?? "")
        yearTextField.text = "\(car.year)"
        makeTextField.text = car.make
        modelTextField.text = car.model
        licenseTextField.text = car.licensePlate
        colorTextField.text = car.color
        categoryTextField.text = car.category
        if car.size == "small" {
            sizeSegmentedControl.selectedSegmentIndex = 1
        } else if car.size == "medium" {
            sizeSegmentedControl.selectedSegmentIndex = 2
        } else {
            sizeSegmentedControl.selectedSegmentIndex = 3
        }

        yearTextField.isEnabled = false
        makeTextField.isEnabled = false
        modelTextField.isEnabled = false
        licenseTextField.isEnabled = false
        colorTextField.isEnabled = false
        categoryTextField.isEnabled = false
        sizeSegmentedControl.isEnabled = false
        showCameraTapped.isEnabled = false
        showCameraTapped.alpha = 0
        addCarButton.isEnabled = false
        addCarButton.alpha = 0
        deleteCarButton.isEnabled = true
        deleteCarButton.alpha = 1
    }

    private func fetchCar() -> CarRepresentation? {
        guard let year = yearTextField.text,
              let make = makeTextField.text,
              let model = modelTextField.text,
              let licensePlate = licenseTextField.text,
              let color = colorTextField.text,
              let category = categoryTextField.text,
              carImageView.image != nil else { return nil }

        let segment = sizeSegmentedControl.selectedSegmentIndex
        guard let size = sizeSegmentedControl.titleForSegment(at: segment),
              let yearInt = Int16(year),
              let clientID = UserController.shared.sessionUser.user?.userId else { return nil }

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
            return carRepresentation
    }

    // MARK: - Actions

    @IBAction func addCarButtonTapped(_ sender: Any) {
        guard let carRep = fetchCar() else { return }

        carController.addCar(carRepresentation: carRep) { (car, error) in
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
                                self.tieCar(carRep: carRep, carId: Int(car.carId))
                            }

                            if let carRep = self.carController.decodeCarRep(with: data) {
                                guard let user = UserController.shared.sessionUser.user else { return }
                                let car = self.carController.findOrCreateCarInCoreData(from: carRep)
                                user.addToCars(car)
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"),
                                                                object: nil)

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

    @IBAction func deleteCarButtonTapped(_ sender: Any) {
        guard let car = car else { return }
        carController.deleteCar(car: car, context: CoreDataStack.shared.mainContext)
        self.dismiss(animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        }
    }
}
