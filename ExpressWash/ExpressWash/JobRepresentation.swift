//
//  JobRepresentation.swift
//  ExpressWash
//
//  Created by Joel Groomer on 4/20/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import Foundation

struct JobRepresentation: Codable {
    var address: String
    var address2: String?
    var city: String
    var completed: Bool
    var jobId: Int
    var jobLocationLat: Double
    var jobLocationLon: Double
    var jobType: String
    var notes: String?
    var paid: Bool
    var photoBeforeJob: URL?
    var photoAfterJob: URL?
    var scheduled: Bool
    var state: String
    var timeRequested: Date
    var timeCompleted: Date?
    var zip: String

    init(jobId: Int = 0,
         jobLocationLat: Double,
         jobLocationLon: Double,
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
         photoBeforeJob: URL? = nil,
         photoAfterJob: URL? = nil,
         timeRequested: Date = Date(),
         timeCompleted: Date? = nil) {
        self.address = address
        self.address2 = address2
        self.city = city
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
        self.zip = zip
    }

    enum JobKeys: String, CodingKey {
        case address
        case address2
        case city
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
        case zip
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: JobKeys.self)

        address         = try container.decode(String.self, forKey: .address)
        address2        = try container.decodeIfPresent(String.self, forKey: .address2)
        city            = try container.decode(String.self, forKey: .city)
        completed       = try container.decode(Bool.self, forKey: .completed)
        jobId           = try container.decode(Int.self, forKey: .jobId)
        jobLocationLat  = try container.decode(Double.self, forKey: .jobLocationLat)
        jobLocationLon  = try container.decode(Double.self, forKey: .jobLocationLon)
        jobType         = try container.decode(String.self, forKey: .jobType)
        notes           = try container.decodeIfPresent(String.self, forKey: .notes)
        paid            = try container.decode(Bool.self, forKey: .paid)
        photoBeforeJob  = try container.decodeIfPresent(URL.self, forKey: .photoBeforeJob)
        photoAfterJob   = try container.decodeIfPresent(URL.self, forKey: .photoAfterJob)
        scheduled       = try container.decode(Bool.self, forKey: .scheduled)
        state           = try container.decode(String.self, forKey: .state)
        timeRequested   = try container.decode(Date.self, forKey: .timeRequested)
        timeCompleted   = try container.decodeIfPresent(Date.self, forKey: .timeCompleted)
        zip             = try container.decode(String.self, forKey: .zip)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: JobKeys.self)

        try container.encode(address, forKey: .address)
        if let address2 = address2 {
            try container.encode(address2, forKey: .address2)
        }
        try container.encode(city, forKey: .city)
        try container.encode(completed, forKey: .completed)
        try container.encode(jobId, forKey: .jobId)
        try container.encode(jobLocationLat, forKey: .jobLocationLat)
        try container.encode(jobLocationLon, forKey: .jobLocationLon)
        try container.encode(jobType, forKey: .jobType)
        if let notes = notes {
            try container.encode(notes, forKey: .notes)
        }
        try container.encode(paid, forKey: .paid)
        try container.encode(photoBeforeJob, forKey: .photoBeforeJob)
        try container.encode(photoAfterJob, forKey: .photoAfterJob)
        try container.encode(scheduled, forKey: .scheduled)
        try container.encode(state, forKey: .state)
        try container.encode(timeRequested, forKey: .timeRequested)
        if let timeCompleted = timeCompleted {
            try container.encode(timeCompleted, forKey: .timeCompleted)
        }
        try container.encode(zip, forKey: .zip)
    }
}
