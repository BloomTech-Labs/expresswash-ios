//
//  NumberFormatter+DollarTests.swift
//  ExpressWashTests
//
//  Created by Joel Groomer on 6/21/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import XCTest

class NumberFormatter_DollarTests: XCTestCase {

    func testStaticVar() throws {
        XCTAssert(NumberFormatter.Dollar.currencyCode == "USD")
        XCTAssert(NumberFormatter.DollarsAndCents.currencyCode == "USD")
        XCTAssert(NumberFormatter.DollarsAndCents.maximumFractionDigits == 2)
    }

    func testDollarString() throws {
        XCTAssert(NumberFormatter.dollarString(123.0987654) == "$123")
    }

    func testDollarsAndCentsString() throws {
        XCTAssert(NumberFormatter.dollarsAndCentsString(123.0987654) == "$123.10")
    }
}
