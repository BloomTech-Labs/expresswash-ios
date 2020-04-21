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

    @NSManaged public var color: String?
    @NSManaged public var id: Int32
    @NSManaged public var licensePlate: String?
    @NSManaged public var make: String?
    @NSManaged public var model: String?
    @NSManaged public var photo: URL?
    @NSManaged public var year: Int16
    @NSManaged public var appointments: NSSet?
    @NSManaged public var owner: User?

}

// MARK: Generated accessors for appointments
extension Car {

    @objc(addAppointmentsObject:)
    @NSManaged public func addToAppointments(_ value: Appointment)

    @objc(removeAppointmentsObject:)
    @NSManaged public func removeFromAppointments(_ value: Appointment)

    @objc(addAppointments:)
    @NSManaged public func addToAppointments(_ values: NSSet)

    @objc(removeAppointments:)
    @NSManaged public func removeFromAppointments(_ values: NSSet)

}
