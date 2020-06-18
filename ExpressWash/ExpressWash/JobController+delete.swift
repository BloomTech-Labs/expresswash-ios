//
//  JobController+delete.swift
//  ExpressWash
//
//  Created by Bobby Keffury on 6/18/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import Foundation
import CoreData

extension JobController {
    func deleteJob(job: Job, completion: @escaping (String?, Error?) -> Void) {

        let baseURL = BASEURL.appendingPathComponent(ENDPOINTS.jobRevise.rawValue)
        let deleteJobURL = baseURL.appendingPathComponent("\(job.jobId)")
        var request = URLRequest(url: deleteJobURL)
        request.httpMethod = "DELETE"
        request.setValue(UserController.shared.bearerToken, forHTTPHeaderField: "Authorization")

        SESSION.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error deleting job: \(error)")
                completion(nil, error)
                return
            }

            guard let data = data else {
                completion(nil, NSError(domain: "Deleting Job", code: NODATAERROR, userInfo: nil))
                return
            }

            let decoder = JSONDecoder()

            do {
                let dictionary = try decoder.decode([String: String].self, from: data)
                let message = dictionary.values.first
                completion(message, nil)
            } catch {
                print("Error decoding message: \(error)")
                return
            }
        }.resume()
    }
}
