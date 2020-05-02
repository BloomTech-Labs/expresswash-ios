//
//  User+Convenience.swift
//  ExpressWash
//
//  Created by Joel Groomer on 4/24/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import Foundation
import CoreData

extension User {
    convenience init(userID: Int32 = 0,
                     accountType: String,
                     email: String,
                     firstName: String,
                     lastName: String,
                     bannerImage: URL? = nil,
                     phoneNumber: String? = nil,
                     profilePicture: URL? = nil,
                     stripeUUID: String? = nil,
                     streetAddress: String? = nil,
                     streetAddress2: String? = nil,
                     city: String? = nil,
                     state: String? = nil,
                     zip: String? = nil,
                     token: String? = nil,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.userID = userID
        self.accountType = accountType
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.bannerImage = bannerImage
        self.phoneNumber = phoneNumber
        self.profilePicture = profilePicture
        self.stripeUUID = stripeUUID
        self.streetAddress = streetAddress
        self.streetAddress2 = streetAddress2
        self.city = city
        self.state = state
        self.zip = zip
        self.token = token
    }

    convenience init(representation: UserRepresentation,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.userID = Int32(representation.userID)
        self.accountType = representation.accountType
        self.email = representation.email
        self.firstName = representation.firstName
        self.lastName = representation.lastName
        self.bannerImage = representation.bannerImage
        self.phoneNumber = representation.phoneNumber
        self.profilePicture = representation.profilePicture
        self.stripeUUID = representation.stripeUUID
        self.streetAddress = representation.streetAddress
        self.streetAddress2 = representation.streetAddress2
        self.city = representation.city
        self.state = representation.state
        self.zip = representation.zip
        self.token = representation.token
    }

    var representation: UserRepresentation {
        UserRepresentation(userID: Int(self.userID),
                           accountType: self.accountType,
                           email: self.email,
                           firstName: self.firstName,
                           lastName: self.lastName,
                           bannerImage: self.bannerImage,
                           phoneNumber: self.phoneNumber,
                           profilePicture: self.profilePicture,
                           stripeUUID: self.stripeUUID,
                           streetAddress: self.streetAddress,
                           streetAddress2: self.streetAddress2,
                           city: self.city,
                           state: self.state,
                           zip: self.zip,
                           token: self.token)
    }

    var stringID: String {
        String(self.userID)
    }

}
