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

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWasherModel() throws {
        // tests Washer and WasherRepresentation computed property

        let testAboutMe = "I'm a washer"
        let testLat = 35.8609
        let testLon = -120.8200
        let testRateSmall = 25.0
        let testRateMedium = 40.0
        let testRateLarge = 55.0

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
}
