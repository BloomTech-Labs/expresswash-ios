//
//  JobModelTests.swift
//  ExpressWashTests
//
//  Created by Joel Groomer on 5/7/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import XCTest
@testable import ExpressWash

class JobModelTests: XCTestCase {

    let testAboutMe = "I'm a washer"
    let testLat = 35.8609
    let testLon = -120.8200
    let testRateSmall = 25.0
    let testRateMedium = 40.0
    let testRateLarge = 55.0

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testJobModel() throws {
        let user = User(accountType: "client", email: "email@email.com", firstName: "Test", lastName: "User")
        let washerUser = User(accountType: "washer", email: "washer@email.com", firstName: "Test", lastName: "User")
        user.userId = 1
        washerUser.userId = 2

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
                            user: washerUser)

        let job = Job(jobId: 1, jobLocationLat: nil ?? 0.0, jobLocationLon: nil ?? 0.0, washAddress: "123 First St", address: "123 First St", address2: "APT 2", city: "tampa", state: "FL", zip: "60184", notes: nil, completed: false, jobType: "basic", paid: false, photoBeforeJob: nil, photoAfterJob: nil, scheduled: true, timeCompleted: nil, timeRequested: "12:00 PM")

        let car1 = Car(carId: 1,
                       clientId: 4,
                       make: "Ford",
                       model: "Taurus",
                       year: 2016,
                       color: "White",
                       licensePlate: "1ABC234",
                       photo: nil,
                       category: "Car",
                       size: CarSize.medium.rawValue)
        user.addToCars(car1)

        XCTAssert(job.jobLocationLat == 0.0)
        XCTAssert(job.jobLocationLon == 0.0)
        XCTAssert(job.address == "123 First St")
        XCTAssert(job.address2 == "APT 2")
        XCTAssert(job.city == "tampa")
        XCTAssert(job.state == "FL")
        XCTAssert(job.zip == "60184")
        XCTAssert(job.jobType == "basic")
        XCTAssert(job.timeRequested == "12:00 PM")
        

        job.client = user
        job.washer = washer
        job.car = car1

        XCTAssert(user.jobs!.contains(job))
        XCTAssert(washer.jobs!.contains(job))
        XCTAssert(car1.jobs!.contains(job))
        XCTAssert(job.washer!.user == washerUser)
        XCTAssert(user.cars!.contains(job.car!))

    }
    
    func testJobModelRepresentation() throws {
        let user = User(accountType: "client", email: "email@email.com", firstName: "Test", lastName: "User")
        let washerUser = User(accountType: "washer", email: "washer@email.com", firstName: "Test", lastName: "User")
        user.userId = 1
        washerUser.userId = 2

        let washer = Washer(aboutMe: testAboutMe,
                            available: false,
                            currentLocationLat: testLat,
                            currentLocationLon: testLon,
                            rateSmall: testRateSmall,
                            rateMedium: testRateMedium,
                            rateLarge: testRateLarge,
                            washerId: 2,
                            washerRating: 3,
                            washerRatingTotal: 3,
                            user: washerUser)

        let job = Job(jobId: 1, jobLocationLat: nil ?? 0.0, jobLocationLon: nil ?? 0.0, washAddress: "123 First St", address: "123 First St", address2: "APT 2", city: "tampa", state: "FL", zip: "60184", notes: nil, completed: false, jobType: "basic", paid: false, photoBeforeJob: nil, photoAfterJob: nil, scheduled: true, timeCompleted: nil, timeRequested: "12:00 PM")

        let car1 = Car(carId: 1,
                       clientId: 4,
                       make: "Ford",
                       model: "Taurus",
                       year: 2016,
                       color: "White",
                       licensePlate: "1ABC234",
                       photo: nil,
                       category: "Car",
                       size: CarSize.medium.rawValue)
        user.addToCars(car1)
        
        job.client = user
        job.washer = washer
        job.car = car1
        
        guard var jobRep = job.representation else {
            XCTFail()
            return
        }
        
        XCTAssert(jobRep.jobLocationLat == 0.0)
        XCTAssert(jobRep.jobLocationLon == 0.0)
        XCTAssert(jobRep.address == "123 First St")
        XCTAssert(jobRep.address2 == "APT 2")
        XCTAssert(jobRep.city == "tampa")
        XCTAssert(jobRep.state == "FL")
        XCTAssert(jobRep.zip == "60184")
        XCTAssert(jobRep.jobType == "basic")
        XCTAssert(jobRep.timeRequested == "12:00 PM")
        XCTAssert(jobRep.clientId == 1)
        XCTAssert(jobRep.washerId == 2)
        XCTAssert(jobRep.carId == 1)

        jobRep.jobId = 2
        let job2 = Job(representation: jobRep)
        XCTAssert(job2.jobId == 2)
    }

}
