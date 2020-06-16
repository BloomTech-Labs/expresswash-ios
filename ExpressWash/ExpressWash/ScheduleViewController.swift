//
//  MainViewController.swift
//  ExpressWash
//
//  Created by Bobby Keffury on 4/21/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import UIKit
import Mapbox

class ScheduleViewController: UIViewController,
                              MGLMapViewDelegate,
                              UICollectionViewDelegate,
                              UICollectionViewDataSource {

    // MARK: - Properties

    let jobController = JobController()
    let washerController = WasherController()
    let locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    var annotation = MGLPointAnnotation()
    var washers: [Washer] = []

    var addressString: String?
    var cityString: String?
    var stateString: String?
    var zipString: String?

    // MARK: - Outlets

    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var mapView: MGLMapView!
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var washersCollectionView: UICollectionView!
    @IBOutlet weak var scheduleWashButton: UIButton!

    // MARK: - Views

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
        setUpMap()
        autoFillAddress()
    }

    // MARK: - CollectionView

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return washers.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "washerCell",
                                                            for: indexPath) as? WasherCollectionViewCell else {
                                                                return UICollectionViewCell() }

        let washer = washers[indexPath.row]
        if let user = washer.user {
            if let url = user.profilePicture {
                cell.imageView.image = UIImage.cached(from: url, defaultTitle: "person.circle")
            } else {
                cell.imageView.image = UIImage(named: "person.circle")
            }

            cell.nameLabel.text = user.firstName + user.lastName
        }

        cell.starLabel.text = "★ \(washer.washerRating)"
        cell.largeRateLabel.text = "$\(washer.rateLarge)"
        cell.mediumRateLabel.text = "\(washer.rateMedium)"
        cell.smallRateLabel.text = "\(washer.rateSmall)"

        return cell
    }

    // MARK: - Methods

    func setupSubviews() {
        scheduleWashButton.layer.cornerRadius = 10.0

        washersCollectionView.allowsMultipleSelection = false

        addressTextField.text = ""
    }

    func setUpMap() {
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.attributionButton.isHidden = true
        mapView.attributionButton.isEnabled = false
        mapView.delegate = self
        mapView.layer.cornerRadius = 8.0
    }

    func getWashers(location: CLLocation) {
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Error reverse geocoding: \(error)")
                return
            }

            guard let placemark = placemarks?.first else { return }

            if let city = placemark.subAdministrativeArea {
                self.washerController.getWashersInCity(city) { (washers, error) in
                    if let error = error {
                        print("Error gettig washers in city: \(error)")
                        return
                    }
                    self.washers = []

                    if let washers = washers {
                        self.washers = washers
                    }
                }
            }
        }
    }

    func alertUser(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

    func alertUserWithTransition(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertController, animated: true) {
            self.tabBarController?.selectedIndex = 3
        }
    }

    func autoFillAddress() {
        self.mapView.removeAnnotation(annotation)

        if let address = UserController.shared.sessionUser.user?.streetAddress {
            addressTextField.text = address

            geoCoder.geocodeAddressString(address) { (placemarks, error) in
                if let error = error {
                    print("Error geocoding address: \(error)")
                    return
                }

                guard let placemarks = placemarks, let location = placemarks.first?.location else {
                    print("No location found")
                    return
                }

                self.annotation.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                               longitude: location.coordinate.longitude)
                self.mapView.addAnnotation(self.annotation)

                self.getWashers(location: location)

                self.washersCollectionView.reloadData()
            }
        }
    }

    func reversGeocode(location: CLLocation) {
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Error reverse geocoding: \(error)")
                return
            }

            guard let placemark = placemarks?.first else { return }

            self.addressString = nil
            if let address = placemark.thoroughfare {
                self.addressString = address
            }

            self.cityString = nil
            if let city = placemark.subAdministrativeArea {
                self.cityString = city
            }

            self.stateString = nil
            if let state = placemark.administrativeArea {
                self.stateString = state
            }

            self.zipString = nil
            if let zip = placemark.isoCountryCode {
                self.zipString = zip
            }
        }
    }

    func mapView(_ mapView: MGLMapView, didAdd annotationViews: [MGLAnnotationView]) {
        mapView.centerCoordinate = annotation.coordinate
        mapView.zoomLevel = 13
    }

    // MARK: - Actions

    @IBAction func searchButtonTapped(_ sender: Any) {
        self.mapView.removeAnnotation(annotation)

        guard let address = addressTextField.text else { return }

        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            if let error = error {
                print("Error geocoding address: \(error)")
                return
            }

            guard let placemarks = placemarks, let location = placemarks.first?.location else {
                print("No location found")
                self.alertUser(title: "Location Not Found", message: "Please try again")
                return
            }

            self.annotation.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                           longitude: location.coordinate.longitude)
            self.mapView.addAnnotation(self.annotation)

            self.getWashers(location: location)

            self.washersCollectionView.reloadData()
        }
    }

    @IBAction func currentLocationButtonTapped(_ sender: Any) {

        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
        CLLocationManager.authorizationStatus() == .authorizedAlways {
            if let currentLocation = locationManager.location {
                self.mapView.removeAnnotation(self.annotation)

                self.annotation.coordinate = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude,
                                                                    longitude: currentLocation.coordinate.longitude)
                self.mapView.addAnnotation(self.annotation)

                self.getWashers(location: currentLocation)

                self.washersCollectionView.reloadData()
            }
        }
    }

    @IBAction func scheduleWashButtonTapped(_ sender: Any) {

        let date = Date()
        let timeRequested = DateFormatter.Clock.string(from: date)

        let location = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)

        reversGeocode(location: location)

        guard let address = addressString,
            let city = cityString,
            let state = stateString,
            let zip = zipString else { return }

        let jobRep = JobRepresentation(jobLocationLat: location.coordinate.latitude,
                                       jobLocationLon: location.coordinate.latitude,
                                       address: address,
                                       address2: nil,
                                       city: city,
                                       state: state,
                                       zip: zip,
                                       notes: nil,
                                       jobType: "basic",
                                       timeRequested: timeRequested,
                                       // ROBERT: UPDATE THE NEXT THREE VALUES -Joel
                                       carId: 0,
                                       clientId: Int(UserController.shared.sessionUser.user!.userId),
                                       washerId: 0)

        jobController.addJob(jobRepresentation: jobRep) { (job, error) in
            if let error = error {
                print("Error adding job: \(error)")
                return
            }

            guard let job = job else { return }

            if let indexPaths = self.washersCollectionView.indexPathsForSelectedItems {
                if let indexPath = indexPaths.first {
                    let washer = self.washers[indexPath.row]

                    self.jobController.assignWasher(job: job, washerID: Int(washer.washerId)) { (job, error) in
                        if let error = error {
                            print("Error assigning washer to job: \(error)")
                            return
                        }

                        if job != nil {
                            self.alertUserWithTransition(title: "Job Scheduled!", message: "")
                        }
                    }
                }
            } else {
                self.alertUser(title: "Please Select A Washer", message: "")
            }
        }
    }
}
