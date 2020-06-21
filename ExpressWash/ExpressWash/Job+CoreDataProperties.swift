//
//  Job+CoreDataProperties.swift
//  ExpressWash
//
//  Created by Joel Groomer on 4/20/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//
//

import Foundation
import CoreData

extension Job {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Job> {
        return NSFetchRequest<Job>(entityName: "Job")
    }

    // Attributes
    @NSManaged public var washAddress: String
    @NSManaged public var address: String
    @NSManaged public var address2: String?
    @NSManaged public var city: String
    @NSManaged public var completed: Bool
    @NSManaged public var jobId: Int32
    @NSManaged public var jobLocationLat: Double
    @NSManaged public var jobLocationLon: Double
    @NSManaged public var jobType: String
    @NSManaged public var notes: String?
    @NSManaged public var paid: Bool
    @NSManaged public var photoBeforeJob: String?
    @NSManaged public var photoAfterJob: String?
    @NSManaged public var scheduled: Bool
    @NSManaged public var state: String
    @NSManaged public var timeCompleted: String?
    @NSManaged public var timeRequested: String
    @NSManaged public var zip: String
    @NSManaged public var creationDate: String?
    @NSManaged public var timeArrived: String?

    // Relationships
    @NSManaged public var car: Car?
    @NSManaged public var client: User?
    @NSManaged public var washer: Washer?

}
