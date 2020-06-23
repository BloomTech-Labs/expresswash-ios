//
//  UserController+Registration.swift
//  ExpressWash
//
//  Created by Bobby Keffury on 5/11/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import Foundation

extension UserController {

    typealias CompletionHandler = (User?, Error?) -> Void

    // swiftlint:disable function_parameter_count
    func registerUser(account type: String,
                      with emailAddress: String,
                      _ firstName: String,
                      _ lastName: String,
                      _ password: String,
                      completion: @escaping CompletionHandler) {

        let registerUrl = BASEURL.appendingPathComponent(ENDPOINTS.registerClient.rawValue)
        var request = URLRequest(url: registerUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let encoder = JSONEncoder()

        do {
            let user = RegisteredUser(accountType: type,
                                      email: emailAddress,
                                      firstName: firstName,
                                      lastName: lastName,
                                      password: password)
            let data = try encoder.encode(user)
            request.httpBody = data
        } catch {
            completion(nil, error)
            return
        }

        SESSION.dataTask(with: request) { (data, response, error) in

            if let error = error {
                print("Error Registering User: \(error)")
                completion(nil, error)
                return
            }

            if let response = response as? HTTPURLResponse {
                if response.statusCode != 201 {
                    completion(nil, NSError(domain: "Registering User", code: response.statusCode, userInfo: nil))
                    return
                }
            }

            guard let data = data else {
                completion(nil, NSError(domain: "Registering User", code: NODATAERROR, userInfo: nil))
                return
            }

            let decoder = JSONDecoder()

            do {
                let dataResponse = try decoder.decode(DataResponse.self, from: data)
                let user = User(representation: dataResponse.user)
                UserController.shared.token = dataResponse.token
                UserController.shared.sessionUser.user = user
                completion(user, nil)
            } catch {
                completion(nil, error)
                return
            }
        }.resume()
    }

    struct RegisteredUser: Codable {
        var accountType: String
        var email: String
        var firstName: String
        var lastName: String
        var password: String
    }

    struct DataResponse: Codable {
        var message: String
        var token: String
        var user: UserRepresentation
    }

}
