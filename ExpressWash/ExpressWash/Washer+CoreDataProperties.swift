//
//  Washer+CoreDataProperties.swift
//  ExpressWash
//
//  Created by Joel Groomer on 4/20/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//
//

import Foundation
import CoreData

extension Washer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Washer> {
        return NSFetchRequest<Washer>(entityName: "Washer")
    }

    @NSManaged public var aboutMe: String?
    @NSManaged public var workStatus: Bool
    @NSManaged public var currentLocationLat: Double
    @NSManaged public var currentLocationLon: Double
    @NSManaged public var rateSmall: Double
    @NSManaged public var rateMedium: Double
    @NSManaged public var rateLarge: Double
    @NSManaged public var washerId: Int32
    @NSManaged public var washerRating: Float
    @NSManaged public var washerRatingTotal: Int16
    @NSManaged public var jobs: NSOrderedSet?
    @NSManaged public var user: User?

}

// MARK: Generated accessors for jobs
extension Washer {

    @objc(insertObject:inJobsAtIndex:)
    @NSManaged public func insertIntoJobs(_ value: Job, at idx: Int)

    @objc(removeObjectFromJobsAtIndex:)
    @NSManaged public func removeFromJobs(at idx: Int)

    @objc(insertJobs:atIndexes:)
    @NSManaged public func insertIntoJobs(_ values: [Job], at indexes: NSIndexSet)

    @objc(removeJobsAtIndexes:)
    @NSManaged public func removeFromJobs(at indexes: NSIndexSet)

    @objc(replaceObjectInJobsAtIndex:withObject:)
    @NSManaged public func replaceJobs(at idx: Int, with value: Job)

    @objc(replaceJobsAtIndexes:withJobs:)
    @NSManaged public func replaceJobs(at indexes: NSIndexSet, with values: [Job])

    @objc(addJobsObject:)
    @NSManaged public func addToJobs(_ value: Job)

    @objc(removeJobsObject:)
    @NSManaged public func removeFromJobs(_ value: Job)

    @objc(addJobs:)
    @NSManaged public func addToJobs(_ values: NSOrderedSet)

    @objc(removeJobs:)
    @NSManaged public func removeFromJobs(_ values: NSOrderedSet)

}
