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

    // MARK: - Outlets

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var largeRateLabel: UILabel!
    @IBOutlet weak var mediumRateLabel: UILabel!
    @IBOutlet weak var smallRateLabel: UILabel!
    @IBOutlet weak var activeSwitch: UISwitch!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var arrivedCompleteButton: UIButton!
    @IBOutlet weak var arrivedCompleteLabel: UILabel!

    // MARK: - Views

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
        setUpMap()
    }

    // MARK: - Methods

    func setupSubviews() {
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height/2
    }

    func setUpMap() {
        let map = MGLMapView(frame: mapView.bounds)
        map.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        map.attributionButton.isHidden = true

        mapView.addSubview(map)
        map.delegate = self
    }

    // MARK: - Actions

    @IBAction func editButtonTapped(_ sender: Any) {
    }

    @IBAction func activeSwitchToggled(_ sender: Any) {
    }

    @IBAction func arrivedCompleteTapped(_ sender: Any) {
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
}
