//
//  WasherModelTests.swift
//  ExpressWashTests
//
//  Created by Joel Groomer on 5/7/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import XCTest
@testable import ExpressWash

class WasherModelTests: XCTestCase {

    let testAboutMe = "I'm a washer"
    let updatedAboutMe = "I'm an updated washer!"
    let testLat = 35.8609
    let testLon = -120.8200
    let updatedLat = 37.1234
    let updatedLon = -122.0987
    let testRateSmall = 25.0
    let testRateMedium = 40.0
    let testRateLarge = 55.0
    let updatedRateLarge = 60.0

    override func setUpWithError() throws {
        if let rateWasherData = JSONLoader.readFrom(filename: "washerRating") {
            // test data
            URLProtocolMock.testURLs[BASEURL.appendingPathComponent(ENDPOINTS.washerRating.rawValue).appendingPathComponent("1")] = rateWasherData
        }
        
        if let userData = JSONLoader.readFrom(filename: "authLogin") {
            URLProtocolMock.testURLs[BASEURL.appendingPathComponent(ENDPOINTS.users.rawValue).appendingPathComponent("39")] = userData
        }
        
        if let user1Data = JSONLoader.readFrom(filename: "User1") {
            URLProtocolMock.testURLs[BASEURL.appendingPathComponent(ENDPOINTS.users.rawValue).appendingPathComponent("1")] = user1Data

        }
        
        // Set URLSession to use Mock Protocol
        let testConfig = URLSessionConfiguration.ephemeral
        testConfig.protocolClasses = [URLProtocolMock.self]
        ExpressWash.SESSION = URLSession(configuration: testConfig)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWasherModel() throws {
        // tests Washer and WasherRepresentation computed property

        let user = User(accountType: "washer",
                        email: "washer@email.com",
                        firstName: "Test",
                        lastName: "User")
        user.userId = 1

        let washer = Washer(aboutMe: testAboutMe,
                            available: false,
                            currentLocationLat: testLat,
                            currentLocationLon: testLon,
                            rateSmall: testRateSmall,
                            rateMedium: testRateMedium,
                            rateLarge: testRateLarge,
                            washerId: NOID32,
                            washerRating: 3,
                            washerRatingTotal: 3,
                            user: user)

        XCTAssert(washer.aboutMe == "I'm a washer")
        XCTAssertFalse(washer.workStatus)
        XCTAssert(washer.currentLocationLat == testLat)
        XCTAssert(washer.currentLocationLon == testLon)
        XCTAssert(washer.rateSmall == testRateSmall)
        XCTAssert(washer.rateMedium == testRateMedium)
        XCTAssert(washer.rateLarge == testRateLarge)
        XCTAssert(washer.washerId == NOID32)
        XCTAssert(washer.washerRating == 3)
        XCTAssert(washer.washerRatingTotal == 3)
        XCTAssert(washer.user == user)
        XCTAssert(washer.user?.userId == 1)

        let representation = washer.representation
        XCTAssert(representation.aboutMe == "I'm a washer")
        XCTAssertFalse(representation.workStatus)
        XCTAssert(representation.currentLocationLat == testLat)
        XCTAssert(representation.currentLocationLon == testLon)
        XCTAssert(representation.rateSmall == testRateSmall)
        XCTAssert(representation.rateMedium == testRateMedium)
        XCTAssert(representation.rateLarge == testRateLarge)
        XCTAssert(representation.washerId == NOID32)
        XCTAssert(representation.washerRating == 3)
        XCTAssert(representation.washerRatingTotal == 3)
        XCTAssert(representation.userId == 1)
    }
    
    func testWasherController() throws {
        let user = User(userId: 1,
                        accountType: "washer",
                        email: "washer@email.com",
                        firstName: "Test",
                        lastName: "User")
        var washerRep = WasherRepresentation(aboutMe: testAboutMe,
                                             available: false,
                                             currentLocationLat: testLat,
                                             currentLocationLon: testLon,
                                             rateSmall: testRateSmall,
                                             rateMedium: testRateMedium,
                                             rateLarge: testRateLarge,
                                             washerId: 97,
                                             washerRating: 3,
                                             washerRatingTotal: 3,
                                             userId: Int(user.userId))

        let washerController = WasherController()
        _ = Washer(representation: washerRep)
        
        guard let washer = washerController.findWasher(byID: Int32(97)) else {
            XCTFail()
            return
        }
        
        washerRep.washerId = 987
        washerRep.aboutMe = updatedAboutMe
        washerRep.currentLocationLat = updatedLat
        washerRep.currentLocationLon = updatedLon
        washerRep.rateLarge = updatedRateLarge
        
        let washerExpectation = expectation(description: "Washer is updated")
        let washerDeletedExpectation = expectation(description: "Washer deleted")

        washerController.updateWasher(washer, with: washerRep) { (error) in
            if let error = error {
                print(error)
                XCTFail()
                return
            }
            
            XCTAssert(washer.washerId == 987)
            XCTAssert(washer.aboutMe == self.updatedAboutMe)
            XCTAssert(washer.currentLocationLat == self.updatedLat)
            XCTAssert(washer.currentLocationLon == self.updatedLon)
            XCTAssert(washer.rateLarge == self.updatedRateLarge)
            washerExpectation.fulfill()
            
            washerController.deleteWasherLocally(washer: washer) { error in
                XCTAssertNil(error)
                washerDeletedExpectation.fulfill()
            }
        }
        

        waitForExpectations(timeout: 3.0, handler: nil)
        
        let washerDeletedExpectation = expectation(description: "Washer is deleted")
        washerController.deleteWasherLocally(washer: washer) { error in
            XCTAssertNil(error)
            washerDeletedExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 3.0, handler: nil)
    }
    
    func testRateWasher() throws {
        let user = User(accountType: "washer", email: "test@email.com", firstName: "test", lastName: "washer")
        let washer = Washer(aboutMe: testAboutMe, currentLocationLat: testLat, currentLocationLon: testLon, rateSmall: testRateSmall, rateMedium: testRateMedium, rateLarge: testRateLarge, washerId: 8, washerRating: 3, washerRatingTotal: 1, user: user)
        let washerController = WasherController()
        
        washer.washerId = 1
        
        let rateExpectation = expectation(description: "Rating updated to 4")
        washerController.rate(washer: washer, rating: 5) { error in
            XCTAssertNil(error)
            XCTAssert(washer.washerRating == 4)
            XCTAssert(washer.washerRatingTotal == 2)
            rateExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
}
