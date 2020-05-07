//
//  WasherRepresentation.swift
//  ExpressWash
//
//  Created by Joel Groomer on 5/6/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import Foundation

struct WasherRepresentation: Codable {
    var aboutMe: String?
    var available: Bool
    var currentLocationLat: Double
    var currentLocationLon: Double
    var rateSmall: Double
    var rateMedium: Double
    var rateLarge: Double
    var washerId: Int
    var washerRating: Int
    var washerRatingTotal: Int
    var userId: Int

    init(aboutMe: String?,
         available: Bool,
         currentLocationLat: Double,
         currentLocationLon: Double,
         rateSmall: Double,
         rateMedium: Double,
         rateLarge: Double,
         washerId: Int,
         washerRating: Int,
         washerRatingTotal: Int,
         userId: Int) {
        self.aboutMe = aboutMe
        self.available = available
        self.currentLocationLat = currentLocationLat
        self.currentLocationLon = currentLocationLon
        self.rateSmall = rateSmall
        self.rateMedium = rateMedium
        self.rateLarge = rateLarge
        self.washerId = washerId
        self.washerRating = washerRating
        self.washerRatingTotal = washerRatingTotal
        self.userId = userId
    }

}
