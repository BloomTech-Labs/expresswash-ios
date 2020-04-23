//
//  Car+Convenience.swift
//  ExpressWash
//
//  Created by Joel Groomer on 4/21/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import Foundation
import CoreData

extension Car {
    convenience init(id: Int32 = 0,
                     make: String,
                     model: String,
                     year: Int16,
                     color: String,
                     licensePlate: String,
                     photo: URL?,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.id = id
        self.make = make
        self.model = model
        self.year = year
        self.color = color
        self.licensePlate = licensePlate
        self.photo = photo
    }
    
    convenience init(representation: CarRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.id = Int32(representation.id)
        self.make = representation.make
        self.model = representation.model
        self.year = representation.year
        self.color = representation.color
        self.licensePlate = representation.licensePlate
        self.photo = representation.photo
    }
    
    var representation: CarRepresentation? {
        CarRepresentation(id: Int(self.id), make: self.make, model: self.model, year: self.year, color: self.color, licensePlate: self.licensePlate, photo: self.photo)
    }
}
