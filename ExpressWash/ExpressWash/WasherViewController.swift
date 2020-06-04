//
//  WasherViewController.swift
//  ExpressWash
//
//  Created by Bobby Keffury on 4/22/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import UIKit
import Mapbox

class WasherViewController: UIViewController, MGLMapViewDelegate {

    // MARK: - Properties
    var washerController = WasherController()
    var washer = UserController.shared.sessionUser?.washer
    var job: Job?
    var locationManager: CLLocationManager?

    // MARK: - Outlets

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var activeSwitch: UISwitch!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: MGLMapView!
    @IBOutlet weak var arrivedCompleteButton: UIButton!
    @IBOutlet weak var arrivedCompleteLabel: UILabel!
    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var jobDescriptionLabel: UILabel!
    @IBOutlet weak var licPlateLabel: UILabel!
    @IBOutlet weak var makeModelLabel: UILabel!
    @IBOutlet weak var colorYearLabel: UILabel!
    @IBOutlet weak var rateLargeLabel: UILabel!
    @IBOutlet weak var rateMediumLabel: UILabel!
    @IBOutlet weak var rateSmallLabel: UILabel!

    // MARK: - Views

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()

        setupSubviews()
        setUpMap()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateViews()
    }

    private func setupSubviews() {
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height/2
    }

    private func setUpMap() {
        let map = MGLMapView(frame: mapView.bounds)
        map.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        map.attributionButton.isHidden = true

        mapView.addSubview(map)
        map.delegate = self
    }

    private func updateViews() {
        guard isViewLoaded else { return }

        jobDescriptionLabel.text = "No job right now"
        carImageView.image = nil
        licPlateLabel.text = nil
        makeModelLabel.text = nil
        colorYearLabel.text = nil

        updateWasherViews()
        updateJobViews()
    }

    private func updateWasherViews() {
        guard let washer = washer,
            let wUser = washer.user
        else {
            fullNameLabel.text = "Do you want to be a washer?"
            let alert = UIAlertController()
            alert.title = "Become a washer"
            alert.message = "Would you like to wash some cars? Visit our website to become a washer! www.expresswash.us"
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.tabBarController?.selectedIndex = 0
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }

        profileImageView.image = UIImage.cached(from: wUser.profilePicture?.absoluteString ?? "",
                                                defaultTitle: "person.circle")
        fullNameLabel.text = "\(wUser.firstName) \(wUser.lastName)"
        ratingLabel.text = "★ \(washer.washerRating)"
        activeSwitch.isOn = washer.workStatus
        activeSwitchToggled(self.activeSwitch!)
        rateLargeLabel.text = "Lg. " + NumberFormatter.dollarString(washer.rateLarge)
        rateMediumLabel.text = "Md. " + NumberFormatter.dollarString(washer.rateMedium)
        rateSmallLabel.text = "Sm. " + NumberFormatter.dollarString(washer.rateSmall)
    }

    private func updateJobViews() {
        guard let job = job,
            let client = job.client,
            let car = job.car
        else { return }

        jobDescriptionLabel.text = "\(DateFormatter.clockString(from: job.timeRequested)): Job for \(client.firstName)"

        licPlateLabel.text = car.licensePlate
        makeModelLabel.text = "\(car.make) \(car.model)"
        colorYearLabel.text = "\(car.color), \(car.year)"
        carImageView.image = UIImage.cached(from: car.photo ?? "", defaultTitle: "Logo")

        switch car.size {
        case "small":
            rateSmallLabel.textColor = #colorLiteral(red: 1, green: 0.4662145972, blue: 0.4056550264, alpha: 1)
            rateMediumLabel.textColor = .lightGray
            rateLargeLabel.textColor = .lightGray
        case "medium":
            rateMediumLabel.textColor = #colorLiteral(red: 1, green: 0.4662145972, blue: 0.4056550264, alpha: 1)
            rateSmallLabel.textColor = .lightGray
            rateLargeLabel.textColor = .lightGray
        case "large":
            rateLargeLabel.textColor = #colorLiteral(red: 1, green: 0.4662145972, blue: 0.4056550264, alpha: 1)
            rateMediumLabel.textColor = .lightGray
            rateSmallLabel.textColor = .lightGray
        default:
            rateSmallLabel.textColor = .lightGray
            rateMediumLabel.textColor = .lightGray
            rateLargeLabel.textColor = .lightGray
        }

        var addressText = "\(job.address)"
        if let address2 = job.address2 {
            addressText += ", \(address2)"
        }
        addressLabel.text = addressText

    }

    // MARK: - Actions

    @IBAction func editButtonTapped(_ sender: Any) {
        // segue to EditWasherViewController
    }

    @IBAction func activeSwitchToggled(_ sender: Any) {
        guard let washer = washer else {
            activeSwitch.isOn = false
            return
        }

        var washerRep = washer.representation
        washerRep.workStatus = activeSwitch.isOn
        if washerRep.workStatus {
            locationManager?.requestLocation()
            if let lat = locationManager?.location?.coordinate.latitude,
                let lon = locationManager?.location?.coordinate.longitude {
                washerRep.currentLocationLat = lat
                washerRep.currentLocationLon = lon
            }
        }

        washerController.put(washerRep: washerRep) { (error) in
            if let error = error {
                print("Couldn't update washer active status: \(error)")
                self.activeSwitch.isOn = washer.workStatus
                let alert = UIAlertController()
                alert.title = "Unable to update"
                alert.message = "An error occurred while updating your active status: \(error)"
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                self.washerController.updateWasher(washer, with: washerRep)
            }
        }
    }

    @IBAction func arrivedCompleteTapped(_ sender: Any) {
        // TODO: Show camera, upload before or after photo of the car
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editWasherSegue" {
            if let editWasherVC = segue.destination as? EditWasherViewController {
                editWasherVC.washerController = washerController
                editWasherVC.washer = washer
            }
        }
    }
}

extension WasherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedAlways || status != .authorizedWhenInUse {
            let alert = UIAlertController()
            alert.title = "Location Services Required"
            var message = "This app requires location services to be enabled for you to act as a washer. "
            message += "You cannot be assigned any jobs until you enable location services."
            alert.message = message
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.locationManager?.requestAlwaysAuthorization()
            }))
            alert.addAction(UIAlertAction(title: "No jobs for me", style: .destructive, handler: { _ in
                self.activeSwitch.isOn = false
                self.activeSwitchToggled(self.activeSwitch!)
            }))
        }
    }
}
