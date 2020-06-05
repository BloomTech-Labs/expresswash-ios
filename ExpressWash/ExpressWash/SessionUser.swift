//
//  SessionUser.swift
//  ExpressWash
//
//  Created by Joel Groomer on 6/3/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import Foundation

struct SessionUser: Codable {
    var user: User?
    var washer: Washer?

    enum SessionUserKeys: CodingKey {
        case user
        case washer
    }

    init(user: User?, washer: Washer?) {
        self.user = user
        self.washer = washer
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SessionUserKeys.self)
        let userRep = try container.decode(UserRepresentation.self, forKey: .user)
        self.user = User(representation: userRep)

        let washerRep = try container.decodeIfPresent(WasherRepresentation.self, forKey: .washer)
        if let washerRepUnwrapped = washerRep {
            self.washer = Washer(representation: washerRepUnwrapped)
        } else {
            self.washer = nil
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: SessionUserKeys.self)
        try container.encode(self.user?.representation, forKey: .user)
        try container.encode(self.washer?.representation, forKey: .washer)
    }
}
