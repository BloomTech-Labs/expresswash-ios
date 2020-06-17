//
//  WasherViewController.swift
//  ExpressWash
//
//  Created by Bobby Keffury on 4/22/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import UIKit
import Mapbox

class WasherViewController: UIViewController {

    // MARK: - Properties
    var washerController = WasherController()
    var jobController = JobController()
    var carController = CarController()
    var job: Job?
    var lastKnownLat = kCLLocationCoordinate2DInvalid.latitude
    var lastKnownLon = kCLLocationCoordinate2DInvalid.longitude

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

        checkUserWasherLink()
        setupSubviews()
        if UserController.shared.sessionUser.washer != nil {
            setUpMap()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateViews()
    }

    private func checkUserWasherLink() {
        if UserController.shared.sessionUser.user != nil &&
           UserController.shared.sessionUser.washer != nil &&
           UserController.shared.sessionUser.washer?.user == nil {
            // if the signed in user isn't linked to its washer in
            // Core Data, link them up
            UserController.shared.sessionUser.user?.washer =
                UserController.shared.sessionUser.washer
        }
    }

    private func setupSubviews() {
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height/2
    }

    private func setUpMap() {
        let map = MGLMapView(frame: mapView.bounds)
        map.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        map.attributionButton.isHidden = true
        map.attributionButton.isEnabled = false

        mapView.addSubview(map)
        map.delegate = self
        map.showsUserLocation = true
        map.setUserTrackingMode(.follow, animated: true, completionHandler: nil)
    }

    private func updateViews() {
        guard isViewLoaded else { return }

        jobDescriptionLabel.text = "No job right now"
        carImageView.image = nil
        licPlateLabel.text = nil
        makeModelLabel.text = nil
        colorYearLabel.text = nil

        updateWasherViews()
        fetchJobs {
            self.updateJobViews()
        }
    }

    private func updateWasherViews() {
        guard let washer = UserController.shared.sessionUser.washer,
            let wUser = UserController.shared.sessionUser.user
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

    private func fetchJobs(completion: @escaping () -> Void) {
        // checks with the server to get the latest list of jobs
        // for this washer and sets the current job, if any, to self.job

        checkUserWasherLink()
        guard let washer = UserController.shared.sessionUser.washer else {
            return
        }

        jobController.getWasherJobs(washer: washer) { (jobReps, error) in
            if let error = error {
                DispatchQueue.main.async {
                    let alert = UIAlertController()
                    alert.title = "Unable to fetch jobs"
                    alert.message = "An error occurred while fetching your current job: \(error)"
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                return
            }

            guard let jobReps = jobReps else { return }
            var selectedJobRep: JobRepresentation?
            for jobRep in jobReps where !jobRep.completed {
                // assign any uncompleted job to the self.job property
                // hopefully there's only one. probably a better way
                // to do this
                self.job = Job(representation: jobRep)
                selectedJobRep = jobRep
            }
            if selectedJobRep != nil {
                // fetch the client for this job
                UserController.shared.fetchUserByID(uid: selectedJobRep!.clientId) { (client, error) in
                    if let error = error {
                        print("Unable to fetch client for job: \(error)")
                    }
                    if let client = client {
                        self.job?.client = client
                    }

                    self.job?.car = self.carController.findCar(by: selectedJobRep!.carId)
                }
            }
            completion()
        }
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
        self.performSegue(withIdentifier: "editWasherSegue", sender: self)
    }

    @IBAction func activeSwitchToggled(_ sender: Any) {
        guard let washer = UserController.shared.sessionUser.washer else {
            activeSwitch.isOn = false
            return
        }

        var washerRep = washer.representation
        washerRep.workStatus = activeSwitch.isOn
        if washerRep.workStatus {
            washerRep.currentLocationLat = lastKnownLat
            washerRep.currentLocationLon = lastKnownLon
        }

        washerController.put(washerRep: washerRep) { (error) in
            if let error = error {
                print("Couldn't update washer active status: \(error)")
                DispatchQueue.main.async {
                    self.activeSwitch.isOn = washer.workStatus
                    let alert = UIAlertController()
                    alert.title = "Unable to update"
                    alert.message = "An error occurred while updating your active status: \(error)"
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                print(washerRep)
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
            }
        }
    }
}

extension WasherViewController: MGLMapViewDelegate {
    func mapView(_ mapView: MGLMapView, didUpdate userLocation: MGLUserLocation?) {
        lastKnownLat = mapView.userLocation!.coordinate.latitude
        lastKnownLon = mapView.userLocation!.coordinate.longitude
        print("location: \(lastKnownLat) x \(lastKnownLon)")

        guard let washer = UserController.shared.sessionUser.washer,
            washer.workStatus == true,
            activeSwitch.isOn
        else {
            return
        }

        var washerRep = washer.representation
        washerRep.currentLocationLat = lastKnownLat
        washerRep.currentLocationLon = lastKnownLon

        washerController.put(washerRep: washerRep) { (error) in
            if let error = error {
                print("Couldn't update washer location: \(error)")
                DispatchQueue.main.async {
                    let alert = UIAlertController()
                    alert.title = "Unable to update"
                    alert.message = "An error occurred while updating your location: \(error)"
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                self.washerController.updateWasher(washer, with: washerRep)
            }
        }
    }
}
