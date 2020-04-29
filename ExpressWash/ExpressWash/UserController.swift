//
//  UserController.swift
//  ExpressWash
//
//  Created by Joel Groomer on 4/27/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import Foundation
import CoreData

class UserController {
    
    
    // MARK: - Local store methods
    
    func createUser(accountType: String,
                    email: String,
                    firstName: String,
                    lastName: String,
                    context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        let newUser = User(accountType: accountType,
                           email: email,
                           firstName: firstName,
                           lastName: lastName)
        context.perform {
            do {
                try CoreDataStack.shared.save(context: context)
            } catch {
                print("Unable to save new user: \(error)")
                context.reset()
            }
        }
        
        put(user: newUser)
        
    }
    
    func updateUser(user: User,
                    id: Int?,
                    accountType: String?,
                    email: String?,
                    firstName: String?,
                    lastName: String?,
                    phoneNumber: String?,
                    stripeUUID: String?,
                    token: String?,
                    streetAddress: String?,
                    streetAddress2: String?,
                    city: String?,
                    state: String?,
                    zip: String?,
                    profilePicture: URL?,
                    bannerImage: URL?,
                    userRating: Int?,
                    context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        user.id = id != nil ? Int32(id!) : user.id
        user.accountType = accountType != nil ? accountType! : user.accountType
        user.email = email != nil ? email! : user.email
        user.firstName = firstName != nil ? firstName! : user.firstName
        user.lastName = lastName != nil ? lastName! : user.lastName
        user.phoneNumber = phoneNumber != nil ? phoneNumber! : user.phoneNumber
        user.stripeUUID = stripeUUID != nil ? stripeUUID! : user.stripeUUID
        user.token = token != nil ? token! : user.token
        user.streetAddress = streetAddress != nil ? streetAddress! : user.streetAddress
        user.streetAddress2 = streetAddress2 != nil ? streetAddress2! : user.streetAddress2
        user.city = city != nil ? city! : user.city
        user.state = state != nil ? state! : user.state
        user.zip = zip != nil ? zip! : user.zip
        user.profilePicture = profilePicture != nil ? profilePicture! : user.profilePicture
        user.bannerImage = bannerImage != nil ? bannerImage! : user.bannerImage
        user.userRating = userRating != nil ? Int16(userRating!) : user.userRating
        
        context.perform {
            do {
                try CoreDataStack.shared.save(context: context)
            } catch {
                print("Could not save user after updating: \(error)")
                context.reset()
            }
        }
        put(user: user)
    }
    
    func deleteUser(user: User,
                    context: NSManagedObjectContext = CoreDataStack.shared.mainContext,
                    completion: @escaping (Error?) -> Void = { _ in }) {
        deleteFromServer(user: user) { error in
            if let error = error {
                print("Will not delete local copy of user: \(error)")
                completion(error)
                return
            } else {
                context.perform {
                    do {
                        context.delete(user)
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
        }
    }
    
    func update(user: User,
                with representation: UserRepresentation,
                saveOnMainContext: Bool = false) {
        
        /// This function is really meant to be used by the next one (`updateUsers(with representations:)`) which saves them
        /// all at the end. You can use this on its own by setting `saveOnMainContext` to true.
        /// If you need to save on a different context, you'll need to leave it as false and save it yourself.
        
        user.id = Int32(representation.id)
        user.accountType = representation.accountType
        user.email = representation.email
        user.firstName = representation.firstName
        user.lastName = representation.lastName
        user.phoneNumber = representation.phoneNumber
        user.stripeUUID = representation.stripeUUID
        user.token = representation.token
        user.streetAddress = representation.streetAddress
        user.streetAddress2 = representation.streetAddress2
        user.city = representation.city
        user.state = representation.state
        user.zip = representation.zip
        user.profilePicture = representation.profilePicture
        user.bannerImage = representation.bannerImage
        user.userRating = representation.userRating != nil ? Int16(representation.userRating!) : user.userRating
        
        if saveOnMainContext {
            CoreDataStack.shared.mainContext.perform {
                do {
                    try CoreDataStack.shared.save()
                } catch {
                    print("Could not save user after updating with representation: \(error)")
                    CoreDataStack.shared.mainContext.reset()
                    return
                }
            }
            put(user: user)
        }
    }
    
    func updateUsers(with representations: [UserRepresentation]) {
        let usersWithID = representations.filter({ $0.id != NO_ID })
        let usersToFetch = usersWithID.compactMap({ $0.id })
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(usersToFetch, usersWithID))
        var usersToCreate = representationsByID // holds all users now, but will be whittled down
        
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id IN %@", usersToFetch)
        
        let context = CoreDataStack.shared.container.newBackgroundContext()
        context.perform {
            do {
                let existingUsers = try context.fetch(fetchRequest)
                
                for user in existingUsers {
                    guard user.id != NO_ID,
                        let representation = representationsByID[Int(user.id)] else {
                        continue
                    }
                    
                    self.update(user: user, with: representation)
                    usersToCreate.removeValue(forKey: Int(user.id))
                    try CoreDataStack.shared.save(context: context)
                }
                
                // take care of the ones with id == 0
                for representation in usersToCreate.values {
                    let _ = User(representation: representation)
                    try CoreDataStack.shared.save(context: context)
                }
            } catch {
                print("Error fetching users for IDs: \(error)")
            }
        }
    }
    
    
    // MARK: - Server methods
    
    func put(user: User, completion: @escaping (Error?) -> Void = { _ in }) {
        let representation = user.representation
        let requestURL = BASE_URL.appendingPathComponent(ENDPOINTS.users.rawValue).appendingPathComponent(user.stringID)
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        let encoder = JSONEncoder()
        do {
            request.httpBody = try encoder.encode(representation)
        } catch {
            print("Error encoding representation: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error sending entry to server: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    func deleteFromServer(user: User,
                          context: NSManagedObjectContext = CoreDataStack.shared.mainContext,
                          completion: @escaping (Error?) -> Void = { _ in }) {
        guard user.id != NO_ID32 else {
            completion(nil)
            return
        }
        
        let requestURL = BASE_URL.appendingPathComponent(ENDPOINTS.users.rawValue).appendingPathComponent(user.stringID)
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let error = error {
                print("Error deleting entry from server: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
}
