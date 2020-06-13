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
            // set image of cell with image handler

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
    }

    func setUpMap() {
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.attributionButton.isHidden = true
        mapView.attributionButton.isEnabled = false
        mapView.delegate = self
    }
    
    func getWashers(location: CLLocation) {
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Error reverse geocoding: \(error)")
                return
            }

            guard let placemark = placemarks?.first else { return }

            if let city = placemark.subAdministrativeArea {
                self.jobController.getWashersInCity(city) { (washers, error) in
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

    func mapView(_ mapView: MGLMapView, didAdd annotationViews: [MGLAnnotationView]) {
        mapView.centerCoordinate = annotation.coordinate
        mapView.zoomLevel = 10
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
                return
                // Let the user know there was no location found
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
        // Get selected washer & Move over to the receipts page for viewing/maintinence

        let date = Date()
        let dateFormatter = DateFormatter.Clock
        let timeRequested = dateFormatter.string(from: date)

        let location = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)

        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Error reverse geocoding: \(error)")
                return
            }

            guard let placemark = placemarks?.first else { return }

            if let address = placemark.thoroughfare {
                self.addressString = address
            }

            if let city = placemark.subAdministrativeArea {
                self.cityString = city
            }

            if let state = placemark.administrativeArea {
                self.stateString = state
            }

            if let zip = placemark.isoCountryCode {
                self.zipString = zip
            }
        }

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

            //FIX WASHER ID
            self.jobController.assignWasher(job: job, washerID: 0) { (_, error) in
                if let error = error {
                    print("Error assigning washer to job: \(error)")
                    return
                }
            }
        }
    }
}
