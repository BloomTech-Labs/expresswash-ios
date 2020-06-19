//
//  UserRepresentation.swift
//  ExpressWash
//
//  Created by Joel Groomer on 4/24/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import Foundation

struct UserRepresentation: Codable {
    var accountType: String
    var bannerImage: URL?
    var email: String
    var firstName: String
    var userId: Int
    var lastName: String
    var phoneNumber: String?
    var profilePicture: URL?
    var stripeUUID: String?
    var streetAddress: String?
    var streetAddress2: String?
    var city: String?
    var state: String?
    var zip: String?
    var userRating: Float?
    var userRatingTotal: Int?
    var carRepresentations: [CarRepresentation] = []
    var washerRepresentation: WasherRepresentation?

    init(userId: Int = NOID,
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
         userRating: Float? = nil,
         userRatingTotal: Int? = nil) {
        self.userId = userId
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
        self.userRating = userRating
        self.userRatingTotal = userRatingTotal
    }

    enum UserKeys: String, CodingKey {
        case userId = "id"
        case accountType
        case email
        case firstName
        case lastName
        case bannerImage
        case phoneNumber
        case profilePicture
        case stripeUUID
        case streetAddress
        case streetAddress2
        case city
        case state
        case zip
        case userRating
        case userRatingTotal
        case cars
        case washer
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UserKeys.self)

        // required attributes
        self.userId = try container.decode(Int.self, forKey: .userId)
        self.accountType = try container.decode(String.self, forKey: .accountType)
        self.email = try container.decode(String.self, forKey: .email)
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.lastName = try container.decode(String.self, forKey: .lastName)

        // optional attributes
        let bannerImageString = try container.decodeIfPresent(String.self, forKey: .bannerImage)
        if let bannerImageString = bannerImageString,
            !bannerImageString.isEmpty,
            let bannerImageURL = URL(string: bannerImageString) {
            self.bannerImage = bannerImageURL
        }

        let profileImageString = try container.decodeIfPresent(String.self, forKey: .profilePicture)
        if let profileImageString = profileImageString,
            !profileImageString.isEmpty,
            let profileImageURL = URL(string: profileImageString) {
            self.profilePicture = profileImageURL
        }

        self.phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber)
        self.stripeUUID = try container.decodeIfPresent(String.self, forKey: .stripeUUID)
        self.streetAddress = try container.decodeIfPresent(String.self, forKey: .streetAddress)
        self.streetAddress2 = try container.decodeIfPresent(String.self, forKey: .streetAddress2)
        self.city = try container.decodeIfPresent(String.self, forKey: .city)
        self.state = try container.decodeIfPresent(String.self, forKey: .state)
        self.zip = try container.decodeIfPresent(String.self, forKey: .zip)
        self.userRating = try container.decodeIfPresent(Float.self, forKey: .userRating)
        self.userRatingTotal = try container.decodeIfPresent(Int.self, forKey: .userRatingTotal)
        self.washerRepresentation = try container.decodeIfPresent(WasherRepresentation.self, forKey: .washer)

        // If there are any cars owned by this user, decode them
        do {
            var carContainer = try container.nestedUnkeyedContainer(forKey: .cars)

            while !carContainer.isAtEnd {
                let carRep = try carContainer.decode(CarRepresentation.self)
                carRepresentations.append(carRep)
            }
        } catch {
            // no cars array - we're just going to ignore the error
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: UserKeys.self)

        // ID is only required if this user already exists
        if userId != NOID {
            try container.encode(userId, forKey: .userId)
        }

        // required attributes
        try container.encode(accountType, forKey: .accountType)
        try container.encode(email, forKey: .email)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)

        // optional attributes
        try container.encodeIfPresent(bannerImage, forKey: .bannerImage)
        try container.encodeIfPresent(phoneNumber, forKey: .phoneNumber)
        try container.encodeIfPresent(profilePicture, forKey: .profilePicture)
        try container.encodeIfPresent(stripeUUID, forKey: .stripeUUID)
        try container.encodeIfPresent(streetAddress, forKey: .streetAddress)
        try container.encodeIfPresent(streetAddress2, forKey: .streetAddress2)
        try container.encodeIfPresent(city, forKey: .city)
        try container.encodeIfPresent(state, forKey: .state)
        try container.encodeIfPresent(zip, forKey: .zip)
    }
}
