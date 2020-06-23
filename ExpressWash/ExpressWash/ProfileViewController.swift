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
        return user.carsArray
    }
    var car: Car?

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        carsCollectionView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
        updateViews()
        carsCollectionView.delegate = self
        carsCollectionView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(loadList),
                                               name: NSNotification.Name(rawValue: "load"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(editEnabled),
                                               name: NSNotification.Name(rawValue: "addCar"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadCars),
                                                      name: NSNotification.Name(rawValue: "loadCars"), object: nil)
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

        cell.modelLabel.text = car.model

        cell.layer.cornerRadius = 10.0

        cell.addButtonTapAction = {
            self.car = car
            self.performSegue(withIdentifier: "carDetailSegue", sender: self)
        }

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

    @objc func loadList(notification: NSNotification) {
        DispatchQueue.main.async {
            self.carsCollectionView.reloadData()
        }
    }

    @objc func loadCars(notification: NSNotification) {
        DispatchQueue.main.async {
            self.carsCollectionView.reloadData()
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
        } else if segue.identifier == "carDetailSegue" {
            if let detailVC = segue.destination as? AddCarViewController,
                let car = car {
                detailVC.car = car
            }
        }
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 75.0, height: 75.0)
    }
}
