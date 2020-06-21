//
//  JobRepresentation.swift
//  ExpressWash
//
//  Created by Joel Groomer on 4/20/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import Foundation
import CoreLocation

struct JobRepresentation: Codable {
    var washAddress: String
    var address: String
    var address2: String?
    var carId: Int
    var city: String
    var clientId: Int
    var completed: Bool
    var jobId: Int
    var jobLocationLat: Double
    var jobLocationLon: Double
    var jobType: String
    var notes: String?
    var paid: Bool
    var photoBeforeJob: String?
    var photoAfterJob: String?
    var scheduled: Bool
    var state: String
    var timeRequested: String
    var timeCompleted: String?
    var washerId: Int?
    var zip: String
    var creationDate: String?
    var timeArrived: String?

    init(jobId: Int = 0,
         jobLocationLat: Double,
         jobLocationLon: Double,
         washAddress: String,
         address: String,
         address2: String?,
         city: String,
         state: String,
         zip: String,
         notes: String?,
         jobType: String,
         completed: Bool = false,
         paid: Bool = false,
         scheduled: Bool = true,
         photoBeforeJob: String? = nil,
         photoAfterJob: String? = nil,
         timeRequested: String,
         timeCompleted: String? = nil,
         carId: Int,
         clientId: Int,
         washerId: Int? = nil,
         creationDate: String? = nil,
         timeArrived: String? = nil) {
        self.washAddress = washAddress
        self.address = address
        self.address2 = address2
        self.carId = carId
        self.city = city
        self.clientId = clientId
        self.completed = completed
        self.jobId = jobId
        self.jobLocationLat = jobLocationLat
        self.jobLocationLon = jobLocationLon
        self.jobType = jobType
        self.notes = notes
        self.paid = paid
        self.photoBeforeJob = photoBeforeJob
        self.photoAfterJob = photoAfterJob
        self.scheduled = scheduled
        self.state = state
        self.timeRequested = timeRequested
        self.timeCompleted = timeCompleted
        self.washerId = washerId
        self.zip = zip
        self.creationDate = creationDate
        self.timeArrived = timeArrived
    }

    enum JobKeys: String, CodingKey {
        case washAddress
        case address
        case address2
        case carId
        case city
        case clientId
        case completed
        case jobId
        case jobLocationLat
        case jobLocationLon
        case jobType
        case notes
        case paid
        case photoBeforeJob
        case photoAfterJob
        case scheduled
        case state
        case timeRequested
        case timeCompleted
        case washerId
        case zip
        case creationDate
        case timeArrived
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: JobKeys.self)

        jobId           = try container.decode(Int.self, forKey: .jobId)
        scheduled       = try container.decode(Bool.self, forKey: .scheduled)
        completed       = try container.decode(Bool.self, forKey: .completed)
        paid            = try container.decode(Bool.self, forKey: .paid)
        washAddress     = try container.decode(String.self, forKey: .washAddress)
        address         = try container.decode(String.self, forKey: .address)
        address2        = try container.decodeIfPresent(String.self, forKey: .address2)

        jobLocationLat  = try container.decodeIfPresent(Double.self, forKey: .jobLocationLat) ??
            kCLLocationCoordinate2DInvalid.latitude
        jobLocationLon  = try container.decodeIfPresent(Double.self, forKey: .jobLocationLon) ??
            kCLLocationCoordinate2DInvalid.longitude

        city            = try container.decode(String.self, forKey: .city)
        state           = try container.decode(String.self, forKey: .state)
        zip             = try container.decode(String.self, forKey: .zip)
        notes           = try container.decodeIfPresent(String.self, forKey: .notes)
        jobType         = try container.decode(String.self, forKey: .jobType)
        photoBeforeJob  = try container.decodeIfPresent(String.self, forKey: .photoBeforeJob)
        photoAfterJob   = try container.decodeIfPresent(String.self, forKey: .photoAfterJob)
        timeRequested   = try container.decode(String.self, forKey: .timeRequested)
        timeCompleted   = try container.decodeIfPresent(String.self, forKey: .timeCompleted)
        carId           = try container.decode(Int.self, forKey: .carId)
        clientId        = try container.decode(Int.self, forKey: .clientId)
        washerId        = try container.decodeIfPresent(Int.self, forKey: .washerId)
        creationDate    = try container.decodeIfPresent(String.self, forKey: .creationDate)
        timeArrived     = try container.decodeIfPresent(String.self, forKey: .timeArrived)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: JobKeys.self)

        try container.encode(scheduled, forKey: .scheduled)
        try container.encode(completed, forKey: .completed)
        try container.encode(paid, forKey: .paid)
        try container.encode(washAddress, forKey: .washAddress)
        try container.encode(address, forKey: .address)
        if let address2 = address2 {
            try container.encode(address2, forKey: .address2)
        }
        try container.encode(jobLocationLat, forKey: .jobLocationLat)
        try container.encode(jobLocationLon, forKey: .jobLocationLon)
        try container.encode(city, forKey: .city)
        try container.encode(state, forKey: .state)
        try container.encode(zip, forKey: .zip)
        if let notes = notes {
            try container.encode(notes, forKey: .notes)
        }
        try container.encode(jobType, forKey: .jobType)
        try container.encode(photoBeforeJob, forKey: .photoBeforeJob)
        try container.encode(photoAfterJob, forKey: .photoAfterJob)
        try container.encode(timeRequested, forKey: .timeRequested)
        if let timeCompleted = timeCompleted {
            try container.encode(timeCompleted, forKey: .timeCompleted)
        }
        try container.encode(carId, forKey: .carId)
        try container.encode(clientId, forKey: .clientId)
        try container.encode(washerId, forKey: .washerId)
        if let creationDate = creationDate {
            try container.encode(creationDate, forKey: .creationDate)
        }
        try container.encode(timeArrived, forKey: .timeArrived)
        if let washerId = washerId {
            try container.encode(washerId, forKey: .washerId)
        }
    }
}
