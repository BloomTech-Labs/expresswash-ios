//
//  CarRepresentation.swift
//  ExpressWash
//
//  Created by Joel Groomer on 4/21/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import Foundation

struct CarRepresentation: Codable {

    var carId: Int?
    var clientId: Int
    var make: String
    var model: String
    var year: Int16
    var color: String
    var licensePlate: String
    var photo: String?
    var category: String
    var size: String

    init(carId: Int?,
         clientId: Int,
         make: String,
         model: String,
         year: Int16,
         color: String,
         licensePlate: String,
         photo: String?,
         category: String,
         size: String) {
        self.carId = carId
        self.clientId = clientId
        self.make = make
        self.model = model
        self.year = year
        self.color = color
        self.licensePlate = licensePlate
        self.photo = photo
        self.category = category
        self.size = size
    }
}
