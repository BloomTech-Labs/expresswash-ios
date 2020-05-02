//
//  JobRepresentation.swift
//  ExpressWash
//
//  Created by Joel Groomer on 4/20/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import Foundation

struct JobRepresentation: Codable {
    var jobID: Int
    var lat: Double
    var long: Double
    var address1: String
    var address2: String?
    var city: String
    var state: String
    var zip: String
    var notes: String?
    var type: String
    var photoBeforeJob: URL?
    var photoJobComplete: URL?
    var timeRequested: Date = Date()
    var timeComplete: Date?

    init(jobID: Int = 0,
         lat: Double,
         long: Double,
         address1: String,
         address2: String?,
         city: String,
         state: String,
         zip: String,
         notes: String?,
         type: String,
         photoBeforeJob: URL?,
         photoJobComplete: URL?,
         timeRequested: Date = Date(),
         timeComplete: Date?) {
        self.jobID = jobID
        self.lat = lat
        self.long = long
        self.address1 = address1
        self.address2 = address2
        self.city = city
        self.state = state
        self.zip = zip
        self.notes = notes
        self.type = type
        self.photoBeforeJob = photoBeforeJob
        self.photoJobComplete = photoJobComplete
        self.timeRequested = timeRequested
        self.timeComplete = timeComplete
    }

    enum JobKeys: String, CodingKey {
        case jobID = "id"
        case jobLocation
        case type
        case photoBeforeJob
        case photoJobComplete
        case timeRequested
        case timeComplete
    }

    enum JobLocationKeys: String, CodingKey {
        case lat
        case long
        case address1
        case address2
        case city
        case state
        case zip
        case notes
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: JobKeys.self)

        jobID               = try container.decode(Int.self, forKey: .jobID)
        type                = try container.decode(String.self, forKey: .type)
        photoBeforeJob      = try container.decodeIfPresent(URL.self, forKey: .photoBeforeJob)
        photoJobComplete    = try container.decodeIfPresent(URL.self, forKey: .photoJobComplete)
        timeRequested       = try container.decode(Date.self, forKey: .timeRequested)
        timeComplete        = try container.decodeIfPresent(Date.self, forKey: .timeComplete)

        let jobLocationContainer = try container.nestedContainer(keyedBy: JobLocationKeys.self, forKey: .jobLocation)

        lat         = try jobLocationContainer.decode(Double.self, forKey: .lat)
        long        = try jobLocationContainer.decode(Double.self, forKey: .long)
        address1    = try jobLocationContainer.decode(String.self, forKey: .address1)
        address2    = try jobLocationContainer.decodeIfPresent(String.self, forKey: .address2)
        city        = try jobLocationContainer.decode(String.self, forKey: .city)
        state       = try jobLocationContainer.decode(String.self, forKey: .state)
        zip         = try jobLocationContainer.decode(String.self, forKey: .zip)
        notes       = try jobLocationContainer.decodeIfPresent(String.self, forKey: .notes)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: JobKeys.self)

        try container.encode(jobID, forKey: .jobID)
        try container.encode(type, forKey: .type)
        try container.encode(photoBeforeJob, forKey: .photoBeforeJob)
        try container.encode(photoJobComplete, forKey: .photoJobComplete)
        try container.encode(timeRequested, forKey: .timeRequested)
        if let timeComplete = timeComplete {
            try container.encode(timeComplete, forKey: .timeComplete)
        }

        var jobLocationContainer = container.nestedContainer(keyedBy: JobLocationKeys.self, forKey: .jobLocation)

        try jobLocationContainer.encode(lat, forKey: .lat)
        try jobLocationContainer.encode(long, forKey: .long)
        try jobLocationContainer.encode(address1, forKey: .address1)
        if let address2 = address2 {
            try jobLocationContainer.encode(address2, forKey: .address2)
        }
        try jobLocationContainer.encode(city, forKey: .city)
        try jobLocationContainer.encode(state, forKey: .state)
        try jobLocationContainer.encode(zip, forKey: .zip)
        if let notes = notes {
            try jobLocationContainer.encode(notes, forKey: .notes)
        }
    }
}
