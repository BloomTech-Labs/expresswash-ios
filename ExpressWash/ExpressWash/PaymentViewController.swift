//
//  PaymentViewController.swift
//  ExpressWash
//
//  Created by Bobby Keffury on 6/17/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import UIKit
import Stripe

class PaymentViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,
STPPaymentOptionsViewControllerDelegate, STPAddCardViewControllerDelegate {

    // MARK: - Properties

    let customerContext = MockCustomerContext()

    // MARK: - Outlets

    @IBOutlet weak var carsCollectionView: UICollectionView!
    @IBOutlet weak var selectPaymentView: UIView!
    @IBOutlet var doubleTapGesture: UITapGestureRecognizer!
    @IBOutlet weak var confirmWashButton: UIButton!
    @IBOutlet weak var selectPaymentLabel: UILabel!

    // MARK: - Views

    override func viewDidLoad() {
        super.viewDidLoad()

        confirmWashButton.layer.cornerRadius = 10.0
        selectPaymentView.layer.cornerRadius = 10.0
    }

    // MARK: - Payment

    func paymentOptionsViewController(_ paymentOptionsViewController: STPPaymentOptionsViewController,
                                      didFailToLoadWithError error: Error) {
        dismiss(animated: true, completion: nil)
    }

    func paymentOptionsViewControllerDidFinish(_ paymentOptionsViewController: STPPaymentOptionsViewController) {
        dismiss(animated: true, completion: nil)
    }

    func paymentOptionsViewControllerDidCancel(_ paymentOptionsViewController: STPPaymentOptionsViewController) {
        dismiss(animated: true, completion: nil)
    }

    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        dismiss(animated: true, completion: nil)
    }

    func addCardViewController(_ addCardViewController: STPAddCardViewController,
                               didCreatePaymentMethod paymentMethod: STPPaymentMethod,
                               completion: @escaping STPErrorBlock) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - CollectionView

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }

    // MARK: - Methods

    // MARK: - Actions

    @IBAction func doubleTapGestureComplete(_ sender: Any) {
        let theme = STPTheme()

        let config = STPPaymentConfiguration()
        config.additionalPaymentOptions = .default
        config.requiredBillingAddressFields = .none
        config.appleMerchantIdentifier = "dummy-merchant-id"
        let viewController = STPPaymentOptionsViewController(configuration: config,
                                                             theme: theme,
                                                             customerContext: self.customerContext,
                                                             delegate: self)
        viewController.apiClient = MyAPIClient()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.stp_theme = theme
        present(navigationController, animated: true, completion: nil)
    }

    @IBAction func confirmWashButtonTapped(_ sender: Any) {
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}
