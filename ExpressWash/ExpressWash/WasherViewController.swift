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
    var job: Job?
    var lastKnownLat = kCLLocationCoordinate2DInvalid.latitude
    var lastKnownLon = kCLLocationCoordinate2DInvalid.longitude
    var currentlyRequestedImage: JobImages?

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

        setupSubviews()
        setUpMap()

        if UserController.shared.sessionUser.user != nil &&
           UserController.shared.sessionUser.washer != nil &&
           UserController.shared.sessionUser.washer?.user == nil {
            // if the signed in user isn't linked to its washer in
            // Core Data, link them up
            UserController.shared.sessionUser.user?.washer =
                UserController.shared.sessionUser.washer
        }
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
        updateJobViews()
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
        arrivedCompleteButton.isSelected = job.timeArrived == nil ? false : true
        arrivedCompleteLabel.text = job.timeArrived == nil ? "Arrived?" : "Completed?"
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
                self.activeSwitch.isOn = washer.workStatus
                let alert = UIAlertController()
                alert.title = "Unable to update"
                alert.message = "An error occurred while updating your active status: \(error)"
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                print(washerRep)
                self.washerController.updateWasher(washer, with: washerRep)
            }
        }
    }

    @IBAction func arrivedCompleteTapped(_ sender: Any) {
        guard let job = job else { return }
        let desiredImage = job.timeArrived == nil ? JobImages.before : JobImages.after
        setupCamera(for: desiredImage)
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
                let alert = UIAlertController()
                alert.title = "Unable to update"
                alert.message = "An error occurred while updating your location: \(error)"
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                self.washerController.updateWasher(washer, with: washerRep)
            }
        }
    }
}

extension WasherViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    enum JobImages {
        case before
        case after
    }

    private func setupCamera(for jobImage: JobImages) {
        currentlyRequestedImage = jobImage
        let camera = UIImagePickerController()
        camera.sourceType = .camera
        camera.allowsEditing = true
        camera.delegate = self
        present(camera, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage,
              let job = job
        else {
            print("No image found")
            return
        }

        let endpoint = currentlyRequestedImage == .before ? ImageEndpoint.imagesJobBefore : ImageEndpoint.imagesJobAfter
        PhotoController.shared.uploadPhoto(image,
                                           httpMethod: "POST",
                                           endpoint: endpoint,
                                           theID: Int(job.jobId))
        { data, error in
            if let error = error {
                let alert = UIAlertController()
                alert.title = "Error uploading photo"
                alert.message = "The photo failed to upload, but we're still going to try "
                alert.message! += "to let your client know you've arrived.\n"
                alert.message! += "Error: \(error)"
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }

            var jobRep = job.representation
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    jobRep = try decoder.decode(JobRepresentation.self, from: data)
                } catch {
                    print("A job was returned after photo was uploaded, but there was an error decoding it: \(error)")
                }
            }

            jobRep?.timeArrived = DateFormatter.clockString(from: "\(Date())")
            if let jobRep = jobRep {
                self.jobController.updateJob(jobRepresentation: jobRep) { (job, error) in
                    if let error = error {
                        print("Error trying to update job after uploading photo: \(error)")
                    }

                    if let job = job {
                        self.job = job
                    } else {
                        print("No job was returned. Sticking with the old one.")
                    }
                }
            }
            self.updateViews()
        }
    }
}
