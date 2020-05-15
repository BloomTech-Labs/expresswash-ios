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
    }

    override func tearDownWithError() throws {
    }

    func testRegistration() throws {

        let firstName = "John"
        let lastName = "Doe"
        let email = "John.Doe@gmail.com"
        let password = "Password!"

        let expect = expectation(description: "User registered")

        UserController.shared.registerUser(with: firstName, lastName, email, password) { (user, error) in
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
            expect.fulfill()
        }

        waitForExpectations(timeout: 3.0, handler: nil)

    }

}
