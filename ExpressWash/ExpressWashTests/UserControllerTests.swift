//
//  UserControllerTests.swift
//  ExpressWashTests
//
//  Created by Joel Groomer on 6/21/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import XCTest
@testable import ExpressWash

class UserControllerTests: XCTestCase {

    override func setUpWithError() throws {
        if let userData = JSONLoader.readFrom(filename: "User1") {
            URLProtocolMock.testURLs[BASEURL.appendingPathComponent(ENDPOINTS.users.rawValue).appendingPathComponent("1")] = userData
        }
        
        // Set URLSession to use Mock Protocol
        let testConfig = URLSessionConfiguration.ephemeral
        testConfig.protocolClasses = [URLProtocolMock.self]
        ExpressWash.SESSION = URLSession(configuration: testConfig)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFindUserByID() throws {
        _ = User(userId: 1000, accountType: "client", email: "test@test.com", firstName: "Test", lastName: "Client", bannerImage: nil, phoneNumber: "555-555-1212", profilePicture: nil, stripeUUID: nil, streetAddress: "1234 First St.", streetAddress2: "nil", city: "Town", state: "CA", zip: "90000", userRating: 3.0, userRatingTotal: 1)
                
        let user = UserController.shared.findUser(byID: Int32(1000))
        XCTAssertNotNil(user)
    }
    
    func testUpdateUser() throws {
        let user = User(userId: 1, accountType: "client", email: "test@test.com", firstName: "Test", lastName: "Client", bannerImage: nil, phoneNumber: "555-555-1212", profilePicture: nil, stripeUUID: nil, streetAddress: "1234 First St.", streetAddress2: "nil", city: "Town", state: "CA", zip: "90000", userRating: 3.0, userRatingTotal: 1)
        var userRep = user.representation
        userRep.streetAddress2 = "Apt D"
        
        UserController.shared.updateUser(user, with: userRep)
        
        XCTAssert(user.streetAddress2 == "Apt D")
    }

    func testDeleteUser() throws {
        let user = User(userId: 1, accountType: "client", email: "test@test.com", firstName: "Test", lastName: "Client", bannerImage: nil, phoneNumber: "555-555-1212", profilePicture: nil, stripeUUID: nil, streetAddress: "1234 First St.", streetAddress2: "nil", city: "Town", state: "CA", zip: "90000", userRating: 3.0, userRatingTotal: 1)
        
        UserController.shared.deleteUser(user: user) { error in
            XCTAssertNil(error)
        }
    }
    
    func testUpdate() throws {
        let user = User(userId: 1, accountType: "client", email: "test@test.com", firstName: "Test", lastName: "Client", bannerImage: nil, phoneNumber: "555-555-1212", profilePicture: nil, stripeUUID: nil, streetAddress: "1234 First St.", streetAddress2: "nil", city: "Town", state: "CA", zip: "90000", userRating: 3.0, userRatingTotal: 1)
        var userRep = user.representation
        userRep.streetAddress2 = "Apt D"
        
        UserController.shared.update(user: user, with: userRep, saveOnMainContext: true)
        
        XCTAssert(user.streetAddress2 == "Apt D")
    }

    func testPut() {
        let user = User(userId: 1, accountType: "client", email: "test@test.com", firstName: "Test", lastName: "Client", bannerImage: nil, phoneNumber: "555-555-1212", profilePicture: nil, stripeUUID: nil, streetAddress: "1234 First St.", streetAddress2: "nil", city: "Town", state: "CA", zip: "90000", userRating: 3.0, userRatingTotal: 1)
        
        UserController.shared.put(user: user) { error in
            XCTAssertNil(error)
        }
    }
    
}
