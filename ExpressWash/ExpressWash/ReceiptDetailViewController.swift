//
//  ReceiptDetailViewController.swift
//  ExpressWash
//
//  Created by Bobby Keffury on 6/3/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import UIKit

class ReceiptDetailViewController: UIViewController {

    // MARK: - Properties

    let washerController = WasherController()
    var job: Job?
    var rating: Int?
    var star = UIImage(systemName: "star")
    var starFill = UIImage(systemName: "star.fill")

    // MARK: - Outlets

    @IBOutlet weak var washDateLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cityStateLabel: UILabel!
    @IBOutlet weak var timeTakenLabel: UILabel!
    @IBOutlet weak var beforeImageView: UIImageView!
    @IBOutlet weak var afterImageView: UIImageView!
    @IBOutlet weak var washerProfileImageView: UIImageView!
    @IBOutlet weak var washerNameLabel: UILabel!
    @IBOutlet weak var washerRatingLabel: UILabel!
    @IBOutlet weak var washerAboutMeTextView: UITextView!

    @IBOutlet weak var oneStar: UIButton!
    @IBOutlet weak var twoStar: UIButton!
    @IBOutlet weak var threeStar: UIButton!
    @IBOutlet weak var fourStar: UIButton!
    @IBOutlet weak var fiveStar: UIButton!

    @IBOutlet weak var rateWasherButton: UIButton!

    // MARK: - Views

    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
        rateWasherButton.layer.cornerRadius = 10.0
    }

    // MARK: - Methods

    private func updateViews() {
        guard let job = job else { return }
        guard let washer = job.washer?.user else { return }

        washDateLabel.text = job.creationDate

        addressLabel.text = job.address
        cityStateLabel.text = "\(job.city.capitalized), \(job.state.capitalized)"

        let timeTakenString = DateFormatter.timeTaken(timeArrived: job.timeArrived, timeCompleted: job.timeCompleted)
        timeTakenLabel.text = timeTakenString

        if let beforeString = job.photoBeforeJob {
            beforeImageView.image = UIImage.cached(from: beforeString, defaultTitle: "Logo")
            beforeImageView.layer.cornerRadius = 10.0
        }
        if let afterString = job.photoAfterJob {
            afterImageView.image = UIImage.cached(from: afterString, defaultTitle: "Logo")
            afterImageView.layer.cornerRadius = 10.0
        }
        if let washerPhotoURL = washer.profilePicture {
            washerProfileImageView.image = UIImage.cached(from: washerPhotoURL, defaultTitle: "person.circle")
            washerProfileImageView.layer.cornerRadius = washerProfileImageView.frame.size.height/2
        }
        washerNameLabel.text = "\(washer.firstName.capitalized) \(washer.lastName.capitalized)"
        washerRatingLabel.text = "★ \(job.washer!.washerRating)"
        washerAboutMeTextView.text = """
        About your washer:

        \(job.washer!.aboutMe ?? "")
        """
        washerAboutMeTextView.backgroundColor = .white
    }

    private func oneStarFill() {
        oneStar.setBackgroundImage(starFill, for: .normal)
        twoStar.setBackgroundImage(star, for: .normal)
        threeStar.setBackgroundImage(star, for: .normal)
        fourStar.setBackgroundImage(star, for: .normal)
        fiveStar.setBackgroundImage(star, for: .normal)
        self.rating = 1
    }

    private func twoStarFill() {
        oneStar.setBackgroundImage(starFill, for: .normal)
        twoStar.setBackgroundImage(starFill, for: .normal)
        threeStar.setBackgroundImage(star, for: .normal)
        fourStar.setBackgroundImage(star, for: .normal)
        fiveStar.setBackgroundImage(star, for: .normal)
        self.rating = 2
    }

    private func threeStarFill() {
        oneStar.setBackgroundImage(starFill, for: .normal)
        twoStar.setBackgroundImage(starFill, for: .normal)
        threeStar.setBackgroundImage(starFill, for: .normal)
        fourStar.setBackgroundImage(star, for: .normal)
        fiveStar.setBackgroundImage(star, for: .normal)
        self.rating = 3
    }

    private func fourStarFill() {
        oneStar.setBackgroundImage(starFill, for: .normal)
        twoStar.setBackgroundImage(starFill, for: .normal)
        threeStar.setBackgroundImage(starFill, for: .normal)
        fourStar.setBackgroundImage(starFill, for: .normal)
        fiveStar.setBackgroundImage(star, for: .normal)
        self.rating = 4
    }

    private func fiveStarFill() {
        oneStar.setBackgroundImage(starFill, for: .normal)
        twoStar.setBackgroundImage(starFill, for: .normal)
        threeStar.setBackgroundImage(starFill, for: .normal)
        fourStar.setBackgroundImage(starFill, for: .normal)
        fiveStar.setBackgroundImage(starFill, for: .normal)
        self.rating = 5
    }

    private func ratingNotification() {
        let alertController = UIAlertController(title: "Washer Rated!", message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

    private func disableRating() {
        oneStar.isEnabled = false
        twoStar.isEnabled = false
        threeStar.isEnabled = false
        fourStar.isEnabled = false
        fiveStar.isEnabled = false
        rateWasherButton.isEnabled = false
    }

    // MARK: - Actions

    @IBAction func oneStarTapped(_ sender: Any) {
        oneStarFill()
    }

    @IBAction func twoStarTapped(_ sender: Any) {
        twoStarFill()
    }

    @IBAction func threeStarTapped(_ sender: Any) {
        threeStarFill()
    }

    @IBAction func fourStarTapped(_ sender: Any) {
        fourStarFill()
    }

    @IBAction func fiveStarTapped(_ sender: Any) {
        fiveStarFill()
    }

    @IBAction func rateWasherButtonClicked(_ sender: Any) {
        guard let washer = job!.washer else { return }
        guard let rating = rating else { return }

        washerController.rate(washer: washer, rating: rating) { (error) in
            if let error = error {
                print("Error rating washer: \(error)")
                return
            }

            self.ratingNotification()
            self.disableRating()
        }
    }
}
