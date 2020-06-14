//
//  Car+CoreDataProperties.swift
//  ExpressWash
//
//  Created by Joel Groomer on 4/20/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//
//

import Foundation
import CoreData

extension Car {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Car> {
        return NSFetchRequest<Car>(entityName: "Car")
    }

    @NSManaged public var color: String
    @NSManaged public var carId: Int32
    @NSManaged public var clientId: Int16
    @NSManaged public var licensePlate: String
    @NSManaged public var make: String
    @NSManaged public var model: String
    @NSManaged public var photo: String?
    @NSManaged public var size: String
    @NSManaged public var year: Int16
    @NSManaged public var jobs: NSSet?
    @NSManaged public var owner: User?
    @NSManaged public var category: String

}

// MARK: Generated accessors for jobs
extension Car {

    @objc(addJobsObject:)
    @NSManaged public func addToJobs(_ value: Job)

    @objc(removeJobsObject:)
    @NSManaged public func removeFromJobs(_ value: Job)

    @objc(addJobs:)
    @NSManaged public func addToJobs(_ values: NSSet)

    @objc(removeJobs:)
    @NSManaged public func removeFromJobs(_ values: NSSet)

}
