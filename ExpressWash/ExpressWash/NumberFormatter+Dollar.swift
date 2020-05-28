//
//  NumberFormatter+Dollar.swift
//  ExpressWash
//
//  Created by Joel Groomer on 5/27/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import Foundation

extension NumberFormatter {
    static var Dollar: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.currencyCode = "USD"
        return formatter
    }()
    
    static func dollarString(_ amount: Double) -> String {
        var dollarValue = "$"
        if let strValue = NumberFormatter.Dollar.string(from: NSNumber(value: amount)) {
            dollarValue += strValue
        }

        return dollarValue
    }
}
