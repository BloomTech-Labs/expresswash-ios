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

    @NSManaged public var accountType: String?
    @NSManaged public var bannerImage: URL?
    @NSManaged public var email: String?
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var profileImage: URL?
    @NSManaged public var stripeUUID: String?
    @NSManaged public var streetAddress: String?
    @NSManaged public var streetAddress2: String?
    @NSManaged public var city: String?
    @NSManaged public var state: String?
    @NSManaged public var zip: String?
    @NSManaged public var token: String?
    @NSManaged public var appointments: NSOrderedSet?
    @NSManaged public var cars: NSOrderedSet?
    @NSManaged public var washer: Washer?

}

// MARK: Generated accessors for appointments
extension User {

    @objc(insertObject:inAppointmentsAtIndex:)
    @NSManaged public func insertIntoAppointments(_ value: Appointment, at idx: Int)

    @objc(removeObjectFromAppointmentsAtIndex:)
    @NSManaged public func removeFromAppointments(at idx: Int)

    @objc(insertAppointments:atIndexes:)
    @NSManaged public func insertIntoAppointments(_ values: [Appointment], at indexes: NSIndexSet)

    @objc(removeAppointmentsAtIndexes:)
    @NSManaged public func removeFromAppointments(at indexes: NSIndexSet)

    @objc(replaceObjectInAppointmentsAtIndex:withObject:)
    @NSManaged public func replaceAppointments(at idx: Int, with value: Appointment)

    @objc(replaceAppointmentsAtIndexes:withAppointments:)
    @NSManaged public func replaceAppointments(at indexes: NSIndexSet, with values: [Appointment])

    @objc(addAppointmentsObject:)
    @NSManaged public func addToAppointments(_ value: Appointment)

    @objc(removeAppointmentsObject:)
    @NSManaged public func removeFromAppointments(_ value: Appointment)

    @objc(addAppointments:)
    @NSManaged public func addToAppointments(_ values: NSOrderedSet)

    @objc(removeAppointments:)
    @NSManaged public func removeFromAppointments(_ values: NSOrderedSet)

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
