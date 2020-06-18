//
//  StripeController.swift
//  ExpressWash
//
//  Created by Bobby Keffury on 6/17/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import Foundation
import Stripe

class MyAPIClient: STPAPIClient {
    override func createPaymentMethod(with paymentMethodParams: STPPaymentMethodParams,
                                      completion: @escaping STPPaymentMethodCompletionBlock) {
        guard let card = paymentMethodParams.card,
            let billingDetails = paymentMethodParams.billingDetails else { return }

        var cardJSON: [String: Any] = [:]
        var billingDetailsJSON: [String: Any] = [:]
        cardJSON["id"] = "\(card.hashValue)"
        cardJSON["exp_month"] = "\(card.expMonth ?? 0)"
        cardJSON["exp_year"] = "\(card.expYear ?? 0)"
        cardJSON["last4"] = card.number?.suffix(4)
        billingDetailsJSON["name"] = billingDetails.name
        billingDetailsJSON["line1"] = billingDetails.address?.line1
        billingDetailsJSON["line2"] = billingDetails.address?.line2
        billingDetailsJSON["state"] = billingDetails.address?.state
        billingDetailsJSON["postal_code"] = billingDetails.address?.postalCode
        billingDetailsJSON["country"] = billingDetails.address?.country
        cardJSON["country"] = billingDetails.address?.country
        if let number = card.number {
            let brand = STPCardValidator.brand(forNumber: number)
            cardJSON["brand"] = STPCard.string(from: brand)
        }
        cardJSON["fingerprint"] = "\(card.hashValue)"
        cardJSON["country"] = "US"
        let paymentMethodJSON: [String: Any] = [
            "id": "\(card.hashValue)",
            "object": "payment_method",
            "type": "card",
            "livemode": false,
            "created": NSDate().timeIntervalSince1970,
            "used": false,
            "card": cardJSON,
            "billing_details": billingDetailsJSON
        ]
        let paymentMethod = STPPaymentMethod.decodedObject(fromAPIResponse: paymentMethodJSON)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            completion(paymentMethod, nil)
        }
    }
}

class MockCustomer: STPCustomer {
    var paymentMethods: [STPPaymentMethod] = []
    var defaultPaymentMethod: STPPaymentMethod?

    var paymentMethodArray: [STPPaymentMethod] {
        get {
            return paymentMethods
        }
        set {
            paymentMethods = newValue
        }
    }

    var defaultPaymentMethods: STPPaymentMethod? {
        get {
            return defaultPaymentMethod
        }
        set {
            defaultPaymentMethod = newValue
        }
    }
}

class MockCustomerContext: STPCustomerContext {

    let customer = MockCustomer()

    override func retrieveCustomer(_ completion: STPCustomerCompletionBlock? = nil) {
        if let completion = completion {
            completion(customer, nil)
        }
    }

    override func attachPaymentMethod(toCustomer paymentMethod: STPPaymentMethod, completion: STPErrorBlock? = nil) {
        customer.paymentMethods.append(paymentMethod)
        if let completion = completion {
            completion(nil)
        }
    }

    override func detachPaymentMethod(fromCustomer paymentMethod: STPPaymentMethod, completion: STPErrorBlock? = nil) {
        if let index = customer.paymentMethods.firstIndex(where: { $0.stripeId == paymentMethod.stripeId }) {
            customer.paymentMethods.remove(at: index)
        }
        if let completion = completion {
            completion(nil)
        }
    }

    override func listPaymentMethodsForCustomer(completion: STPPaymentMethodsCompletionBlock? = nil) {
        if let completion = completion {
            completion(customer.paymentMethods, nil)
        }
    }

    func selectDefaultCustomerPaymentMethod(_ paymentMethod: STPPaymentMethod, completion: @escaping STPErrorBlock) {
        if customer.paymentMethods.contains(where: { $0.stripeId == paymentMethod.stripeId }) {
            customer.defaultPaymentMethod = paymentMethod
        }
        completion(nil)
    }
}
