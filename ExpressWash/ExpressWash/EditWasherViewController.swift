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
    @IBOutlet weak var btnSave: UIButton!

    // MARK: - Properties
    var washerController: WasherController?

    // MARK: - Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        updateViews()
    }

    func updateViews() {
        guard isViewLoaded else { return }

        guard let washer = UserController.shared.sessionUser.washer,
            let user = washer.user else {
                btnSave.isEnabled = false
                return
        }

        btnSave.isEnabled = true
        lblFullName.text = "\(user.firstName) \(user.lastName)"
        if let profilePicture = user.profilePicture {
            imgProfilePic.image = UIImage.cached(from: profilePicture,
                                                 defaultTitle: "person.circle")
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
        guard let washer = UserController.shared.sessionUser.washer,
            let washerController = washerController else {
            return
        }

        var washerRep = washer.representation
        guard let aboutMe = txtvAboutMe.text else {
            saveAlert(msg: "Please enter an About Me description")
            return
        }
        washerRep.aboutMe = aboutMe

        guard let largeStr = txtRateLarge.text,
            let large = Double(largeStr),
            let mediumStr = txtRateMedium.text,
            let medium = Double(mediumStr),
            let smallStr = txtRateSmall.text,
            let small = Double(smallStr)
        else {
            saveAlert(msg: "Please enter a large, medium, and small car rate. Use only numbers and decimal points.")
            return
        }
        washerRep.rateLarge = large
        washerRep.rateMedium = medium
        washerRep.rateSmall = small

        washerController.put(washerRep: washerRep) { error  in
            if let error = error {
                print("Couldn't update washer details: \(error)")
                self.saveAlert(msg: "An error occurred while updating your details: \(error)")
            } else {
                self.washerController?.updateWasher(washer, with: washerRep)
            }
        }
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    private func saveAlert(msg: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController()
            alert.title = "Error"
            alert.message = msg
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
