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
        return user.carsArray
    }
    var jobController = JobController()
    var amount: Int? {
        didSet {
            amountLabel.text = "$\(amount ?? 0)"
        }
    }
    var addressString: String?
    var cityString: String?
    var stateString: String?
    var zipString: String?
    var selectedWasher: Washer?
    var selectedCar: Car?
    var annotation: MGLAnnotation?
    var timeRequested: String?
    var selectedIndexPath: IndexPath?
    var scheduleViewController: ScheduleViewController?

    // MARK: - Outlets

    @IBOutlet weak var carsCollectionView: UICollectionView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var confirmWashButton: UIButton!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var addCarsButton: UIButton!
    @IBOutlet weak var fullNameLabel: UILabel!

    // MARK: - Views

    override func viewDidLoad() {
        super.viewDidLoad()

        if let user = UserController.shared.sessionUser.user {
            fullNameLabel.text = "\(user.firstName.capitalized) \(user.lastName.capitalized)"
        }
        cardView.layer.cornerRadius = 10.0
        logoImageView.layer.cornerRadius = 10.0
        carsCollectionView.delegate = self
        carsCollectionView.dataSource = self
        carsCollectionView.allowsMultipleSelection = false
        confirmWashButton.layer.cornerRadius = 10.0
        cardView.addSubview(cardTextField)
        cardTextField.translatesAutoresizingMaskIntoConstraints = false
        cardTextField.textColor = UIColor(named: "Navy")
        cardTextField.backgroundColor = .white
        NSLayoutConstraint.activate([
            cardTextField.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10.0),
            cardTextField.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -10.0),
            cardTextField.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            cardTextField.centerXAnchor.constraint(equalTo: cardView.centerXAnchor, constant: -10.0),
            cardTextField.heightAnchor.constraint(equalToConstant: 50.0)
        ])
    }

    // MARK: - CollectionView

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if cars.count == 0 {
            addCarsButton.isEnabled = true
            addCarsButton.alpha = 1
            return cars.count
        } else {
            addCarsButton.isEnabled = false
            addCarsButton.alpha = 0
            return cars.count
        }
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

        cell.modelLabel.text = car.model

        if self.selectedIndexPath != nil && indexPath == self.selectedIndexPath {
            cell.imageView.layer.borderColor = UIColor(named: "Salmon")?.cgColor
        } else {
            cell.imageView.layer.borderColor = UIColor.white.cgColor
        }

        cell.layer.cornerRadius = 5.0

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CarCollectionViewCell
        cell?.imageView.layer.borderWidth = 2.0
        cell?.imageView.layer.borderColor = UIColor(named: "Salmon")?.cgColor
        self.selectedIndexPath = indexPath
        self.selectedCar = nil
        self.selectedCar = cars[indexPath.row]
        setAmount(car: selectedCar!,
                  washer: selectedWasher!)
        StripeController.shared.startCheckout(with: self.amount!)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CarCollectionViewCell
        cell?.imageView.layer.borderWidth = 0.0
        cell?.imageView.layer.borderColor = UIColor.white.cgColor
        self.selectedIndexPath = nil
    }

    // MARK: - Methods

    private func createJob() {
        guard let address = addressString, let city = cityString,
            let state = stateString, let zip = zipString,
            let timeRequested = timeRequested, let car = selectedCar,
            let washer = selectedWasher, let user = washer.user else { return }

        let jobRep = JobRepresentation(jobLocationLat: annotation!.coordinate.latitude,
                                       jobLocationLon: annotation!.coordinate.latitude,
                                       washAddress: address,
                                       address: address,
                                       address2: nil,
                                       city: city,
                                       state: state,
                                       zip: zip,
                                       notes: nil,
                                       jobType: "basic",
                                       timeRequested: timeRequested,
                                       carId: Int(car.carId),
                                       clientId: Int(UserController.shared.sessionUser.user!.userId),
                                       washerId: Int(washer.washerId))

        jobController.addJob(jobRepresentation: jobRep) { (job, error) in
            if let error = error {
                print("Error adding job: \(error)")
                return
            }

            guard let job = job else { return }

            self.jobController.assignWasher(job: job, washerId: Int(washer.washerId),
                                            userId: Int(user.userId)) { (job, error) in
                if let error = error {
                    print("Error assigning washer to job: \(error)")
                    return
                }

                if job != nil {
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                        if let tabBarController = self.scheduleViewController?.tabBarController {
                            tabBarController.selectedIndex = 2
                        }
                    }
                }
            }
        }
    }

    private func setAmount(car: Car, washer: Washer) {
        if car.size == "Small" {
            self.amount = Int(washer.rateSmall)
        } else if car.size == "Medium" {
            self.amount = Int(washer.rateMedium)
        } else if car.size == "Large" {
            self.amount = Int(washer.rateLarge)
        }
    }

    private func alertUser(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
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
                self.alertUser(title: "Payment Failed", message: "please try again")
                print("Payment Failed")
            case .canceled:
                print("Payment Canceled")
            case .succeeded:
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

    @IBAction func addCarsButtonTapped(_ sender: Any) {
        if let tabBarController = scheduleViewController?.tabBarController {
            tabBarController.selectedIndex = 0
        }
        self.dismiss(animated: true, completion: nil)

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addCar"), object: nil)
    }
}

extension PaymentViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120.0, height: 120.0)
    }
}
