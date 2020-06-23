//
//  JobControllerTests.swift
//  ExpressWashTests
//
//  Created by Bobby Keffury on 5/20/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import XCTest
@testable import ExpressWash

class JobControllerTests: XCTestCase {
    
    let address = "123 First St"
    let address2 = "APT 2"
    let city = "tampa"
    let completed = false
    let jobId = 2
    let jobLocationLat = 0.0
    let jobLocationLon = 0.0
    let jobType = "basic"
    let notes: String? = nil
    let paid = false
    let photoBeforeJob: String? = nil
    let photoAfterJob: String? = nil
    let scheduled = true
    let state = "FL"
    let timeRequested = "12:00 PM"
    let timeCompleted: String? = nil
    let zip = "60184"
    let carId = 1
    let clientId = 4
    let washerId = 2
    
    let jobController = JobController()

    override func setUpWithError() throws {
        // test data
        if let JobData = JSONLoader.readFrom(filename: "Job") {
            URLProtocolMock.testURLs[BASEURL.appendingPathComponent(ENDPOINTS.jobNew.rawValue)] = JobData
            
            URLProtocolMock.testURLs[BASEURL.appendingPathComponent("\(ENDPOINTS.jobInfo.rawValue)/\(jobId)")] = JobData
            
            URLProtocolMock.testURLs[BASEURL.appendingPathComponent(ENDPOINTS.jobSelect.rawValue)] = JobData
        }
        
        if let userJobData = JSONLoader.readFrom(filename: "jobsForUser") {
            URLProtocolMock.testURLs[BASEURL.appendingPathComponent(ENDPOINTS.jobsClient.rawValue).appendingPathComponent("\(1)")] = userJobData
            
            URLProtocolMock.testURLs[BASEURL.appendingPathComponent(ENDPOINTS.jobsWasher.rawValue).appendingPathComponent("\(11)")] = userJobData
        }
        
        // Set URLSession to use Mock Protocol
        let testConfig = URLSessionConfiguration.ephemeral
        testConfig.protocolClasses = [URLProtocolMock.self]
        ExpressWash.SESSION = URLSession(configuration: testConfig)
    }

    override func tearDownWithError() throws {
    }

    func testCreateJob() throws {
        let jobRepresentation = JobRepresentation(jobId: jobId, jobLocationLat: jobLocationLat, jobLocationLon: jobLocationLon, washAddress: address, address: address, address2: address2, city: city, state: state, zip: zip, notes: notes, jobType: jobType, completed: completed, paid: paid, scheduled: scheduled, photoBeforeJob: photoBeforeJob, photoAfterJob: photoAfterJob, timeRequested: timeRequested, timeCompleted: timeCompleted, carId: carId, clientId: clientId)
        
        let expect = expectation(description: "Job Created")
        
        jobController.createJob(jobRepresentation: jobRepresentation) { (job, error) in
            if let error = error {
                print("Error: \(error)")
                XCTFail()
                return
            }
            
            guard let job = job else {
                XCTFail()
                return
            }
            
            XCTAssert(job.jobId == self.jobId)
            XCTAssert(job.address == self.address)
            XCTAssert(job.address2 == self.address2)
            XCTAssert(job.jobLocationLat == self.jobLocationLat)
            XCTAssert(job.jobLocationLon == self.jobLocationLon)
            XCTAssert(job.city == self.city)
            XCTAssert(job.state == self.state)
            XCTAssert(job.zip == self.zip)
            XCTAssert(job.notes == self.notes)
            XCTAssert(job.jobType == self.jobType)
            XCTAssert(job.completed == self.completed)
            XCTAssert(job.paid == self.paid)
            XCTAssert(job.scheduled == self.scheduled)
            XCTAssert(job.photoBeforeJob == self.photoBeforeJob)
            XCTAssert(job.photoAfterJob == self.photoAfterJob)
            XCTAssert(job.timeRequested == self.timeRequested)
            XCTAssert(job.timeCompleted == self.timeCompleted)
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testAddJob() throws {
        let jobRepresentation = JobRepresentation(jobId: jobId, jobLocationLat: jobLocationLat, jobLocationLon: jobLocationLon, washAddress: address, address: address, address2: address2, city: city, state: state, zip: zip, notes: notes, jobType: jobType, completed: completed, paid: paid, scheduled: scheduled, photoBeforeJob: photoBeforeJob, photoAfterJob: photoAfterJob, timeRequested: timeRequested, timeCompleted: timeCompleted, carId: carId, clientId: clientId)
        
        let expect = expectation(description: "Job Added")
        
        jobController.addJob(jobRepresentation: jobRepresentation) { (job, error) in
            if let error = error {
                print("Error: \(error)")
                XCTFail()
                return
            }
            
            guard let job = job else {
                XCTFail()
                return
            }
            
            XCTAssert(job.jobId == self.jobId)
            XCTAssert(job.address == self.address)
            XCTAssert(job.address2 == self.address2)
            XCTAssert(job.jobLocationLat == self.jobLocationLat)
            XCTAssert(job.jobLocationLon == self.jobLocationLon)
            XCTAssert(job.city == self.city)
            XCTAssert(job.state == self.state)
            XCTAssert(job.zip == self.zip)
            XCTAssert(job.notes == self.notes)
            XCTAssert(job.jobType == self.jobType)
            XCTAssert(job.completed == self.completed)
            XCTAssert(job.paid == self.paid)
            XCTAssert(job.scheduled == self.scheduled)
            XCTAssert(job.photoBeforeJob == self.photoBeforeJob)
            XCTAssert(job.photoAfterJob == self.photoAfterJob)
            XCTAssert(job.timeRequested == self.timeRequested)
            XCTAssert(job.timeCompleted == self.timeCompleted)
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEditJob() throws {
        
        if let EditData = JSONLoader.readFrom(filename: "EditJob") {
            URLProtocolMock.testURLs[BASEURL.appendingPathComponent("jobs/job/\(jobId)")] = EditData
        }
        
        let jobRepresentation = JobRepresentation(jobId: jobId, jobLocationLat: jobLocationLat, jobLocationLon: jobLocationLon, washAddress: address, address: address, address2: address2, city: city, state: state, zip: zip, notes: notes, jobType: jobType, completed: completed, paid: paid, scheduled: scheduled, photoBeforeJob: photoBeforeJob, photoAfterJob: photoAfterJob, timeRequested: timeRequested, timeCompleted: timeCompleted, carId: carId, clientId: clientId)

        let expect = expectation(description: "Job Edited")

        jobController.editJob(jobRepresentation: jobRepresentation) { (job, error) in
            if let error = error {
                print("Error: \(error)")
                XCTFail()
                return
            }

            guard let job = job else {
                XCTFail()
                return
            }

            XCTAssert(job.jobId == self.jobId)
            XCTAssert(job.address == self.address)
            XCTAssert(job.address2 == self.address2)
            XCTAssert(job.jobLocationLat == self.jobLocationLat)
            XCTAssert(job.jobLocationLon == self.jobLocationLon)
            XCTAssert(job.city == self.city)
            XCTAssert(job.state == self.state)
            XCTAssert(job.zip == self.zip)
            XCTAssert(job.notes == self.notes)
            XCTAssert(job.jobType == self.jobType)
            XCTAssert(job.completed == self.completed)
            XCTAssert(job.paid == self.paid)
            XCTAssert(job.scheduled == self.scheduled)
            XCTAssert(job.photoBeforeJob == self.photoBeforeJob)
            XCTAssert(job.photoAfterJob == self.photoAfterJob)
            XCTAssert(job.timeRequested == self.timeRequested)
            XCTAssert(job.timeCompleted == self.timeCompleted)
            expect.fulfill()
        }

        waitForExpectations(timeout: 15.0, handler: nil)
    }

    func testUpdateJob() throws {
        if let EditData = JSONLoader.readFrom(filename: "EditJob") {
            URLProtocolMock.testURLs[BASEURL.appendingPathComponent("jobs/job/\(jobId)")] = EditData
        }
        
        let jobRepresentation = JobRepresentation(jobId: jobId, jobLocationLat: jobLocationLat, jobLocationLon: jobLocationLon, washAddress: address, address: address, address2: address2, city: city, state: state, zip: zip, notes: notes, jobType: jobType, completed: completed, paid: paid, scheduled: scheduled, photoBeforeJob: photoBeforeJob, photoAfterJob: photoAfterJob, timeRequested: timeRequested, timeCompleted: timeCompleted, carId: carId, clientId: clientId)

        let expect = expectation(description: "Job Edited")

        jobController.updateJob(jobRepresentation: jobRepresentation) { (job, error) in
            if let error = error {
                print("Error: \(error)")
                XCTFail()
                return
            }

            guard let job = job else {
                XCTFail()
                return
            }

            XCTAssert(job.jobId == self.jobId)
            XCTAssert(job.address == self.address)
            XCTAssert(job.address2 == self.address2)
            XCTAssert(job.jobLocationLat == self.jobLocationLat)
            XCTAssert(job.jobLocationLon == self.jobLocationLon)
            XCTAssert(job.city == self.city)
            XCTAssert(job.state == self.state)
            XCTAssert(job.zip == self.zip)
            XCTAssert(job.notes == self.notes)
            XCTAssert(job.jobType == self.jobType)
            XCTAssert(job.completed == self.completed)
            XCTAssert(job.paid == self.paid)
            XCTAssert(job.scheduled == self.scheduled)
            XCTAssert(job.photoBeforeJob == self.photoBeforeJob)
            XCTAssert(job.photoAfterJob == self.photoAfterJob)
            XCTAssert(job.timeRequested == self.timeRequested)
            XCTAssert(job.timeCompleted == self.timeCompleted)
            expect.fulfill()
        }

        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testUpdateJob2() {
        let client = User(accountType: "client", email: "client@email.com", firstName: "Client", lastName: "Client")
        client.userId = Int32(clientId)
        let wUser = User(accountType: "washer", email: "washer@email.com", firstName: "Washer", lastName: "Washer")
        _ = Washer(aboutMe: nil, available: true, currentLocationLat: 0.0, currentLocationLon: 0.0, rateSmall: 35.0, rateMedium: 45.0, rateLarge: 55.0, washerId: Int32(washerId), washerRating: 5.0, washerRatingTotal: 5, user: wUser)
        
        var jobRepresentation = JobRepresentation(jobId: jobId, jobLocationLat: jobLocationLat, jobLocationLon: jobLocationLon, washAddress: address, address: address, address2: address2, city: city, state: state, zip: zip, notes: notes, jobType: jobType, completed: completed, paid: paid, scheduled: scheduled, photoBeforeJob: photoBeforeJob, photoAfterJob: photoAfterJob, timeRequested: timeRequested, timeCompleted: timeCompleted, carId: carId, clientId: clientId)
        
        let job = Job(representation: jobRepresentation)
        jobRepresentation.jobId += 1
        jobController.updateJob(job, with: jobRepresentation) { (job, error) in
            if let error = error {
                print("Error: \(error)")
                XCTFail()
                return
            }
            
            guard let job = job else {
                XCTFail()
                return
            }
            
            XCTAssert(job.jobId == self.jobId + 1)
        }
    }
    
    func testDeleteJob() throws {
        if let DeleteData = JSONLoader.readFrom(filename: "DeleteJob") {
            URLProtocolMock.testURLs[BASEURL.appendingPathComponent("jobs/job/\(jobId)")] = DeleteData
        }
        
        let jobRepresentation = JobRepresentation(jobId: jobId, jobLocationLat: jobLocationLat, jobLocationLon: jobLocationLon, washAddress: address, address: address, address2: address2, city: city, state: state, zip: zip, notes: notes, jobType: jobType, completed: completed, paid: paid, scheduled: scheduled, photoBeforeJob: photoBeforeJob, photoAfterJob: photoAfterJob, timeRequested: timeRequested, timeCompleted: timeCompleted, carId: carId, clientId: clientId)
        
        let expect = expectation(description: "Job Deleted")
        
        let job = Job(representation: jobRepresentation)
        
        jobController.deleteJob(job: job) { (message, error) in
            if let error = error {
                print("Error: \(error)")
                XCTFail()
            }
            
            guard let message = message else {
                XCTFail()
                return
            }
            
            XCTAssert(message == "Job has been deleted")
            expect.fulfill()
        }

        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testJobInfo() throws {
        let jobRepresentation = JobRepresentation(jobId: jobId, jobLocationLat: jobLocationLat, jobLocationLon: jobLocationLon, washAddress: address, address: address, address2: address2, city: city, state: state, zip: zip, notes: notes, jobType: jobType, completed: completed, paid: paid, scheduled: scheduled, photoBeforeJob: photoBeforeJob, photoAfterJob: photoAfterJob, timeRequested: timeRequested, timeCompleted: timeCompleted, carId: carId, clientId: clientId)

        let expect = expectation(description: "Job Info Received")

        jobController.getJobInfo(jobRepresentation: jobRepresentation) { (job, error) in
            if let error = error {
                print("Error: \(error)")
                XCTFail()
                return
            }

            guard let job = job else {
                XCTFail()
                return
            }

            XCTAssert(job.jobId == self.jobId)
            XCTAssert(job.address == self.address)
            XCTAssert(job.address2 == self.address2)
            XCTAssert(job.jobLocationLat == self.jobLocationLat)
            XCTAssert(job.jobLocationLon == self.jobLocationLon)
            XCTAssert(job.city == self.city)
            XCTAssert(job.state == self.state)
            XCTAssert(job.zip == self.zip)
            XCTAssert(job.notes == self.notes)
            XCTAssert(job.jobType == self.jobType)
            XCTAssert(job.completed == self.completed)
            XCTAssert(job.paid == self.paid)
            XCTAssert(job.scheduled == self.scheduled)
            XCTAssert(job.photoBeforeJob == self.photoBeforeJob)
            XCTAssert(job.photoAfterJob == self.photoAfterJob)
            XCTAssert(job.timeRequested == self.timeRequested)
            XCTAssert(job.timeCompleted == self.timeCompleted)
            expect.fulfill()
        }

        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testGetUserJobs() throws {
        let client = User(accountType: "client", email: "client@email.com", firstName: "Client", lastName: "Client")
        client.userId = 1
        
        let expect = expectation(description: "a job is returned")
        jobController.getUserJobs(user: client) { (jobReps, error) in
            if error != nil {
                XCTFail()
            }
            
            guard let jobReps = jobReps else {
                XCTFail()
                return
            }
            
            XCTAssert(jobReps.count == 1)
            XCTAssert(jobReps[0].clientId == client.userId)
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testGetWasherJobs() throws {
        let client = User(accountType: "client", email: "client@email.com", firstName: "Client", lastName: "Client")
        client.userId = 1
        let wUser = User(accountType: "washer", email: "washer@email.com", firstName: "Washer", lastName: "Washer")
        wUser.userId = 2
        let washer = Washer(aboutMe: nil, available: true, currentLocationLat: 0.0, currentLocationLon: 0.0, rateSmall: 35.0, rateMedium: 45.0, rateLarge: 55.0, washerId: 11, washerRating: 5.0, washerRatingTotal: 5, user: wUser)
        
        let expect = expectation(description: "a job is returned")
        jobController.getWasherJobs(washer: washer) { (jobReps, error) in
            if error != nil {
                XCTFail()
            }
            
            guard let jobReps = jobReps else {
                XCTFail()
                return
            }
            
            XCTAssert(jobReps.count == 1)
            XCTAssert(jobReps[0].clientId == client.userId)
            XCTAssert(jobReps[0].washerId == Int(washer.washerId))
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
}
