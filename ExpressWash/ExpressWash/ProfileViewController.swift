//
//  ProfileViewController.swift
//  ExpressWash
//
//  Created by Bobby Keffury on 4/22/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    // MARK: - Outlets

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailAddressLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cityStateZipLabel: UILabel!
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

        let url = user.profilePicture
        if let data = try? Data(contentsOf: url!) {
            let image: UIImage = UIImage(data: data)!
            profileImageView.image = image
        }

        ratingLabel.text = "★ \(user.userRating)"

        let bannerURL = user.bannerImage
        if let data = try? Data(contentsOf: bannerURL!) {
            let image = UIImage(data: data)
            bannerImageView.image = image
        }

        nameLabel.text = "\(user.firstName.capitalized) \(user.lastName.capitalized)"
        phoneNumberLabel.text = user.phoneNumber
        emailAddressLabel.text = user.email
        addressLabel.text = user.streetAddress
        cityStateZipLabel.text = "\(user.city ?? "city"), \(user.state ?? "state"), \(user.zip ?? "zip")"
    }

    // MARK: - Actions

    @IBAction func editButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "editProfileSegue", sender: self)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editProfileSegue" {
            if let editProfileVC = segue.destination as? EditProfileViewController {
                guard let user = UserController.shared.sessionUser else { return }
                editProfileVC.user = user
            }
        }
    }
}
