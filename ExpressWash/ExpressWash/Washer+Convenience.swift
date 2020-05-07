//
//  Washer+Convenience.swift
//  ExpressWash
//
//  Created by Joel Groomer on 5/6/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import Foundation
import CoreData

extension Washer {
    convenience init(aboutMe: String?,
                     available: Bool = false,
                     currentLocationLat: Double,
                     currentLocationLon: Double,
                     rateSmall: Double,
                     rateMedium: Double,
                     rateLarge: Double,
                     washerId: Int32,
                     washerRating: Int16,
                     washerRatingTotal: Int16,
                     user: User,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
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
        self.user = user
    }
    convenience init(representation: WasherRepresentation,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.aboutMe = representation.aboutMe
        self.available = representation.available
        self.currentLocationLat = representation.currentLocationLat
        self.currentLocationLon = representation.currentLocationLon
        self.rateSmall = representation.rateSmall
        self.rateMedium = representation.rateMedium
        self.rateLarge = representation.rateLarge
        self.washerId = Int32(representation.washerId)
        self.washerRating = Int16(representation.washerRating)
        self.washerRatingTotal = Int16(representation.washerRatingTotal)

        // TODO: Get the user matching representation.userId and
        // save it in self.user
    }
    
    var representation: WasherRepresentation {
        WasherRepresentation(aboutMe: self.aboutMe,
                             available: self.available,
                             currentLocationLat: self.currentLocationLat,
                             currentLocationLon: self.currentLocationLon,
                             rateSmall: self.rateSmall,
                             rateMedium: self.rateMedium,
                             rateLarge: self.rateLarge,
                             washerId: Int(self.washerId),
                             washerRating: Int(self.washerRating),
                             washerRatingTotal: Int(self.washerRatingTotal),
                             userId: Int(self.user?.userId ?? NOID32))
    }
    
    var stringID: String {
        String(self.washerId)
    }
}
