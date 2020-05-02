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

    @NSManaged public var address1: String
    @NSManaged public var address2: String?
    @NSManaged public var city: String
    @NSManaged public var jobID: Int32
    @NSManaged public var lat: Double
    @NSManaged public var long: Double
    @NSManaged public var notes: String?
    @NSManaged public var photoBeforeJob: URL?
    @NSManaged public var photoJobComplete: URL?
    @NSManaged public var state: String
    @NSManaged public var timeComplete: Date?
    @NSManaged public var timeRequested: Date?
    @NSManaged public var type: String
    @NSManaged public var zip: String
    @NSManaged public var car: Car
    @NSManaged public var client: User
    @NSManaged public var washer: Washer

}
