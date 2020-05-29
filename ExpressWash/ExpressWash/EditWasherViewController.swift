//
//  EditWasherViewController.swift
//  ExpressWash
//
//  Created by Joel Groomer on 5/21/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import UIKit

class EditWasherViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var txtvAboutMe: UITextView!
    @IBOutlet weak var txtRateLarge: UITextField!
    @IBOutlet weak var txtRateMedium: UITextField!
    @IBOutlet weak var txtRateSmall: UITextField!

    // MARK: - Properties
    var washer: Washer? { didSet { updateViews() } }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }

    func updateViews() {
        guard isViewLoaded else { return }

        guard let washer = washer,
            let user = washer.user else { return }

        lblFullName.text = "\(user.firstName) \(user.lastName)"
        if let profilePicture = user.profilePicture {
            if let data = try? Data(contentsOf: profilePicture) {
                imgProfilePic.image = UIImage(data: data)
            }
        }

        if let aboutMe = washer.aboutMe {
            txtvAboutMe.text = aboutMe
        }

        txtRateLarge.text = "\(washer.rateLarge)"
        txtRateMedium.text = "\(washer.rateMedium)"
        txtRateSmall.text = "\(washer.rateSmall)"
    }

    // MARK: - Actions

    @IBAction func saveTapped(_ sender: Any) {
    }

    @IBAction func cancelTapped(_ sender: Any) {
    }

}
