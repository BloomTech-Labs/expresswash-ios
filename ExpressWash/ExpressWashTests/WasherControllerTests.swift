//
//  WasherControllerTests.swift
//  ExpressWashTests
//
//  Created by Joel Groomer on 6/22/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import XCTest
@testable import ExpressWash

class WasherControllerTests: XCTestCase {

    override func setUpWithError() throws {
        if let washersInCity = JSONLoader.readFrom(filename: "washersInCity") {
            // test data
            URLProtocolMock.testURLs[BASEURL.appendingPathComponent(ENDPOINTS.washersInCity.rawValue).appendingPathComponent("San Francisco")] = washersInCity
            print("URL: \(BASEURL.appendingPathComponent(ENDPOINTS.washersInCity.rawValue).appendingPathComponent("San%20Francisco"))")
        }
        
        // Set URLSession to use Mock Protocol
        let testConfig = URLSessionConfiguration.ephemeral
        testConfig.protocolClasses = [URLProtocolMock.self]
        ExpressWash.SESSION = URLSession(configuration: testConfig)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetWashersInCity() throws {
        let expect = expectation(description: "A washer is returned")
        WasherController.shared.getWashersInCity("San Francisco") { (washers, error) in
            if let error = error {
                XCTFail("\(error)")
            }
            guard let washers = washers else {
                XCTFail()
                return
            }
            XCTAssert(washers.count > 0)
            expect.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: nil)
    }

}
