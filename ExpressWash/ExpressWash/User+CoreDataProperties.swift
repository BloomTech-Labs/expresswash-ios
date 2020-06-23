//
//  User+CoreDataProperties.swift
//  ExpressWash
//
//  Created by Joel Groomer on 4/20/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//
//

import Foundation
import CoreData

extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var accountType: String
    @NSManaged public var bannerImage: URL?
    @NSManaged public var email: String
    @NSManaged public var firstName: String
    @NSManaged public var lastName: String
    @NSManaged public var phoneNumber: String?
    @NSManaged public var profilePicture: URL?
    @NSManaged public var stripeUUID: String?
    @NSManaged public var userId: Int32
    @NSManaged public var userRating: Float
    @NSManaged public var userRatingTotal: Int16
    @NSManaged public var streetAddress: String?
    @NSManaged public var streetAddress2: String?
    @NSManaged public var city: String?
    @NSManaged public var state: String?
    @NSManaged public var zip: String?
    @NSManaged public var token: String?
    @NSManaged public var jobs: NSOrderedSet?
    @NSManaged public var cars: NSSet?
    @NSManaged public var washer: Washer?

    public var carsArray: [Car] {
        let set = cars as? Set<Car> ?? []
        return set.sorted { (car1, car2) -> Bool in
            car1.carId > car2.carId
        }
    }
}

// MARK: Generated accessors for jobs
extension User {

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

// MARK: Generated accessors for cars
extension User {

    @objc(insertObject:inCarsAtIndex:)
    @NSManaged public func insertIntoCars(_ value: Car, at idx: Int)

    @objc(removeObjectFromCarsAtIndex:)
    @NSManaged public func removeFromCars(at idx: Int)

    @objc(insertCars:atIndexes:)
    @NSManaged public func insertIntoCars(_ values: [Car], at indexes: NSIndexSet)

    @objc(removeCarsAtIndexes:)
    @NSManaged public func removeFromCars(at indexes: NSIndexSet)

    @objc(replaceObjectInCarsAtIndex:withObject:)
    @NSManaged public func replaceCars(at idx: Int, with value: Car)

    @objc(replaceCarsAtIndexes:withCars:)
    @NSManaged public func replaceCars(at indexes: NSIndexSet, with values: [Car])

    @objc(addCarsObject:)
    @NSManaged public func addToCars(_ value: Car)

    @objc(removeCarsObject:)
    @NSManaged public func removeFromCars(_ value: Car)

    @objc(addCars:)
    @NSManaged public func addToCars(_ values: NSOrderedSet)

    @objc(removeCars:)
    @NSManaged public func removeFromCars(_ values: NSOrderedSet)

}
