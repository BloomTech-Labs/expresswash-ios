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
    convenience init(jobID: Int32 = 0,
                     lat: Double,
                     long: Double,
                     address1: String,
                     address2: String? = nil,
                     city: String,
                     state: String,
                     zip: String,
                     notes: String?,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.jobID = jobID
        self.lat = lat
        self.long = long
        self.address1 = address1
        self.address2 = address2
        self.city = city
        self.state = state
        self.zip = zip
        self.notes = notes
    }

    convenience init(representation: JobRepresentation,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.jobID = Int32(representation.jobID)
        self.lat = representation.lat
        self.long = representation.long
        self.address1 = representation.address1
        self.address2 = representation.address2
        self.city = representation.city
        self.state = representation.state
        self.zip = representation.zip
        self.notes = representation.notes
    }

    var representation: JobRepresentation? {
        JobRepresentation(jobID: Int(self.jobID),
                          lat: self.lat,
                          long: self.long,
                          address1: self.address1,
                          address2: self.address2,
                          city: self.city,
                          state: self.state,
                          zip: self.zip,
                          notes: self.notes,
                          type: self.type,
                          photoBeforeJob: self.photoBeforeJob,
                          photoJobComplete: self.photoJobComplete,
                          timeRequested: self.timeRequested ?? Date(),
                          timeComplete: self.timeComplete
        )
    }
}
