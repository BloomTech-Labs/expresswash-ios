//
//  UserRepresentation.swift
//  ExpressWash
//
//  Created by Joel Groomer on 4/24/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

let NO_UID = 0

import Foundation

struct UserRepresentation: Codable {
    var accountType: String
    var bannerImage: URL?
    var email: String
    var firstName: String
    var id: Int
    var lastName: String
    var phoneNumber: String?
    var profilePicture: URL?
    var stripeUUID: String?
    var streetAddress: String?
    var streetAddress2: String?
    var city: String?
    var state: String?
    var zip: String?
    var token: String?
    var userRating: Int?
    
    init(id: Int = NO_UID,
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
         userRating: Int? = nil) {
        self.id = id
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
        self.userRating = userRating
    }
    
    enum UserKeys: String, CodingKey {
        case id
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
        case token
        case userRating
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UserKeys.self)
        
        // required attributes
        self.id = try container.decode(Int.self, forKey: .id)
        self.accountType = try container.decode(String.self, forKey: .accountType)
        self.email = try container.decode(String.self, forKey: .email)
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.lastName = try container.decode(String.self, forKey: .lastName)
        
        // optional attributes
        self.bannerImage = try container.decodeIfPresent(URL.self, forKey: .bannerImage)
        self.phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber)
        self.profilePicture = try container.decodeIfPresent(URL.self, forKey: .profilePicture)
        self.stripeUUID = try container.decodeIfPresent(String.self, forKey: .stripeUUID)
        self.streetAddress = try container.decodeIfPresent(String.self, forKey: .streetAddress)
        self.streetAddress2 = try container.decodeIfPresent(String.self, forKey: .streetAddress2)
        self.city = try container.decodeIfPresent(String.self, forKey: .city)
        self.state = try container.decodeIfPresent(String.self, forKey: .state)
        self.zip = try container.decodeIfPresent(String.self, forKey: .zip)
        self.token = try container.decodeIfPresent(String.self, forKey: .token)
        self.userRating = try container.decodeIfPresent(Int.self, forKey: .userRating)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: UserKeys.self)
        
        // ID is only required if this user already exists
        if id != NO_UID {
            try container.encode(id, forKey: .id)
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
        try container.encodeIfPresent(token, forKey: .token)
        try container.encodeIfPresent(userRating, forKey: .userRating)
    }
}
