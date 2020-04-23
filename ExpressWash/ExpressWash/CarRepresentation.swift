//
//  CarRepresentation.swift
//  ExpressWash
//
//  Created by Joel Groomer on 4/21/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import Foundation

struct CarRepresentation: Codable {
    var id: Int
    var make: String
    var model: String
    var year: Int16
    var color: String
    var licensePlate: String
    var photo: URL?
    
    init(id: Int = 0,
         make: String,
         model: String,
         year: Int16,
         color: String,
         licensePlate: String,
         photo: URL?) {
        self.id = id
        self.make = make
        self.model = model
        self.year = year
        self.color = color
        self.licensePlate = licensePlate
        self.photo = photo
    }
    
}
