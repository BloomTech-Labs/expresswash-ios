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
                             UICollectionViewDelegate, UICollectionViewDataSource,
                             UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    // MARK: - Properties

    let photoController = PhotoController()
    var profileImagePicker = UIImagePickerController()
    var bannerImagePicker = UIImagePickerController()
    var cars: [Car] {
        guard let user = UserController.shared.sessionUser.user else { return [] }
        guard let cars = user.cars else { return [] }
        return cars.sorted(by: { (carOne, carTwo) -> Bool in
            carOne.carId > carTwo.carId
        })
    }

    // MARK: - Outlets

    @IBOutlet var profileTapGesture: UITapGestureRecognizer!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var bannerImageButton: UIButton!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        carsCollectionView.reloadData()
    }

    // MARK: - CollectionView Data Source

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cars.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "carCell", for: indexPath)
            as? CarCollectionViewCell else { return UICollectionViewCell() }

        let car = cars[indexPath.row]

        if let photoString = car.photo {
            cell.imageView.image = UIImage.cached(from: photoString, defaultTitle: nil)
        }

        cell.layer.cornerRadius = 10.0

        return cell
    }

    // MARK: - Methods

    func setupSubviews() {
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height/2
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.borderWidth = 3.0

        editButton.layer.cornerRadius = 5.0
        bannerImageButton.layer.cornerRadius = 5.0
    }

    func updateViews() {
        guard let user = UserController.shared.sessionUser.user else { return }

        if let url = user.profilePicture {
            if let data = try? Data(contentsOf: url) {
                let image: UIImage = UIImage(data: data)!
                profileImageView.image = image
            }
        } else {
            profileImageView.image = UIImage(systemName: "person.circle")
        }

        ratingLabel.text = "★ \(user.userRating)"

        if let bannerURL = user.bannerImage {
            if let data = try? Data(contentsOf: bannerURL) {
                let image: UIImage = UIImage(data: data)!
                bannerImageView.image = image
            }
        }

        firstNameTextField.text = user.firstName.capitalized
        lastNameTextField.text = user.lastName.capitalized

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

        cityTextField.text = user.city
        stateTextField.text = user.state

        editDisabled()
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if picker == profileImagePicker {
                profileImageView.image = image
            } else {
                bannerImageView.image = image
            }
        }

        self.dismiss(animated: true, completion: nil)
    }

    func uploadProfilePhoto(photo: UIImage, url: URL?, user: User, endpoint: ImageEndpoint) {
        if user.profilePicture == nil {
            print("POST")
            photoController.uploadPhoto(photo,
                                        httpMethod: "POST", endpoint: endpoint,
                                        theID: Int(user.userId)) { (_, error) in
                if let error = error {
                    print("Error updloading profile photo: \(error)")
                    return
                }
            }
        } else {
            print("PUT")
            photoController.uploadPhoto(photo,
                                        httpMethod: "PUT", endpoint: endpoint,
                                        theID: Int(user.userId)) { (_, error) in
                if let error = error {
                    print("Error updloading profile photo: \(error)")
                    return
                }
            }
        }
    }

    func uploadBannerPhoto(photo: UIImage, url: URL?, user: User, endpoint: ImageEndpoint) {
        if user.bannerImage == nil {
            print("POST")
            photoController.uploadPhoto(photo,
                                        httpMethod: "POST", endpoint: endpoint,
                                        theID: Int(user.userId)) { (_, error) in
                if let error = error {
                    print("Error updloading profile photo: \(error)")
                    return
                }
            }
        } else {
            print("PUT")
            photoController.uploadPhoto(photo,
                                        httpMethod: "PUT", endpoint: endpoint,
                                        theID: Int(user.userId)) { (_, error) in
                if let error = error {
                    print("Error updloading profile photo: \(error)")
                    return
                }
            }
        }
    }

    // MARK: - Actions

    @IBAction func editButtonTapped(_ sender: Any) {
        guard let user = UserController.shared.sessionUser.user else { return }

        if !editButton.isSelected {
            editEnabled()
        } else {
            // Fix Stripe
            guard let firstName = firstNameTextField.text, let lastName = lastNameTextField.text,
                  let phoneNumber = phoneNumberTextField.text, let emailAddress = emailAddressTextField.text,
                  let address = addressTextField.text, let city = cityTextField.text,
                  let state = stateTextField.text else { return }

            if let profilePhoto = profileImageView.image {
                uploadProfilePhoto(photo: profilePhoto, url: user.profilePicture, user: user, endpoint: .imagesProfile)
            }

            if let bannerPhoto = bannerImageView.image {
                uploadBannerPhoto(photo: bannerPhoto, url: user.bannerImage, user: user, endpoint: .imagesBanner)
            }

            guard let userRep = UserController.shared.findUser(byID: Int(user.userId)) else { return }

            let userRepresentation = UserRepresentation(userId: Int(user.userId),
                                                        accountType: user.accountType, email: emailAddress,
                                                        firstName: firstName, lastName: lastName,
                                                        bannerImage: userRep.bannerImage,
                                                        phoneNumber: phoneNumber,
                                                        profilePicture: userRep.profilePicture,
                                                        stripeUUID: user.stripeUUID,
                                                        streetAddress: address,
                                                        streetAddress2: nil,
                                                        city: city, state: state, zip: nil,
                                                        userRating: user.userRating,
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
                    DispatchQueue.main.async {
                        self.profileImagePicker.delegate = self
                        self.profileImagePicker.sourceType = .savedPhotosAlbum
                        self.profileImagePicker.allowsEditing = false

                        self.present(self.profileImagePicker, animated: true, completion: nil)
                    }
                } else {
                    return
                }
            })
        }
    }

    @IBAction func addCarsButtonTapped(_ sender: Any) {
        editDisabled()
        self.performSegue(withIdentifier: "addCarSegue", sender: self)
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

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addCarSegue" {
            if let addCarVC = segue.destination as? AddCarViewController {
                addCarVC.user = UserController.shared.sessionUser.user
            }
        }
    }
}

extension ProfileViewController {

    func editEnabled() {
        editButton.setImage(UIImage(systemName: "square.and.arrow.down"), for: .normal)
        editButton.isSelected = true

        if !profileTapGesture.isEnabled {
            if profileImageView.image == UIImage(systemName: "person.circle") {
                profileImageView.image = UIImage(systemName: "plus.circle")
            }
        }

        if firstNameTextField.text == "First" {
            firstNameTextField.text = nil
        }
        if lastNameTextField.text == "Last" {
            lastNameTextField.text = nil
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
        if cityTextField.text == "City" {
            cityTextField.text = nil
        }
        if stateTextField.text == "State" {
            stateTextField.text = nil
        }
        bannerImageButton.alpha = 1
        bannerImageButton.isEnabled = true
        profileTapGesture.isEnabled = true
        firstNameTextField.isEnabled = true
        lastNameTextField.isEnabled = true
        phoneNumberTextField.isEnabled = true
        emailAddressTextField.isEnabled = true
        addressTextField.isEnabled = true
        cityTextField.isEnabled = true
        stateTextField.isEnabled = true
        carsCollectionView.alpha = 0
        addCarsButton.alpha = 1
        addCarsButton.isEnabled = true
    }

    func editDisabled() {
       editButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        editButton.isSelected = false

        if profileTapGesture.isEnabled {
            if profileImageView.image == UIImage(systemName: "plus.circle") {
                profileImageView.image = UIImage(systemName: "person.circle")
            }
        }
        if firstNameTextField.text == "" {
            firstNameTextField.text = "First"
        }
        if lastNameTextField.text == "" {
            lastNameTextField.text = "Last"
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
        if cityTextField.text == "" {
            cityTextField.text = "City"
        }
        if stateTextField.text == "" {
            stateTextField.text = "State"
        }
        bannerImageButton.alpha = 0
        bannerImageButton.isEnabled = false
        profileTapGesture.isEnabled = false
        firstNameTextField.isEnabled = false
        lastNameTextField.isEnabled = false
        phoneNumberTextField.isEnabled = false
        emailAddressTextField.isEnabled = false
        addressTextField.isEnabled = false
        cityTextField.isEnabled = false
        stateTextField.isEnabled = false
        addCarsButton.alpha = 0
        addCarsButton.isEnabled = false
        carsCollectionView.alpha = 1
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 75.0, height: 75.0)
    }
}
