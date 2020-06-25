//
//  MainViewController.swift
//  ExpressWash
//
//  Created by Bobby Keffury on 4/21/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import UIKit
import Mapbox
import Stripe

class ScheduleViewController: UIViewController,
                              MGLMapViewDelegate,
                              UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,
                              UICollectionViewDataSource {

    // MARK: - Properties

    let jobController = JobController()
    let washerController = WasherController()
    let locationManager = CLLocationManager()
    var annotation = MGLPointAnnotation()
    var washers: [Washer] = []

    var addressString: String?
    var cityString: String?
    var stateString: String?
    var zipString: String?
    var timeRequested: String?
    var selectedWasher: Washer?
    var selectedIndexPath: IndexPath?

    // MARK: - Outlets

    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var mapView: MGLMapView!
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var washersCollectionView: UICollectionView!
    @IBOutlet weak var scheduleWashButton: UIButton!
    @IBOutlet weak var emptyWashersView: UIView!

    // MARK: - Views

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        setupSubviews()
        setUpMap()
        autoFillAddress()
        washersCollectionView.delegate = self
        washersCollectionView.dataSource = self
    }

    // MARK: - CollectionView

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if washers.count == 0 {
            emptyWashersView.alpha = 1
            return washers.count
        } else {
            emptyWashersView.alpha = 0
            return washers.count
        }
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
                cell.imageView.image = UIImage(systemName: "person.circle")
            }
            cell.nameLabel.text = "\(user.firstName.capitalized)  \(user.lastName.capitalized)"
        }

        if self.selectedIndexPath != nil && indexPath == self.selectedIndexPath {
            cell.layer.borderColor = UIColor(named: "Salmon")?.cgColor
        } else {
            cell.layer.borderColor = UIColor(named: "Light Blue")?.cgColor
        }

        cell.starLabel.text = "★ \(washer.washerRating)"
        cell.largeRateLabel.text = "$\(washer.rateLarge)"
        cell.mediumRateLabel.text = "\(washer.rateMedium)"
        cell.smallRateLabel.text = "\(washer.rateSmall)"

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 2.0
        cell?.layer.borderColor = UIColor(named: "Salmon")?.cgColor
        self.selectedIndexPath = indexPath
        self.selectedWasher = nil
        self.selectedWasher = washers[indexPath.row]
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 2.0
        cell?.layer.borderColor = UIColor(named: "Light Blue")?.cgColor
        self.selectedIndexPath = nil
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 190, height: 155)
    }

    // MARK: - Methods

    func setupSubviews() {
        scheduleWashButton.layer.cornerRadius = 10.0

        washersCollectionView.allowsMultipleSelection = false

        addressTextField.text = ""
        selectedWasher = nil
    }

    func setUpMap() {
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.attributionButton.isHidden = true
        mapView.attributionButton.isEnabled = false
        mapView.delegate = self
        mapView.layer.cornerRadius = 8.0
    }

    func getWashers(location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
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
                        self.washers = washers.sorted(by: { (washer1, washer2) -> Bool in
                            washer1.washerRating > washer2.washerRating
                        })
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                            self.washersCollectionView.reloadData()
                        })
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

    func autoFillAddress() {
        self.mapView.removeAnnotation(annotation)
        guard let user = UserController.shared.sessionUser.user,
            let address = user.streetAddress,
            let city = user.city,
            let state = user.state else { return }

        let addressString = "\(address), \(city.capitalized), \(state.uppercased())"

        addressTextField.text = addressString

        CLGeocoder().geocodeAddressString(addressString) { (placemarks, error) in
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

    func reversGeocode(location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
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
        })
    }

    func mapView(_ mapView: MGLMapView, didAdd annotationViews: [MGLAnnotationView]) {
        mapView.centerCoordinate = annotation.coordinate
        mapView.zoomLevel = 13
    }

    // MARK: - Actions

    @IBAction func searchButtonTapped(_ sender: Any) {
        self.mapView.removeAnnotation(annotation)

        guard let address = addressTextField.text else { return }

        CLGeocoder().geocodeAddressString(address) { (placemarks, error) in
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

                self.addressTextField.text = "Current Location"

                self.washersCollectionView.reloadData()
            }
        }
    }

    @IBAction func scheduleWashButtonTapped(_ sender: Any) {

        let date = Date()
        self.timeRequested = DateFormatter.Clock.string(from: date)

        let location = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)

        reversGeocode(location: location)

        guard self.selectedWasher != nil else {
            self.alertUser(title: "Please Select Washer", message: "")
            return }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.performSegue(withIdentifier: "confirmWashSegue", sender: self)
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "confirmWashSegue" {
            if let paymentVC = segue.destination as? PaymentViewController {
                paymentVC.annotation = annotation
                paymentVC.addressString = addressString
                paymentVC.cityString = cityString
                paymentVC.stateString = stateString
                paymentVC.zipString = zipString
                paymentVC.timeRequested = timeRequested
                paymentVC.selectedWasher = selectedWasher
                paymentVC.scheduleViewController = self
            }
        }
    }
}
