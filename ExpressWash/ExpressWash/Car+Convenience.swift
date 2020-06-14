//
//  Car+Convenience.swift
//  ExpressWash
//
//  Created by Joel Groomer on 4/21/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import Foundation
import CoreData

enum CarSize: String {
    case small
    case medium
    case large
}

extension Car {
    convenience init(carId: Int32 = 0,
                     clientId: Int,
                     make: String,
                     model: String,
                     year: Int16,
                     color: String,
                     licensePlate: String,
                     photo: String?,
                     category: String,
                     size: String,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.carId = carId
        self.clientId = Int16(clientId)
        self.make = make
        self.model = model
        self.year = year
        self.color = color
        self.licensePlate = licensePlate
        self.photo = photo
        self.category = category
        self.size = size
    }

    convenience init(representation: CarRepresentation,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.carId = Int32(representation.carId ?? NOID)
        self.clientId = Int16(representation.clientId)
        self.make = representation.make
        self.model = representation.model
        self.year = representation.year
        self.color = representation.color
        self.licensePlate = representation.licensePlate
        self.photo = representation.photo
        self.category = representation.category
        self.size = representation.size
    }

    var representation: CarRepresentation? {
        CarRepresentation(carId: Int(self.carId),
                          clientId: Int(self.clientId),
                          make: self.make,
                          model: self.model,
                          year: self.year,
                          color: self.color,
                          licensePlate: self.licensePlate,
                          photo: self.photo,
                          category: self.category,
                          size: self.size)
    }
}
