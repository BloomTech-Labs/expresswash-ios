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
        guard let user = UserController.shared.sessionUser.user else { return [] }
        guard let cars = user.cars else { return [] }
        return cars.sorted(by: { (carOne, carTwo) -> Bool in
            carOne.carId > carTwo.carId
        })
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
    var selectedIndexPath: IndexPath?

    // MARK: - Outlets

    @IBOutlet weak var carsCollectionView: UICollectionView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var confirmWashButton: UIButton!

    // MARK: - Views

    override func viewDidLoad() {
        super.viewDidLoad()

        carsCollectionView.delegate = self
        carsCollectionView.dataSource = self
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

        if self.selectedIndexPath != nil && indexPath == self.selectedIndexPath {
            cell.layer.borderColor = UIColor(named: "Salmon")?.cgColor
        } else {
            cell.layer.backgroundColor = UIColor.white.cgColor
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 2.0
        cell?.layer.borderColor = UIColor(named: "Salmon")?.cgColor
        self.selectedIndexPath = indexPath
        self.selectedCar = nil
        self.selectedCar = cars[indexPath.row]
        setAmount(car: selectedCar!, washer: selectedWasher!)
        StripeController.shared.startCheckout(with: self.amount!)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 0.0
        cell?.layer.borderColor = UIColor.white.cgColor
        self.selectedIndexPath = nil
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
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                        self.tabBarController?.selectedIndex = 3
                    }
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
}

extension PaymentViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120.0, height: 120.0)
    }
}
