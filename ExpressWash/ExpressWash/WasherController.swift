//
//  WasherController.swift
//  ExpressWash
//
//  Created by Joel Groomer on 5/14/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import Foundation
import CoreData

class WasherController {
    // MARK: - Local store methods
    func createLocalWasher(from representation: WasherRepresentation,
                           context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        _ = Washer(representation: representation, context: context)
        context.perform {
            do {
                try CoreDataStack.shared.save(context: context)
            } catch {
                print("Unable to save new washer: \(error)")
                context.reset()
            }
        }
        // put(washer: newWasher)
    }

    func updateWasher(_ washer: Washer,
                      with representation: WasherRepresentation,
                      context: NSManagedObjectContext = CoreDataStack.shared.mainContext,
                      completion: @escaping (Error?) -> Void) {
        washer.aboutMe = representation.aboutMe
        washer.workStatus = representation.workStatus
        washer.currentLocationLat = representation.currentLocationLat
        washer.currentLocationLon = representation.currentLocationLon
        washer.rateSmall = representation.rateSmall
        washer.rateMedium = representation.rateMedium
        washer.rateLarge = representation.rateLarge
        washer.washerId = Int32(representation.washerId)
        washer.washerRating = Int16(representation.washerRating)
        washer.washerRatingTotal = Int16(representation.washerRatingTotal)
        
        // if the user is already the same, don't bother hunting it down
        // and updating it for no reason
        if washer.user?.userId != Int32(representation.userId) {
            // if not, grab the user from Core Data
            if let newUser = UserController.shared.findUser(byID: representation.userId,
                                                            context: context) {
                washer.user = newUser
                context.perform {
                    do {
                        try CoreDataStack.shared.save(context: context)
                    } catch {
                        print("Unable to save updated washer: \(error)")
                        context.reset()
                        completion(error)
                        return
                    }
                }
            } else {
                // if the user isn't already in Core Data, fetch it from the server
                UserController.shared.fetchUserByID(uid: representation.userId,
                                                    context: context)
                {
                    (user, error) in
                    if let error = error {
                        context.perform {
                            print("Unable to fetch user to update washer: \(error)")
                            context.reset()
                            completion(error)
                        }
                    } else {
                        guard let user = user else {
                            print("No user (id \(representation.userId)) returned from server for washer (id \(representation.washerId))")
                            completion(NSError(domain: "update washer", code: NODATAERROR, userInfo: nil))
                            return
                        }
                        washer.user = user
                        context.perform {
                            do {
                                try CoreDataStack.shared.save(context: context)
                                completion(nil)
                            } catch {
                                print("Unable to save updated washer: \(error)")
                                context.reset()
                                completion(error)
                            }
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
        let objcUID = NSNumber(value: uid)
        let fetchrequest: NSFetchRequest<Washer> = Washer.fetchRequest()
        fetchrequest.predicate = NSPredicate(format: "washerID == %@", objcUID)
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
    
    func findWasher(byID washerID: Int32, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) -> Washer? {
        findWasher(byID: Int(washerID), context: context)
    }
}

extension WasherController {
    // MARK: - Server methods
    
    func put(washer: Washer, completion: @escaping (Error?) -> Void = { _ in }) {
        let washerRep = washer.representation
        let requestURL = BASEURL.appendingPathComponent(ENDPOINTS.washer.rawValue).appendingPathComponent(washer.stringID)
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
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

}
