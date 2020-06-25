//
//  WasherViewController.swift
//  ExpressWash
//
//  Created by Bobby Keffury on 4/22/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import UIKit
import Mapbox
import AVFoundation

class WasherViewController: UIViewController {

    // MARK: - Properties
    var washerController = WasherController()
    var jobController = JobController()
    var carController = CarController()
    var job: Job?
    var lastKnownLat = kCLLocationCoordinate2DInvalid.latitude
    var lastKnownLon = kCLLocationCoordinate2DInvalid.longitude
    var imagePicker = UIImagePickerController()
    var annotation: MGLPointAnnotation?
    var jobStarted: Bool {
        guard let job = job else { return false }
        if job.timeArrived == nil {
            return false
        } else {
            return true
        }
    }
    var jobFinished: Bool {
        guard let job = job else { return false }
        if job.timeCompleted == nil {
            return false
        } else {
            return true
        }
    }

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

        UserController.shared.checkUserWasherLink()
        setupSubviews()
        if UserController.shared.sessionUser.washer != nil {
            setUpMap()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateViews()
    }

    private func setupSubviews() {
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height/2
        arrivedCompleteLabel.layer.cornerRadius = 10.0
        arrivedCompleteLabel.layer.masksToBounds = true
        arrivedCompleteButton.layer.cornerRadius = 10.0
        carImageView.layer.cornerRadius = 10.0
        addressLabel.layer.cornerRadius = 10.0
        addressLabel.layer.masksToBounds = true
        mapView.attributionButton.isHidden = true
        mapView.attributionButton.isEnabled = false
    }

    private func setUpMap() {
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true, completionHandler: nil)
    }

    func updateViews() {
        guard isViewLoaded else { return }

        jobDescriptionLabel.text = "No job right now"
        carImageView.image = nil
        licPlateLabel.text = nil
        makeModelLabel.text = nil
        colorYearLabel.text = nil

        updateWasherViews()
        fetchJobs {
            DispatchQueue.main.async {
                self.updateJobViews()
                self.addAnnotation()
            }
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

        UserController.shared.checkUserWasherLink()
        guard let washer = UserController.shared.sessionUser.washer else {
            return
        }

        job = nil

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
                selectedJobRep = jobRep
            }
            if selectedJobRep != nil {
                self.job = self.jobController.findOrCreateJobInCoreData(from: selectedJobRep!)
                // fetch the client for this job
                UserController.shared.fetchUserByID(uid: selectedJobRep!.clientId) { (client, error) in
                    if let error = error {
                        print("Unable to fetch client for job: \(error)")
                    }
                    if let client = client {
                        self.job?.client = client
                    }

                    self.job?.car = self.carController.findCar(by: selectedJobRep!.carId)
                    completion()
                }
            } else {
                completion()
            }
        }
    }

    private func updateJobViews() {
        addressLabel.isHidden = true
        arrivedCompleteLabel.isHidden = true
        arrivedCompleteButton.isHidden = true

        guard let job = job,
            !jobFinished,
            let client = job.client,
            let car = job.car
        else { return }

        jobDescriptionLabel.text = "\(job.timeRequested): Job for \(client.firstName)"

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

        if jobStarted {
            arrivedCompleteLabel.text = "Completed?"
            arrivedCompleteButton.isSelected = true
        } else {
            arrivedCompleteLabel.text = "Arrived?"
            arrivedCompleteButton.isSelected = false
        }

        addressLabel.isHidden = false
        arrivedCompleteLabel.isHidden = false
        arrivedCompleteButton.isHidden = false
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
        // Displays the camera (or saved photos for simulator) to allow the Washer
        // to take a before or after photo of the car they are washing for this
        // job. When the photo is taken, imagePickerController(_:didFinishPickingMediaWithInfo:) is called

        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false

            present(imagePicker, animated: true, completion: nil)
        } else {
            DispatchQueue.main.async {
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        self.imagePicker.delegate = self
                        // try to access the camera
                        if UIImagePickerController.isSourceTypeAvailable(.camera) {
                            self.imagePicker.sourceType = .camera
                        } else {
                            // if camera not available (simulator) access saved photos
                            self.imagePicker.sourceType = .savedPhotosAlbum
                        }
                        self.imagePicker.allowsEditing = false

                        self.present(self.imagePicker, animated: true, completion: nil)
                    } else {
                        return
                    }
                }
            }
        }
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
