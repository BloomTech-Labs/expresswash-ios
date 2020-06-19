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
    var workStatus: Bool
    var currentLocationLat: Double?
    var currentLocationLon: Double?
    var rateSmall: Double?
    var rateMedium: Double          // this is the only required rate on the back-end
    var rateLarge: Double?
    var washerId: Int
    var washerRating: Float?
    var washerRatingTotal: Int
    var userId: Int

    init(aboutMe: String?,
         available: Bool,
         currentLocationLat: Double?,
         currentLocationLon: Double?,
         rateSmall: Double,
         rateMedium: Double,
         rateLarge: Double,
         washerId: Int,
         washerRating: Float?,
         washerRatingTotal: Int,
         userId: Int) {
        self.aboutMe = aboutMe
        self.workStatus = available
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
