//
//  PaymentViewController.swift
//  ExpressWash
//
//  Created by Bobby Keffury on 6/17/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import UIKit
import Stripe

class PaymentViewController: UIViewController, UICollectionViewDelegate,
UICollectionViewDataSource, STPAuthenticationContext {

    // MARK: - Properties

    lazy var cardTextField: STPPaymentCardTextField = {
        let cardTextField = STPPaymentCardTextField()
        return cardTextField
    }()
    var jobRep: JobRepresentation?
    var cars: [Car] {
        let orderedSet = UserController.shared.sessionUser.user?.cars?.set as? Set<Car> ?? []
        return orderedSet.sorted { (car1, car2) -> Bool in
            car1.carId > car2.carId
        }
    }
    var amount: Int?

    // MARK: - Outlets

    @IBOutlet weak var carsCollectionView: UICollectionView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var confirmWashButton: UIButton!

    // MARK: - Views

    override func viewDidLoad() {
        super.viewDidLoad()

        confirmWashButton.layer.cornerRadius = 10.0
        cardView.addSubview(cardTextField)
        cardTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cardTextField.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            cardTextField.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            cardTextField.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            cardTextField.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            cardTextField.heightAnchor.constraint(equalToConstant: 50.0)
        ])
        if let amount = amount {
            StripeController.shared.startCheckout(with: amount)
        }
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

    // MARK: - Methods

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
                break
            case .canceled:
                // Alert of cenceled payment
                print("Payment Canceled")
                break
            case .succeeded:
                // Alert of succeeded payment
                print("Payment Successful")
                break
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
