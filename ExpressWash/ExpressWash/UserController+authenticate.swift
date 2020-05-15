//
//  UserController+authenticate.swift
//  ExpressWash
//
//  Created by Joel Groomer on 5/11/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import Foundation
import CoreData

extension UserController {
    func authenticate(username: String, password: String, completion: @escaping (User?, Error?) -> Void) {
        guard !username.isEmpty && !password.isEmpty else {
            completion(nil, NSError(domain: "auth", code: INVALIDUSERNAMEORPASSWORD, userInfo: nil))
            return
        }

        let authURL = BASEURL.appendingPathComponent(ENDPOINTS.login.rawValue)
        var request = URLRequest(url: authURL)
        request.httpMethod = "POST"

        let postBody = PostBody(email: username, password: password)

        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(postBody)
            request.httpBody = data
        } catch {
            completion(nil, error)
            return
        }

        SESSION.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error when trying to sign in: \(error)")
                completion(nil, error)
                return
            }

            if let response = response as? HTTPURLResponse {
                if response.statusCode == 403 {
                    completion(nil, NSError(domain: "auth-response",
                                                 code: INVALIDUSERNAMEORPASSWORD,
                                                 userInfo: nil))
                    return
                } else if response.statusCode != 200 {
                    completion(nil, NSError(domain: "auth-response", code: response.statusCode, userInfo: nil))
                    return
                }
            }

            guard let data = data else {
                completion(nil, NSError(domain: "auth-response", code: NODATAERROR, userInfo: nil))
                return
            }

            let decoder = JSONDecoder()

            do {
                let authReturn = try decoder.decode(AuthReturn.self, from: data)
                self.token = authReturn.token
                self.sessionUser = self.findUser(byID: authReturn.user.userId)
                if self.sessionUser != nil {
                    self.update(user: self.sessionUser!, with: authReturn.user)
                } else {
                    self.sessionUser = User(representation: authReturn.user)
                }
                completion(self.sessionUser, nil)
            } catch {
                completion(nil, error)
                return
            }

        }.resume()

    }

    struct PostBody: Encodable {
        var email: String
        var password: String
    }

    struct AuthReturn: Decodable {
        var token: String
        var user: UserRepresentation
    }
}
