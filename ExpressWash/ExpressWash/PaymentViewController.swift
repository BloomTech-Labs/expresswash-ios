//
//  PaymentViewController.swift
//  ExpressWash
//
//  Created by Bobby Keffury on 6/17/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import UIKit
import Stripe
import Mapbox

class PaymentViewController: UIViewController, UICollectionViewDelegate,
UICollectionViewDataSource, STPAuthenticationContext {

    // MARK: - Properties

    lazy var cardTextField: STPPaymentCardTextField = {
        let cardTextField = STPPaymentCardTextField()
        return cardTextField
    }()
    var cars: [Car] {
        let orderedSet = UserController.shared.sessionUser.user?.cars?.set as? Set<Car> ?? []
        return orderedSet.sorted { (car1, car2) -> Bool in
            car1.carId > car2.carId
        }
    }
    var jobController = JobController()
    var amount: Int?
    var addressString: String?
    var cityString: String?
    var stateString: String?
    var zipString: String?
    var selectedWasher: Washer?
    var selectedCar: Car?
    var annotation: MGLAnnotation?
    var timeRequested: String?

    // MARK: - Outlets

    @IBOutlet weak var carsCollectionView: UICollectionView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var confirmWashButton: UIButton!

    // MARK: - Views

    override func viewDidLoad() {
        super.viewDidLoad()

        carsCollectionView.allowsMultipleSelection = false
        confirmWashButton.layer.cornerRadius = 10.0
        cardView.addSubview(cardTextField)
        cardTextField.translatesAutoresizingMaskIntoConstraints = false
        cardTextField.textColor = UIColor(named: "Navy")
        NSLayoutConstraint.activate([
            cardTextField.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            cardTextField.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            cardTextField.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            cardTextField.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            cardTextField.heightAnchor.constraint(equalToConstant: 50.0)
        ])
    }

    // MARK: - CollectionView

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cars.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "carCell",
                                                            for: indexPath) as? CarCollectionViewCell else {
                                                                return UICollectionViewCell() }

        let car = cars[indexPath.row]

        if let photoString = car.photo {
            cell.imageView.image = UIImage.cached(from: photoString, defaultTitle: nil)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedCar = nil
        self.selectedCar = cars[indexPath.row]
        setAmount(car: selectedCar!, washer: selectedWasher!)
        StripeController.shared.startCheckout(with: self.amount!)
    }

    // MARK: - Methods

    private func createJob() {
        let jobRep = JobRepresentation(jobLocationLat: annotation!.coordinate.latitude,
                                       jobLocationLon: annotation!.coordinate.latitude,
                                       address: addressString!,
                                       address2: nil,
                                       city: cityString!,
                                       state: stateString!,
                                       zip: zipString!,
                                       notes: nil,
                                       jobType: "basic",
                                       timeRequested: timeRequested!,
                                       carId: Int(selectedCar!.carId),
                                       clientId: Int(UserController.shared.sessionUser.user!.userId),
                                       washerId: Int(selectedWasher!.washerId))

        jobController.addJob(jobRepresentation: jobRep) { (job, error) in
            if let error = error {
                print("Error adding job: \(error)")
                return
            }

            guard let job = job else { return }

            self.jobController.assignWasher(job: job, washerID: Int(self.selectedWasher!.washerId)) { (job, error) in
                if let error = error {
                    print("Error assigning washer to job: \(error)")
                    return
                }

                if job != nil {
                    self.dismiss(animated: true, completion: nil)
                    self.tabBarController?.selectedIndex = 3
                }
            }
        }
    }

    private func setAmount(car: Car, washer: Washer) {
        if car.size == "small" {
            self.amount = Int(washer.rateSmall)
        } else if car.size == "medium" {
            self.amount = Int(washer.rateMedium)
        } else if car.size == "large" {
            self.amount = Int(washer.rateLarge)
        }
    }

    // MARK: - Actions

    @IBAction func confirmWashButtonTapped(_ sender: Any) {
        guard let paymentIntentClientSecret = StripeController.shared.paymentIntentClientSecret else { return }
        // Collect card details
        let cardParams = cardTextField.cardParams
        let paymentMethodParams = STPPaymentMethodParams(card: cardParams, billingDetails: nil, metadata: nil)
        let paymentIntentParams = STPPaymentIntentParams(clientSecret: paymentIntentClientSecret)
        paymentIntentParams.paymentMethodParams = paymentMethodParams

        // Submit the payment
        let paymentHandler = STPPaymentHandler.shared()
        paymentHandler.confirmPayment(withParams: paymentIntentParams,
                                      authenticationContext: self) { (status, _, _) in
            switch status {
            case .failed:
                // Alert of failed payment
                print("Payment Failed")
            case .canceled:
                // Alert of cenceled payment
                print("Payment Canceled")
            case .succeeded:
                // Alert of succeeded payment
                self.createJob()
                print("Payment Successful")
            @unknown default:
                fatalError()
            }
        }
    }

    func authenticationPresentingViewController() -> UIViewController {
        return self
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}
