//
//  CarControllerTests.swift
//  ExpressWashTests
//
//  Created by Bobby Keffury on 5/18/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import XCTest
@testable import ExpressWash

class CarControllerTests: XCTestCase {

    override func setUpWithError() throws {
        // test data
        if let CarData = JSONLoader.readFrom(filename: "Car") {
            URLProtocolMock.testURLs[BASEURL.appendingPathComponent("cars/")] = CarData
        }

        // Set URLSession to use Mock Protocol
        let testConfig = URLSessionConfiguration.ephemeral
        testConfig.protocolClasses = [URLProtocolMock.self]
        ExpressWash.SESSION = URLSession(configuration: testConfig)
    }

    override func tearDownWithError() throws {
    }

    func testCreateCar() throws {
        
        let clientId = 6
        let carId = 0
        let make = "ford"
        let model = "mustang"
        let year: Int16 = 1996
        let color = "blue"
        let licensePlate = "xyz 123"
        let photo = "some url"
        let category = "car"
        let size = "small"
        
        let carRepresentation = CarRepresentation(clientId: clientId, carId: carId, make: make, model: model, year: year, color: color, licensePlate: licensePlate, photo: photo, category: category, size: size)
        
        let expect = expectation(description: "Car Created")
        
        
        CarController.shared.createCar(carRepresentation: carRepresentation) { (car, error) in
            if let error = error {
                print("Error: \(error)")
                XCTFail()
            }
            
            guard let car = car else {
                XCTFail()
                return
            }
           
            XCTAssert(car.clientId == clientId)
            XCTAssert(car.carId == carId)
            XCTAssert(car.make == make)
            XCTAssert(car.model == model)
            XCTAssert(car.year == year)
            XCTAssert(car.color == color)
            XCTAssert(car.licensePlate == licensePlate)
            XCTAssert(car.photo == photo)
            XCTAssert(car.size == size)
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 3.0, handler: nil)
        
    }
    
    func testAddCar() throws {
        let clientId = 6
        let carId = 0
        let make = "ford"
        let model = "mustang"
        let year: Int16 = 1996
        let color = "blue"
        let licensePlate = "xyz 123"
        let photo = "some url"
        let category = "car"
        let size = "small"
        
        let carRepresentation = CarRepresentation(clientId: clientId, carId: carId, make: make, model: model, year: year, color: color, licensePlate: licensePlate, photo: photo, category: category, size: size)
        
        let expect = expectation(description: "Car Added")
        
        CarController.shared.addCar(carRepresentation: carRepresentation) { (car, error) in
            if let error = error {
                print("Error: \(error)")
                XCTFail()
            }
            
            guard let car = car else {
                XCTFail()
                return
            }
            
            XCTAssert(car.clientId == clientId)
            XCTAssert(car.carId == carId)
            XCTAssert(car.make == make)
            XCTAssert(car.model == model)
            XCTAssert(car.year == year)
            XCTAssert(car.color == color)
            XCTAssert(car.licensePlate == licensePlate)
            XCTAssert(car.photo == photo)
            XCTAssert(car.size == size)
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 3.0, handler: nil)
    }
    
    func testEditCar() throws {
        
    }
}
