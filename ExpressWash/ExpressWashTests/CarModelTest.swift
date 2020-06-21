//
//  CarModelTest.swift
//  ExpressWashTests
//
//  Created by Joel Groomer on 5/7/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import XCTest
@testable import ExpressWash

class CarModelTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCarModel() throws {
        let user = User(accountType: "client", email: "email@email.com", firstName: "Test", lastName: "User")
        user.userId = 1

        let car1 = Car(carId: 1,
                       clientId: 6,
                       make: "Ford",
                       model: "Taurus",
                       year: 2016,
                       color: "White",
                       licensePlate: "1ABC234",
                       photo: nil,
                       category: "Car",
                       size: CarSize.medium.rawValue)
        let car2 = Car(carId: 2,
                       clientId: 6,
                       make: "Nissan",
                       model: "Sentra",
                       year: 2020,
                       color: "Silver",
                       licensePlate: "2DEF345",
                       photo: nil,
                       category: "Car",
                       size: CarSize.medium.rawValue)

        XCTAssert(car1.carId == 1)
        XCTAssert(car1.make == "Ford")
        XCTAssert(car1.model == "Taurus")
        XCTAssert(car1.year == 2016)

        XCTAssert(car2.color == "Silver")
        XCTAssert(car2.photo == nil)
        XCTAssert(car2.licensePlate == "2DEF345")
        XCTAssert(car2.size == CarSize.medium.rawValue)

        user.addToCars(car1)
        user.addToCars(car2)

        XCTAssert(user.cars!.contains(car1))
        XCTAssert(user.cars!.contains(car2))

        XCTAssert(car1.owner == user)
        XCTAssert(car2.owner == user)
    }

    func testCarModelRepresentation() {
        let user = User(accountType: "client", email: "email@email.com", firstName: "Test", lastName: "User")
        user.userId = 1

        let car1 = Car(carId: 1,
                       clientId: 6,
                       make: "Ford",
                       model: "Taurus",
                       year: 2016,
                       color: "White",
                       licensePlate: "1ABC234",
                       photo: nil,
                       category: "Car",
                       size: CarSize.medium.rawValue)
        
        if let carRep = car1.representation {
            XCTAssert(carRep.carId == 1)
            XCTAssert(carRep.make == "Ford")
            XCTAssert(carRep.model == "Taurus")
            XCTAssert(carRep.year == 2016)
        } else {
            XCTFail()
        }
    }
}
