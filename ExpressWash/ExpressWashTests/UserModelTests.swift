//
//  UserModelTests.swift
//  ExpressWashTests
//
//  Created by Joel Groomer on 5/7/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import XCTest
@testable import ExpressWash

class UserModelTests: XCTestCase {

    override func setUpWithError() throws {
        // test data
        if let authLoginData = JSONLoader.readFrom(filename: "authLogin") {
            URLProtocolMock.testURLs[BASEURL.appendingPathComponent(ENDPOINTS.login.rawValue)] = authLoginData
        }

        // Set URLSession to use Mock Protocol
        let testConfig = URLSessionConfiguration.ephemeral
        testConfig.protocolClasses = [URLProtocolMock.self]
        ExpressWash.SESSION = URLSession(configuration: testConfig)
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUserModel() throws {
        // tests User and UserRepresentation computed property

        let user = User(accountType: "client", email: "email@email.com", firstName: "Test", lastName: "User")
        XCTAssert(user.userId == NOID32)
        XCTAssert(user.email == "email@email.com")
        XCTAssert(user.firstName == "Test")
        XCTAssert(user.lastName == "User")

        let representation = user.representation
        XCTAssert(representation.userId == NOID)
        XCTAssert(representation.email == "email@email.com")
        XCTAssert(representation.firstName == "Test")
        XCTAssert(representation.lastName == "User")
    }
    
    func testAuthentication() throws {
        let authExpectation = expectation(description: "User is logged in")
        UserController.shared.authenticate(username: "joeltest@test.com", password: "testpasswordtest") { (user, error) in
            if let error = error {
                print("Error: \(error)")
                XCTFail()
            }
            
            guard let user = user else {
                XCTFail()
                return
            }
            
            XCTAssert(user.firstName == "Joel")
            XCTAssert(user.lastName == "Test")
            XCTAssert(user.userId == 39)
            XCTAssert(UserController.shared.sessionUser.user == user)
            authExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }

}
