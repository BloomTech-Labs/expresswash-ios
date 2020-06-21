//
//  WasherViewController+MGLMapViewDelegate.swift
//  ExpressWash
//
//  Created by Joel Groomer on 6/20/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import Foundation
import Mapbox

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

    func addAnnotation() {
        guard let job = job else { return }
        annotation = MGLPointAnnotation()
        annotation!.coordinate = CLLocationCoordinate2D(latitude: job.jobLocationLat, longitude: job.jobLocationLon)
        annotation!.title = "\(job.address)"
        if job.address2 != nil {
            annotation!.title! += ", \(job.address2!)"
        }
        annotation!.subtitle = jobStarted ? "Tap the button when you arrive ->" : "Tap the button when you are done ->"
        mapView.addAnnotation(annotation!)
        mapView.setCenter(annotation!.coordinate, animated: true)
    }

    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        true
    }

    func mapView(_ mapView: MGLMapView, rightCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        let buttonName = jobStarted ? "checkmark.seal.fill" : "mappin.and.ellipse"
        button.setImage(UIImage(systemName: buttonName), for: .normal)
        return button
    }

    func mapView(_ mapView: MGLMapView, annotation: MGLAnnotation, calloutAccessoryControlTapped control: UIControl) {
        arrivedCompleteTapped(self)
    }
}
