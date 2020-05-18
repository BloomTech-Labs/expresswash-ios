//
//  MainViewController.swift
//  ExpressWash
//
//  Created by Bobby Keffury on 4/21/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import UIKit
import Mapbox

class ScheduleViewController: UIViewController, MGLMapViewDelegate {

    // MARK: - Properties

    // MARK: - Outlets

    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var washersCollectionView: UICollectionView!
    @IBOutlet weak var scheduleWashButton: UIButton!

    // MARK: - Views

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
        setUpMap()
    }

    // MARK: - Methods

    func setupSubviews() {
        scheduleWashButton.layer.cornerRadius = 10.0
    }

    func setUpMap() {
        let map = MGLMapView(frame: mapView.bounds)
        map.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        map.attributionButton.isHidden = true
        mapView.addSubview(map)
        map.delegate = self
    }

    // MARK: - Actions

    @IBAction func searchButtonTapped(_ sender: Any) {
    }

    @IBAction func currentLocationButtonTapped(_ sender: Any) {
    }

    @IBAction func scheduleWashButtonTapped(_ sender: Any) {
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
}
