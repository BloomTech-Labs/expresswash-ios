//
//  MainViewController.swift
//  ExpressWash
//
//  Created by Bobby Keffury on 4/21/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import UIKit
import Mapbox
import CoreLocation

class ScheduleViewController: UIViewController,
                              MGLMapViewDelegate,
                              UICollectionViewDelegate,
                              UICollectionViewDataSource {

    // MARK: - Properties

    let locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    let annotation = MGLPointAnnotation()
    var washers: [Washer] = []

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
        cell.largeRateLabel.text = "\(washer.rateLarge)"
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

    func autoFillAddress() {
        self.mapView.removeAnnotation(annotation)

        if let address = UserController.shared.sessionUser?.streetAddress {
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

                // Search for available washers
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

            // Search for available washers
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

                // Search for available washers
                self.washersCollectionView.reloadData()
            }
        }
    }

    @IBAction func scheduleWashButtonTapped(_ sender: Any) {
        // Schedule the wash with the given address & washer, then move over to the receipts page for viewing/maintinenc
    }
}
