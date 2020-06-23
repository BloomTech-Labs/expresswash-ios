//
//  DateFromatter+ClockTests.swift
//  ExpressWashTests
//
//  Created by Joel Groomer on 6/21/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import XCTest

class DateFromatter_ClockTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testStaticVars() throws {
        XCTAssert(DateFormatter.Clock.dateFormat == "hh:mm a")
        XCTAssert(DateFormatter.FromISODate.dateFormat == "yyyy-MM-dd HH:mm:ssZ")
        XCTAssert(!DateFormatter.nowAsISOString.isEmpty)
        XCTAssert(DateFormatter.clockString(from: "2020-06-21 04:33:33 +0000") == "09:33 PM")
        XCTAssert(DateFormatter.clockString(from: "gobbledigook") == "00:00?")
        XCTAssert(DateFormatter.Date.dateFormat == "MMM dd, YYYY")
    }

    func testTimeTaken() throws {
        let timeArrived = "2020-06-21 04:33:33 +0000"
        let timeCompleted = "2020-06-21 05:33:33 +0000"
        
        XCTAssert(DateFormatter.timeTaken(timeArrived: timeArrived, timeCompleted: nil) == "In Progress")
        XCTAssert(DateFormatter.timeTaken(timeArrived: timeArrived, timeCompleted: timeCompleted) == "60 min")
    }
}
