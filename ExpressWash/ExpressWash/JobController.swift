//
//  JobController.swift
//  ExpressWash
//
//  Created by Bobby Keffury on 5/20/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import Foundation
import CoreData

class JobController {

    // MARK: - Properties

    typealias CompletionHandler = (Job?, Error?) -> Void

    // MARK: - Local Methods

    func addJob(jobRepresentation: JobRepresentation,
                context: NSManagedObjectContext = CoreDataStack.shared.mainContext,
                completion: @escaping CompletionHandler) {

        createJob(jobRepresentation: jobRepresentation) { (job, error) in
            if let error = error {
                print("Error creating job: \(error)")
                completion(nil, error)
                return
            }

            guard let job = job else {
                return
            }

            completion(job, nil)

            context.perform {
                do {
                    try CoreDataStack.shared.save(context: context)
                } catch {
                    print("Unable to save car to user: \(error)")
                    context.reset()
                    return
                }
            }
        }
    }

    func updateJob(jobRepresentation: JobRepresentation,
                   context: NSManagedObjectContext = CoreDataStack.shared.mainContext,
                   completion: @escaping CompletionHandler) {

        editJob(jobRepresentation: jobRepresentation) { (job, error) in
            if let error = error {
                print("Error updating job: \(error)")
                completion(nil, error)
                return
            }

            guard let job = job else { return }

            completion(job, nil)

            context.perform {
                do {
                    try CoreDataStack.shared.save(context: context)
                } catch {
                    print("Unable to update job: \(error)")
                    context.reset()
                    return
                }
            }
        }
    }

    func deleteJob(job: Job,
                   context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {

        deleteJob(job: job) { _, error in
            if let error = error {
                print("Error deleting job: \(error)")
                return
            } else {
                context.perform {
                    do {
                        context.delete(job)
                        try CoreDataStack.shared.save(context: context)
                    } catch {
                        print("Could not save after deleting: \(error)")
                        context.reset()
                        return
                    }
                }
            }
        }
    }
}

extension JobController {

    // MARK: - Network Methods

    func createJob(jobRepresentation: JobRepresentation, completion: @escaping CompletionHandler) {

        let createJobURL = BASEURL.appendingPathComponent(ENDPOINTS.jobNew.rawValue)
        var request = URLRequest(url: createJobURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let encoder = JSONEncoder()

        do {
            let data = try encoder.encode(jobRepresentation)
            request.httpBody = data
        } catch {
            print("Error encoding job: \(error)")
            completion(nil, error)
            return
        }

        SESSION.dataTask(with: request) { (data, response, error) in

            if let error = error {
                print("Error creating job: \(error)")
                completion(nil, error)
                return
            }

            if let response = response as? HTTPURLResponse {
                print("\(response.statusCode)")
                if response.statusCode != 200 && response.statusCode != 201 && response.statusCode != 202 {
                    completion(nil, NSError(domain: "Creating Job", code: response.statusCode, userInfo: nil))
                    return
                }
            }

            guard let data = data else {
                completion(nil, NSError(domain: "Creating Job", code: NODATAERROR, userInfo: nil))
                return
            }

            let decoder = JSONDecoder()

            do {
                let jobRepresentation = try decoder.decode(JobRepresentation.self, from: data)
                let job = Job(representation: jobRepresentation)
                completion(job, nil)
            } catch {
                print("Error decoding job: \(error)")
                completion(nil, error)
                return
            }
        }.resume()
    }

    func getJobInfo(jobRepresentation: JobRepresentation, completion: @escaping CompletionHandler) {
        let baseURL = BASEURL.appendingPathComponent(ENDPOINTS.jobInfo.rawValue)
        let jobInfoURL = baseURL.appendingPathComponent("\(jobRepresentation.jobId)")
        var request = URLRequest(url: jobInfoURL)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        SESSION.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error getting job info: \(error)")
                completion(nil, error)
                return
            }

            if let response = response as? HTTPURLResponse {
                print("\(response.statusCode)")
                if response.statusCode != 200 && response.statusCode != 201 && response.statusCode != 202 {
                    completion(nil, NSError(domain: "Getting Job Info", code: response.statusCode, userInfo: nil))
                    return
                }
            }

            guard let data = data else {
                completion(nil, NSError(domain: "Getting Job Info", code: NODATAERROR, userInfo: nil))
                return
            }

            let decoder = JSONDecoder()

            do {
                let jobRepresentation = try decoder.decode(JobRepresentation.self, from: data)
                let job = Job(representation: jobRepresentation)
                completion(job, nil)
            } catch {
                print("Error decoding job info: \(error)")
                completion(nil, error)
                return
            }
        }.resume()
    }

    func getUserJobs(user: User, completion: @escaping ([JobRepresentation]?, Error?) -> Void) {
        let baseURL = BASEURL.appendingPathComponent(ENDPOINTS.jobGet.rawValue)
        let getJobsURL = baseURL.appendingPathComponent("\(user.userId)")
        var request = URLRequest(url: getJobsURL)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        SESSION.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error getting users jobs: \(error)")
                completion(nil, error)
                return
            }

            if let response = response as? HTTPURLResponse {
                print("\(response.statusCode)")
                if response.statusCode != 200 && response.statusCode != 201 && response.statusCode != 202 {
                    completion(nil, NSError(domain: "Getting Users Jobs", code: response.statusCode, userInfo: nil))
                    return
                }
            }

            guard let data = data else {
                completion(nil, NSError(domain: "Getting Users Jobs", code: NODATAERROR, userInfo: nil))
                return
            }

            let decoder = JSONDecoder()

            do {
                let jobRepresentations = try decoder.decode([JobRepresentation].self, from: data)
                completion(jobRepresentations, nil)
            } catch {
                print("Error decoding users jobs: \(error)")
                completion(nil, error)
                return
            }
        }.resume()
    }

    func assignWasher(jobRepresentation: JobRepresentation, washerID: Int, completion: @escaping CompletionHandler) {
        let baseURL = BASEURL.appendingPathComponent(ENDPOINTS.jobSelect.rawValue)
        let jobURL = baseURL.appendingPathComponent("\(jobRepresentation.jobId)")
        var request = URLRequest(url: jobURL)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let encoder = JSONEncoder()

        do {
            let washerID = WasherID(washerID: washerID)
            let data = try encoder.encode(washerID)
            request.httpBody = data
        } catch {
            print("Error encoding washer to be assigned: \(error)")
            completion(nil, error)
            return
        }

        SESSION.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error assigning washer to job: \(error)")
                completion(nil, error)
                return
            }

            if let response = response as? HTTPURLResponse {
                print("\(response.statusCode)")
                if response.statusCode != 200 && response.statusCode != 201 && response.statusCode != 202 {
                    completion(nil, NSError(domain: "Assigning Washer To Job",
                                            code: response.statusCode,
                                            userInfo: nil))
                    return
                }
            }

            guard let data = data else {
                completion(nil, NSError(domain: "Assigning Washer To Job", code: NODATAERROR, userInfo: nil))
                return
            }

            let decoder = JSONDecoder()

            do {
                let jobRepresentation = try decoder.decode(JobRepresentation.self, from: data)
                let job = Job(representation: jobRepresentation)
                completion(job, nil)
            } catch {
                print("Error decoding job assigned to washer: \(error)")
                completion(nil, error)
                return
            }
        }.resume()
    }

    func editJob(jobRepresentation: JobRepresentation, completion: @escaping CompletionHandler) {

        let baseURL = BASEURL.appendingPathComponent(ENDPOINTS.jobRevise.rawValue)
        let editJobURL = baseURL.appendingPathComponent("\(jobRepresentation.jobId)")
        var request = URLRequest(url: editJobURL)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let encoder = JSONEncoder()

        do {
            let data = try encoder.encode(jobRepresentation)
            request.httpBody = data
        } catch {
            print("Error encoding job: \(error)")
            completion(nil, error)
            return
        }

        SESSION.dataTask(with: request) { (data, _, error) in

            if let error = error {
                print("Error editing job: \(error)")
                completion(nil, error)
                return
            }

            guard let data = data else {
                completion(nil, NSError(domain: "Editing Job", code: NODATAERROR, userInfo: nil))
                return
            }

            let decoder = JSONDecoder()

            do {
                let editedJobRepresentations = try decoder.decode([JobRepresentation].self, from: data)
                if let jobRepresentation = editedJobRepresentations.first {
                    let job = Job(representation: jobRepresentation)
                    completion(job, nil)
                }
            } catch {
                print("Error decoding job: \(error)")
                completion(nil, error)
                return
            }
        }.resume()
    }

    func deleteJob(job: Job, completion: @escaping (String?, Error?) -> Void) {

        let baseURL = BASEURL.appendingPathComponent(ENDPOINTS.jobRevise.rawValue)
        let deleteJobURL = baseURL.appendingPathComponent("\(job.jobId)")
        var request = URLRequest(url: deleteJobURL)
        request.httpMethod = "DELETE"

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

    struct WasherID: Codable {
        var washerID: Int
    }
}
