//
//  CarRepresentation.swift
//  ExpressWash
//
//  Created by Joel Groomer on 4/21/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import Foundation

struct CarRepresentation: Codable {

    var userId: Int
    var carId: Int?
    var make: String
    var model: String
    var year: Int16
    var color: String
    var licensePlate: String
    var photo: URL?
    var size: String

    init(userId: Int,
         carId: Int?,
         make: String,
         model: String,
         year: Int16,
         color: String,
         licensePlate: String,
         photo: URL?,
         size: String) {
        self.userId = userId
        self.carId = carId
        self.make = make
        self.model = model
        self.year = year
        self.color = color
        self.licensePlate = licensePlate
        self.photo = photo
        self.size = size
    }
}
