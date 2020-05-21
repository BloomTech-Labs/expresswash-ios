//
//  JobTests.swift
//  ExpressWashTests
//
//  Created by Bobby Keffury on 5/20/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import XCTest
@testable import ExpressWash

class JobTests: XCTestCase {

    override func setUpWithError() throws {
        // test data
        if let JobData = JSONLoader.readFrom(filename: "Job") {
            URLProtocolMock.testURLs[BASEURL.appendingPathComponent(ENDPOINTS.jobNew.rawValue)] = JobData
            
            URLProtocolMock.testURLs[BASEURL.appendingPathComponent(ENDPOINTS.jobInfo.rawValue)] = JobData
            
            URLProtocolMock.testURLs[BASEURL.appendingPathComponent(ENDPOINTS.jobSelect.rawValue)] = JobData
            
            URLProtocolMock.testURLs[BASEURL.appendingPathComponent(ENDPOINTS.jobRevise.rawValue)] = JobData
            
            URLProtocolMock.testURLs[BASEURL.appendingPathComponent(ENDPOINTS.jobGet.rawValue)] = JobData
        }
        
        // Set URLSession to use Mock Protocol
        let testConfig = URLSessionConfiguration.ephemeral
        testConfig.protocolClasses = [URLProtocolMock.self]
        ExpressWash.SESSION = URLSession(configuration: testConfig)
    }

    override func tearDownWithError() throws {
    }

    func testCreateJob() throws {
        
    }
    
    func testAddJob() throws {
        
    }
    
    func testEditJob() throws {
        
    }
    
    func testUpdateJob() throws {
        
    }
    
    func testDeleteJob() throws {
        
    }
    
    func testJobInfo() throws {
    }
    
    func testGetUserJob() throws {
        
    }
    
    func testAssignJob() throws {
        
    }
}
