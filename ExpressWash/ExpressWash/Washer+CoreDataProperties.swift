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
    @NSManaged public var available: Bool
    @NSManaged public var lat: Double
    @NSManaged public var long: Double
    @NSManaged public var rate: Double
    @NSManaged public var appointments: NSOrderedSet?
    @NSManaged public var user: User?

}

// MARK: Generated accessors for appointments
extension Washer {

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
