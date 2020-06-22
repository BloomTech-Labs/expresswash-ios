//
//  Washer+Convenience.swift
//  ExpressWash
//
//  Created by Joel Groomer on 5/6/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

extension Washer {
    convenience init(aboutMe: String?,
                     available: Bool = false,
                     currentLocationLat: Double,
                     currentLocationLon: Double,
                     rateSmall: Double,
                     rateMedium: Double,
                     rateLarge: Double,
                     washerId: Int32,
                     washerRating: Float,
                     washerRatingTotal: Int16,
                     user: User,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
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
        self.user = user
    }

    convenience init(representation: WasherRepresentation,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.aboutMe = representation.aboutMe
        self.workStatus = representation.workStatus
        self.currentLocationLat = representation.currentLocationLat ?? kCLLocationCoordinate2DInvalid.latitude
        self.currentLocationLon = representation.currentLocationLon ?? kCLLocationCoordinate2DInvalid.longitude
        self.rateSmall = representation.rateSmall ?? representation.rateMedium
        self.rateMedium = representation.rateMedium
        self.rateLarge = representation.rateLarge ?? representation.rateMedium
        self.washerId = Int32(representation.washerId)
        self.washerRating = representation.washerRating ?? 0.0
        self.washerRatingTotal = Int16(representation.washerRatingTotal)
        self.user = UserController.shared.findUser(byID: representation.userId)
    }

    var representation: WasherRepresentation {
        WasherRepresentation(aboutMe: self.aboutMe,
                             available: self.workStatus,
                             currentLocationLat: self.currentLocationLat,
                             currentLocationLon: self.currentLocationLon,
                             rateSmall: self.rateSmall,
                             rateMedium: self.rateMedium,
                             rateLarge: self.rateLarge,
                             washerId: Int(self.washerId),
                             washerRating: self.washerRating,
                             washerRatingTotal: Int(self.washerRatingTotal),
                             userId: Int(self.user?.userId ?? NOID32))
    }

    var stringID: String {
        String(self.washerId)
    }
}
