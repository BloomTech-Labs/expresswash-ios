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
        self.currentLocationLat = representation.currentLocationLat
        self.currentLocationLon = representation.currentLocationLon
        self.rateSmall = representation.rateSmall
        self.rateMedium = representation.rateMedium
        self.rateLarge = representation.rateLarge
        self.washerId = Int32(representation.washerId)
        self.washerRating = Int16(representation.washerRating ?? 0)
        self.washerRatingTotal = Int16(representation.washerRatingTotal)

        // Get the User matching representation.userId and save it in self.user
        let user = UserController.shared.findUser(byID: representation.userId)
        if user == nil {
            UserController.shared.fetchUserByID(uid: representation.userId,
                                                context: context) { (fetchedUser, error) in
                if let error = error {
                    print("Error fetching userId \(representation.userId) for washerId \(self.washerId): \(error)")
                    self.user = nil
                }

                if let fetchedUser = fetchedUser {
                    self.user = fetchedUser
                    return
                }
            }
        } else {
            self.user = user
        }
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
                             washerRating: Int(self.washerRating),
                             washerRatingTotal: Int(self.washerRatingTotal),
                             userId: Int(self.user?.userId ?? NOID32))
    }

    var stringID: String {
        String(self.washerId)
    }
}
