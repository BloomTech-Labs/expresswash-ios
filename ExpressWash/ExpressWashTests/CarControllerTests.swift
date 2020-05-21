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
        
        if let EditData = JSONLoader.readFrom(filename: "EditCar") {
            URLProtocolMock.testURLs[BASEURL.appendingPathComponent("cars/\(0)")] = EditData
        }
        
        // Set URLSession to use Mock Protocol
        let testConfig = URLSessionConfiguration.ephemeral
        testConfig.protocolClasses = [URLProtocolMock.self]
        ExpressWash.SESSION = URLSession(configuration: testConfig)
    }

    override func tearDownWithError() throws {
    }

    func testCreateCar() throws {

        let carId = 0
        let make = "ford"
        let model = "mustang"
        let year: Int16 = 1996
        let color = "blue"
        let licensePlate = "xyz 123"
        let photo = "some url"
        let category = "car"
        let size = "small"
        
        let carRepresentation = CarRepresentation(carId: carId, make: make, model: model, year: year, color: color, licensePlate: licensePlate, photo: photo, category: category, size: size)
        
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

        let carId = 0
        let make = "ford"
        let model = "mustang"
        let year: Int16 = 1996
        let color = "blue"
        let licensePlate = "xyz 123"
        let photo = "some url"
        let category = "car"
        let size = "small"
        
        let carRepresentation = CarRepresentation(carId: carId, make: make, model: model, year: year, color: color, licensePlate: licensePlate, photo: photo, category: category, size: size)
        
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

        let carId = 0
        let make = "ford"
        let model = "fusion"
        let year: Int16 = 1996
        let color = "blue"
        let licensePlate = "xyz 123"
        let photo = "some url"
        let category = "car"
        let size = "small"
        
        let carRepresentation = CarRepresentation(carId: carId, make: make, model: model, year: year, color: color, licensePlate: licensePlate, photo: photo, category: category, size: size)
        
        let expect = expectation(description: "Car Edited")
        
        CarController.shared.editCar(carRepresentation: carRepresentation) { (car, error) in
            if let error = error {
                 print("Error: \(error)")
                 XCTFail()
             }
             
             guard let car = car else {
                 XCTFail()
                 return
             }

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
    
    func testUpdateCar() throws {
        
        let carId = 0
        let make = "ford"
        let model = "fusion"
        let year: Int16 = 1996
        let color = "blue"
        let licensePlate = "xyz 123"
        let photo = "some url"
        let category = "car"
        let size = "small"
        
        let carRepresentation = CarRepresentation(carId: carId, make: make, model: model, year: year, color: color, licensePlate: licensePlate, photo: photo, category: category, size: size)
        
        let expect = expectation(description: "Car Updated")
        
        CarController.shared.updateCar(carRepresentation: carRepresentation) { (car, error) in
            if let error = error {
                print("Error: \(error)")
                XCTFail()
            }
            
            guard let car = car else {
                XCTFail()
                return
            }
            
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
    
    func testDeleteCar() throws {
        if let DeleteData = JSONLoader.readFrom(filename: "DeleteCar") {
            URLProtocolMock.testURLs[BASEURL.appendingPathComponent("cars/\(0)")] = DeleteData
        }

        let car = Car(carId: 0, make: "", model: "", year: 1996, color: "", licensePlate: "", photo: "", category: "", size: "")
        
        let expect = expectation(description: "Car Deleted")
        
        CarController.shared.deleteCar(car: car) { (message, error) in
            if let error = error {
                print("Error: \(error)")
                XCTFail()
            }
            
            guard let message = message else {
                XCTFail()
                return
            }
            
            XCTAssert(message == "Successfully deleted 1 car")
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 3.0, handler: nil)
    }
}
