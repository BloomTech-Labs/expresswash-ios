//
//  Job+Convenience.swift
//  ExpressWash
//
//  Created by Joel Groomer on 4/20/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import Foundation
import CoreData

extension Job {
    convenience init(jobId: Int32 = 0,
                     jobLocationLat: Float,
                     jobLocationLon: Float,
                     address: String,
                     address2: String? = nil,
                     city: String,
                     state: String,
                     zip: String,
                     notes: String? = nil,
                     completed: Bool = false,
                     jobType: String,
                     paid: Bool = false,
                     photoBeforeJob: String? = nil,
                     photoAfterJob: String? = nil,
                     scheduled: Bool = true,
                     timeCompleted: String? = nil,
                     timeRequested: String,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.jobId = jobId
        self.jobLocationLat = jobLocationLat
        self.jobLocationLon = jobLocationLon
        self.address = address
        self.address2 = address2
        self.city = city
        self.state = state
        self.zip = zip
        self.notes = notes
        self.completed = completed
        self.jobType = jobType
        self.paid = paid
        self.photoBeforeJob = photoBeforeJob
        self.photoAfterJob = photoAfterJob
        self.scheduled = scheduled
        self.timeCompleted = timeCompleted
        self.timeRequested = timeRequested
    }

    convenience init(representation: JobRepresentation,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.jobId = Int32(representation.jobId)
        self.jobLocationLat = representation.jobLocationLat
        self.jobLocationLon = representation.jobLocationLon
        self.address = representation.address
        self.address2 = representation.address2
        self.city = representation.city
        self.state = representation.state
        self.zip = representation.zip
        self.notes = representation.notes
        self.completed = representation.completed
        self.jobType = representation.jobType
        self.paid = representation.paid
        self.photoBeforeJob = representation.photoBeforeJob
        self.photoAfterJob = representation.photoAfterJob
        self.scheduled = representation.scheduled
        self.timeCompleted = representation.timeCompleted
        self.timeRequested = representation.timeRequested
    }

    var representation: JobRepresentation? {
        JobRepresentation(jobId: Int(self.jobId),
                          jobLocationLat: self.jobLocationLat,
                          jobLocationLon: self.jobLocationLon,
                          address: self.address,
                          address2: self.address2,
                          city: self.city,
                          state: self.state,
                          zip: self.zip,
                          notes: self.notes,
                          jobType: self.jobType,
                          completed: self.completed,
                          paid: self.paid,
                          scheduled: self.scheduled,
                          photoBeforeJob: self.photoBeforeJob,
                          photoAfterJob: self.photoAfterJob,
                          timeRequested: self.timeRequested,
                          timeCompleted: self.timeCompleted
        )
    }
}
