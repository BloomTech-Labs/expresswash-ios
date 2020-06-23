//
//  WasherController.swift
//  ExpressWash
//
//  Created by Joel Groomer on 5/14/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

class WasherController {

    static let shared = WasherController()

    // MARK: - Local store methods
    func updateWasher(_ washer: Washer,
                      with rep: WasherRepresentation,
                      context: NSManagedObjectContext = CoreDataStack.shared.mainContext,
                      completion: @escaping (Error?) -> Void = { _ -> Void in }) {
        washer.aboutMe = rep.aboutMe
        washer.workStatus = rep.workStatus
        washer.currentLocationLat = rep.currentLocationLat ?? kCLLocationCoordinate2DInvalid.latitude
        washer.currentLocationLon = rep.currentLocationLon ?? kCLLocationCoordinate2DInvalid.longitude
        washer.rateSmall = rep.rateSmall ?? rep.rateMedium
        washer.rateMedium = rep.rateMedium
        washer.rateLarge = rep.rateLarge ?? rep.rateMedium
        washer.washerId = Int32(rep.washerId)
        washer.washerRating = rep.washerRating ?? 0.0
        washer.washerRatingTotal = Int16(rep.washerRatingTotal)

        // if the user is already the same, don't bother hunting it down
        // and updating it for no reason
        if washer.user?.userId != Int32(rep.userId) {
            // if not, grab the user from Core Data
            if let newUser = UserController.shared.findUser(byID: rep.userId,
                                                            context: context) {
                context.perform {
                    washer.user = newUser
                    do {
                        try CoreDataStack.shared.save(context: context)
                        completion(nil)
                        return
                    } catch {
                        print("Unable to save updated washer: \(error)")
                        context.reset()
                        completion(error)
                        return
                    }
                }
            } else {
                // if the user isn't already in Core Data, fetch it from the server
                UserController.shared.fetchUserByID(uid: rep.userId,
                                                    context: context) { (user, error) in
                    if let error = error {
                        print("Unable to fetch user to update washer: \(error)")
                        completion(error)
                        return
                    }

                    guard let user = user else {
                        print("No user (id \(rep.userId)) returned for washer (id \(rep.washerId))")
                        completion(NSError(domain: "update washer", code: NODATAERROR, userInfo: nil))
                        return
                    }

                    context.perform {
                        washer.user = user
                        do {
                            try CoreDataStack.shared.save(context: context)
                            completion(nil)
                            return
                        } catch {
                            print("Unable to save updated washer: \(error)")
                            context.reset()
                            completion(error)
                            return
                        }
                    }
                }
            }
        }
    }

    func deleteWasherLocally(washer: Washer,
                             context: NSManagedObjectContext = CoreDataStack.shared.mainContext,
                             completion: @escaping (Error?) -> Void = { _ in }) {
        context.perform {
            do {
                context.delete(washer)
                try CoreDataStack.shared.save(context: context)
            } catch {
                print("Could not save after deleting: \(error)")
                context.reset()
                completion(error)
                return
            }
        }
        completion(nil)
    }

    func findWasher(byID washerID: Int, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) -> Washer? {
        var foundWasher: Washer?
        let objcUID = NSNumber(value: washerID)
        let fetchrequest: NSFetchRequest<Washer> = Washer.fetchRequest()
        fetchrequest.predicate = NSPredicate(format: "washerId == %@", objcUID)
        do {
            let matchedWashers = try context.fetch(fetchrequest)

            if matchedWashers.count == 1 {
                foundWasher = matchedWashers[0]
            } else {
                foundWasher = nil
            }
            return foundWasher
        } catch {
            print("Error when searching core data for washerID \(washerID): \(error)")
            return nil
        }
    }

    func findWasher(byID washerID: Int32,
                    context: NSManagedObjectContext = CoreDataStack.shared.mainContext) -> Washer? {
        findWasher(byID: Int(washerID), context: context)
    }
}

extension WasherController {
    // MARK: - Server methods

    func put(washerRep: WasherRepresentation, completion: @escaping (Error?) -> Void = { _ in }) {
        let requestURL = BASEURL
            .appendingPathComponent(ENDPOINTS.washer.rawValue)
            .appendingPathComponent("\(washerRep.washerId)")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(UserController.shared.bearerToken, forHTTPHeaderField: "Authorization")

        let encoder = JSONEncoder()
        do {
            request.httpBody = try encoder.encode(washerRep)
        } catch {
            print("Error encoding washerRep: \(error)")
            completion(error)
        }

        SESSION.dataTask(with: request) { (_, _, error) in
            if let error = error {
                print("Error sending washer to server: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }

    func put(washer: Washer, completion: @escaping (Error?) -> Void = { _ in }) {
        put(washerRep: washer.representation, completion: completion)
    }

    func rate(washer: Washer, rating: Int, completion: @escaping (Error?) -> Void = { _ in }) {
        let requestURL = BASEURL
            .appendingPathComponent(ENDPOINTS.washerRating.rawValue)
            .appendingPathComponent(washer.stringID)
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(UserController.shared.bearerToken, forHTTPHeaderField: "Authorization")

        let newRating = WasherRating(washerRating: rating)

        let encoder = JSONEncoder()
        do {
            request.httpBody = try encoder.encode(newRating)
        } catch {
            print("Error encoding washer rating: \(error)")
            completion(error)
            return
        }

        SESSION.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(error)
                return
            }

            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 && response.statusCode != 201 && response.statusCode != 202 {
                    print("Error rating washer: \(response.statusCode)")
                    completion(NSError(domain: "rate washer", code: response.statusCode, userInfo: nil))
                    return
                }
            }

            guard let data = data else {
                print("No data after rating washer")
                completion(NSError(domain: "rate washer", code: NODATAERROR, userInfo: nil))
                return
            }

            let decoder = JSONDecoder()
            do {
                let updatedWasherRep = try decoder.decode(WasherRepresentation.self, from: data)
                self.updateWasher(washer, with: updatedWasherRep) { _ in }
            } catch {
                print("Error decoding washer after rating: \(error)")
                completion(error)
                return
            }

            completion(nil)
        }.resume()
    }

    func getWashersInCity(_ city: String, completion: @escaping ([Washer]?, Error?) -> Void) {
        let baseURL = BASEURL.appendingPathComponent(ENDPOINTS.washersInCity.rawValue).appendingPathComponent(city)
        var request = URLRequest(url: baseURL)
        request.httpMethod = "GET"
        request.setValue(UserController.shared.bearerToken, forHTTPHeaderField: "Authorization")

        SESSION.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error getting washers: \(error)")
                completion(nil, error)
                return
            }

            if let response = response as? HTTPURLResponse {
                print("\(response.statusCode)")
                if response.statusCode != 200 && response.statusCode != 201 && response.statusCode != 202 {
                    completion(nil, NSError(domain: "Getting Washers in City",
                                            code: response.statusCode,
                                            userInfo: nil))
                    return
                }
            }

            guard let data = data else {
                completion(nil, NSError(domain: "Getting Washers in City", code: NODATAERROR, userInfo: nil))
                return
            }

            let decoder = JSONDecoder()

            do {
                let washerReps = try decoder.decode([WasherRepresentation].self, from: data)
                var washers: [Washer] = []

                for wash in washerReps {
                    var washer = self.findWasher(byID: wash.washerId)
                    if washer == nil {
                        washer = Washer(representation: wash)
                    }
                    UserController.shared.fetchUserByID(uid: wash.userId) { (user, error) in
                        if let error = error {
                            print("Error fetching a washer-user: \(error)")
                            return
                        }

                        if let user = user {
                            washer?.user = user
                        }
                    }
                    washers.append(washer!)
                }
                completion(washers, nil)
            } catch {
                print("Error getting washers in city: \(error)")
                return
            }
        }.resume()
    }

    struct WasherRating: Encodable {
        var washerRating: Int
    }
}
