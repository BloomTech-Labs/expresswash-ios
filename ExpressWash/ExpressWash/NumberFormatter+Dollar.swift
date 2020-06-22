//
//  NumberFormatter+Dollar.swift
//  ExpressWash
//
//  Created by Joel Groomer on 5/27/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import Foundation

extension NumberFormatter {
    public static var Dollar: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.minimumIntegerDigits = 1
        formatter.maximumFractionDigits = 0
        return formatter
    }()

    public static var DollarsAndCents: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.minimumIntegerDigits = 1
        formatter.roundingMode = .halfUp
        return formatter
    }()

    public static func dollarString(_ amount: Double) -> String {
        // basically just truncates any decimal places and adds a $ in front

        if let strValue = NumberFormatter.Dollar.string(from: NSNumber(value: amount)) {
            return strValue
        }

        return ""
    }

    public static func dollarsAndCentsString(_ amount: Double) -> String {
        if let strValue = NumberFormatter.DollarsAndCents.string(from: NSNumber(value: amount)) {
            return strValue
        }

        return ""
    }
}
