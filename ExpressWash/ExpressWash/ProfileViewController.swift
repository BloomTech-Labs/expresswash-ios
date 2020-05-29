//
//  ProfileViewController.swift
//  ExpressWash
//
//  Created by Bobby Keffury on 4/22/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import UIKit
import AVFoundation

class ProfileViewController: UIViewController,
                             UICollectionViewDelegate,
                             UICollectionViewDataSource,
                             UIImagePickerControllerDelegate &
                             UINavigationControllerDelegate {

    // MARK: - Properties

    var profileImagePicker = UIImagePickerController()
    var bannerImagePicker = UIImagePickerController()

    // MARK: - Outlets

    @IBOutlet var profileTapGesture: UITapGestureRecognizer!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var bannerImageButton: UIButton!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var cityStateZipTextField: UITextField!
    @IBOutlet weak var addCarsButton: UIButton!
    @IBOutlet weak var carsCollectionView: UICollectionView!

    // MARK: - Views

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
        updateViews()
        carsCollectionView.delegate = self
        carsCollectionView.dataSource = self
    }

    // MARK: - CollectionView Data Source

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let user = UserController.shared.sessionUser, let cars = user.cars else { return 0 }

        return cars.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "carCell", for: indexPath)
            as? CarCollectionViewCell,
            let user = UserController.shared.sessionUser,
            let cars = user.cars else { return UICollectionViewCell() }

        if let car = cars[indexPath.row] as? Car {
            if let photo = car.photo {
                cell.imageView.image = UIImage(contentsOfFile: photo)
            }
        }

        cell.layer.cornerRadius = 10.0

        return cell
    }

    // MARK: - Methods

    func setupSubviews() {
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height/2
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.borderWidth = 3.0
    }

    func updateViews() {
        guard let user = UserController.shared.sessionUser else { return }

        if let url = user.profilePicture {
            if let data = try? Data(contentsOf: url) {
                       let image: UIImage = UIImage(data: data)!
                       profileImageView.image = image
                   }
        }

        ratingLabel.text = "★ \(user.userRating)"

        if let bannerURL = user.bannerImage {
            if let data = try? Data(contentsOf: bannerURL) {
                let image = UIImage(data: data)
                bannerImageView.image = image
            }
        }

        fullNameTextField.text = "\(user.firstName.capitalized) \(user.lastName.capitalized)"

        if user.phoneNumber == nil {
            phoneNumberTextField.text = "Phone Number"
        } else {
            phoneNumberTextField.text = user.phoneNumber
        }

        emailAddressTextField.text = user.email

        if user.streetAddress == nil {
            addressTextField.text = "Address"
        } else {
            addressTextField.text = user.streetAddress
        }

        cityStateZipTextField.text = "\(user.city ?? "city"), \(user.state ?? "state"), \(user.zip ?? "zip")"
    }

    func editEnabled() {
        editButton.setBackgroundImage(UIImage(systemName: "square.and.arrow.down"), for: .normal)
        editButton.isSelected = true

        if profileImageView.image == UIImage(systemName: "person.circle") {
            profileImageView.image = UIImage(systemName: "plus.app")
        }

        if fullNameTextField.text == "Full Name" {
            fullNameTextField.text = nil
        }

        if phoneNumberTextField.text == "Phone Number" {
            phoneNumberTextField.text = nil
        }

        if emailAddressTextField.text == "Email Address" {
            emailAddressTextField.text = nil
        }

        if addressTextField.text == "Address" {
            addressTextField.text = nil
        }

        if cityStateZipTextField.text == "city, state, zip" {
            cityStateZipTextField.text = nil
        }

        bannerImageButton.alpha = 1
        bannerImageButton.isEnabled = true
        profileTapGesture.isEnabled = true
        fullNameTextField.isEnabled = true
        phoneNumberTextField.isEnabled = true
        emailAddressTextField.isEnabled = true
        addressTextField.isEnabled = true
        cityStateZipTextField.isEnabled = true
        carsCollectionView.alpha = 0
        addCarsButton.alpha = 1
        addCarsButton.isEnabled = true
    }

    func editDisabled() {
        editButton.setBackgroundImage(UIImage(systemName: "pencil"), for: .normal)
        editButton.isSelected = false

        if fullNameTextField.text == "" {
            fullNameTextField.text = "Full Name"
        }

        if phoneNumberTextField.text == "" {
            phoneNumberTextField.text = "Phone Number"
        }

        if emailAddressTextField.text == "" {
            emailAddressTextField.text = "Email Address"
        }

        if addressTextField.text == "" {
            addressTextField.text = "Address"
        }

        if cityStateZipTextField.text == "" {
            cityStateZipTextField.text = "city, state, zip"
        }

        bannerImageButton.alpha = 0
        bannerImageButton.isEnabled = false
        profileTapGesture.isEnabled = false
        fullNameTextField.isEnabled = false
        phoneNumberTextField.isEnabled = false
        emailAddressTextField.isEnabled = false
        addressTextField.isEnabled = false
        cityStateZipTextField.isEnabled = false
        addCarsButton.alpha = 0
        addCarsButton.isEnabled = false
        carsCollectionView.alpha = 1
    }

    func imagePickerController(picker: UIImagePickerController!,
                               didFinishPickingImage image: UIImage!,
                               editingInfo: NSDictionary!) {

        self.dismiss(animated: true, completion: nil)

        if picker == profileImagePicker {
            profileImageView.image = image
        } else {
            bannerImageView.image = image
        }
    }

    // MARK: - Actions

    @IBAction func editButtonTapped(_ sender: Any) {
        guard let user = UserController.shared.sessionUser else { return }

        if !editButton.isSelected {
            editEnabled()
        } else {
            // FIX FIRSTNAME, LASTNAME, CITY, STATE, ZIP, PHOTOS, & STRIPE
            guard let firstName = fullNameTextField.text else { return }
            guard let lastName = fullNameTextField.text else { return }
            guard let phoneNumber = phoneNumberTextField.text else { return }
            guard let emailAddress = emailAddressTextField.text else { return }
            guard let address = addressTextField.text else { return }
            guard let city = cityStateZipTextField.text else { return }
            guard let state = cityStateZipTextField.text else { return }
            guard let zip = cityStateZipTextField.text else { return }

            let userRepresentation = UserRepresentation(userId: Int(user.userId),
                                                        accountType: user.accountType,
                                                        email: emailAddress,
                                                        firstName: firstName,
                                                        lastName: lastName,
                                                        bannerImage: user.bannerImage,
                                                        phoneNumber: phoneNumber,
                                                        profilePicture: user.profilePicture,
                                                        stripeUUID: user.stripeUUID,
                                                        streetAddress: address,
                                                        streetAddress2: nil,
                                                        city: city,
                                                        state: state,
                                                        zip: zip,
                                                        userRating: Int(user.userRating),
                                                        userRatingTotal: Int(user.userRatingTotal))

            UserController.shared.updateUser(user, with: userRepresentation)
            editDisabled()
        }
    }

    @IBAction func profileImageTapped(_ sender: Any) {

        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            profileImagePicker.delegate = self
            profileImagePicker.sourceType = .savedPhotosAlbum
            profileImagePicker.allowsEditing = false

            present(profileImagePicker, animated: true, completion: nil)
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    self.profileImagePicker.delegate = self
                    self.profileImagePicker.sourceType = .savedPhotosAlbum
                    self.profileImagePicker.allowsEditing = false

                    self.present(self.profileImagePicker, animated: true, completion: nil)
                } else {
                    return
                }
            })
        }
    }

    @IBAction func addCarsButtonTapped(_ sender: Any) {
        // Present the addCarsVC
    }

    @IBAction func addBannerImageButtonTapped(_ sender: Any) {

        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            bannerImagePicker.delegate = self
            bannerImagePicker.sourceType = .savedPhotosAlbum
            bannerImagePicker.allowsEditing = false

            present(bannerImagePicker, animated: true, completion: nil)
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    DispatchQueue.main.async {
                        self.bannerImagePicker.delegate = self
                        self.bannerImagePicker.sourceType = .savedPhotosAlbum
                        self.bannerImagePicker.allowsEditing = false

                        self.present(self.bannerImagePicker, animated: true, completion: nil)
                    }
                } else {
                    return
                }
            })
        }
    }
}
