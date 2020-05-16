//
//  SignUpTests.swift
//  ExpressWashTests
//
//  Created by Bobby Keffury on 5/11/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import XCTest
@testable import ExpressWash

class SignUpTests: XCTestCase {

    override func setUpWithError() throws {
        // test data
        if let authLoginData = JSONLoader.readFrom(filename: "authRegister") {
            URLProtocolMock.testURLs[BASEURL.appendingPathComponent(ENDPOINTS.login.rawValue)] = authLoginData
        }

        // Set URLSession to use Mock Protocol
        let testConfig = URLSessionConfiguration.ephemeral
        testConfig.protocolClasses = [URLProtocolMock.self]
        ExpressWash.SESSION = URLSession(configuration: testConfig)
    }

    override func tearDownWithError() throws {
    }

    func testRegistration() throws {

        let accountType = "client"
        let email = "John.Doe@gmail.com"
        let firstName = "John"
        let lastName = "Doe"
        let password = "12345678"

        let expect = expectation(description: "User registered")

        UserController.shared.registerUser(account: accountType, with: email, firstName, lastName, password) { (user, error) in
                if let error = error {
                    print("Error: \(error)")
                    XCTFail()
                }

                guard let user = user else {
                    XCTFail()
                    return
                }

                XCTAssert(user.firstName == firstName)
                XCTAssert(user.lastName == lastName)
                XCTAssert(user.email == email)
                XCTAssert(UserController.shared.sessionUser == user)
                expect.fulfill()
            }

            waitForExpectations(timeout: 3.0, handler: nil)
        }

}