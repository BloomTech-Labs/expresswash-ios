//
//  UserController+Registration.swift
//  ExpressWash
//
//  Created by Bobby Keffury on 5/11/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import Foundation

extension UserController {

    typealias CompletionHandler = (Error?) -> Void

    func registerUser(with firstName: String, _ lastName: String, _ emailAddress: String, _ password: String, completion: @escaping CompletionHandler = { _ in }) {

        let register = ENDPOINTS.registerClient
        let registerUrl = BASEURL.appendingPathComponent(register.rawValue)

        var request = URLRequest(url: registerUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let userParams = ["firstName": firstName, "lastName": lastName, "emailAddress": emailAddress, "password": password] as [String: Any]
            let json = try JSONSerialization.data(withJSONObject: userParams, options: .prettyPrinted)
            request.httpBody = json
        } catch {
            print("Error encoding user object: \(error)")
        }

        URLSession.shared.dataTask(with: request) { ( _, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }

            if let error = error { completion(error); return}

            completion(nil)
        }.resume()
    }
}
