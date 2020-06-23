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

    static let shared = UserController()

    // MARK: - User session
    var sessionUser: SessionUser {
        didSet {
            saveToPersistentStore()
        }
    }
    var token: String?
    var email: String? {
        didSet {
            saveToPersistentStore()
        }
    }
    var password: String? {
        didSet {
            saveToPersistentStore()
        }
    }

    private lazy var localStoreURL: URL? = {
        let fileManager = FileManager.default
        guard let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        return documents.appendingPathComponent("expresswash.plist")
    }()

    init() {
        sessionUser = SessionUser(user: nil, washer: nil)
        if UserDefaults.standard.bool(forKey: "Session") {
            token = UserDefaults.standard.string(forKey: "Token")
            email = UserDefaults.standard.string(forKey: "Email")
            password = UserDefaults.standard.string(forKey: "Password")
            loadFromPersistentStore()
        }
    }

    private func saveToPersistentStore() {
        guard let url = localStoreURL,
              let token = token
        else {
            UserDefaults.standard.set(false, forKey: "Session")
            UserDefaults.standard.set("", forKey: "Token")
            UserDefaults.standard.set("", forKey: "Email")
            UserDefaults.standard.set("", forKey: "Password")
            return
        }

        do {
            let encoder = PropertyListEncoder()
            let userData = try encoder.encode(sessionUser)
            try userData.write(to: url)
            UserDefaults.standard.set(true, forKey: "Session")
            UserDefaults.standard.set(token, forKey: "Token")
            UserDefaults.standard.set(email, forKey: "Email")
            UserDefaults.standard.set(password, forKey: "Password")
        } catch {
            print("Error saving user session data: \(error)")
        }
    }

    private func loadFromPersistentStore() {
        let fileManager = FileManager.default
        guard let url = localStoreURL, fileManager.fileExists(atPath: url.path) else { return }

        do {
            let data = try Data(contentsOf: url)
            let decoder = PropertyListDecoder()
            sessionUser = try decoder.decode(SessionUser.self, from: data)
        } catch {
            print("Error loading user session data: \(error)")
        }
    }

    // MARK: - Local store methods

    func updateUser(_ user: User,
                    with representation: UserRepresentation,
                    context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        user.userId = representation.userId > 0 ? Int32(representation.userId) : user.userId
        user.accountType = representation.accountType != "" ? representation.accountType : user.accountType
        user.email = representation.email != "" ? representation.email : user.email
        user.firstName = representation.firstName != "" ? representation.firstName : user.firstName
        user.lastName = representation.lastName != "" ? representation.lastName : user.lastName
        user.phoneNumber = representation.phoneNumber != nil ? representation.phoneNumber! : user.phoneNumber
        user.stripeUUID = representation.stripeUUID != nil ? representation.stripeUUID! : user.stripeUUID
        user.streetAddress = representation.streetAddress != nil ? representation.streetAddress! : user.streetAddress
        user.streetAddress2 = representation.streetAddress2 != nil
            ? representation.streetAddress2! : user.streetAddress2
        user.city = representation.city != nil ? representation.city! : user.city
        user.state = representation.state != nil ? representation.state! : user.state
        user.zip = representation.zip != nil ? representation.zip! : user.zip
        user.profilePicture = representation.profilePicture != nil
            ? representation.profilePicture! : user.profilePicture
        user.bannerImage = representation.bannerImage != nil ? representation.bannerImage! : user.bannerImage
        user.userRating = representation.userRating != nil ? representation.userRating! : user.userRating

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

        // This function is really meant to be used by the next one (`updateUsers(with representations:)`) which saves
        // them. You can use this on its own by setting `saveOnMainContext` to true.
        // If you need to save on a different context, you'll need to leave it as false and save it yourself.

        user.userId = Int32(representation.userId)
        user.accountType = representation.accountType
        user.email = representation.email
        user.firstName = representation.firstName
        user.lastName = representation.lastName
        user.phoneNumber = representation.phoneNumber
        user.stripeUUID = representation.stripeUUID
        user.streetAddress = representation.streetAddress
        user.streetAddress2 = representation.streetAddress2
        user.city = representation.city
        user.state = representation.state
        user.zip = representation.zip
        user.profilePicture = representation.profilePicture
        user.bannerImage = representation.bannerImage
        user.userRating = representation.userRating != nil ? representation.userRating! : user.userRating

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

    func findUser(byID uid: Int, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) -> User? {
        var foundUser: User?
        let obcjUID = NSNumber(value: uid)
        let fetchrequest: NSFetchRequest<User> = User.fetchRequest()
        fetchrequest.predicate = NSPredicate(format: "userId == %@", obcjUID)
        do {
            let matchedUsers = try context.fetch(fetchrequest)

            if matchedUsers.count == 1 {
                foundUser = matchedUsers[0]
            } else {
                print("Found \(matchedUsers.count) when searching for userId \(uid)")
                foundUser = nil
            }
            return foundUser
        } catch {
            print("Error when searching core data for userId \(uid): \(error)")
            return nil
        }
    }

    func findUser(byID uid: Int32, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) -> User? {
        findUser(byID: Int(uid), context: context)
    }
}

extension UserController {
    // MARK: - Server methods

    func put(user: User, completion: @escaping (Error?) -> Void = { _ in }) {
        let representation = user.representation
        let requestURL = BASEURL.appendingPathComponent(ENDPOINTS.users.rawValue).appendingPathComponent(user.stringID)
        var request = URLRequest(url: requestURL)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(UserController.shared.bearerToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "PUT"

        let encoder = JSONEncoder()
        do {
            request.httpBody = try encoder.encode(representation)
        } catch {
            print("Error encoding representation: \(error)")
            completion(error)
            return
        }

        SESSION.dataTask(with: request) { (_, _, error) in
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
        guard user.userId != NOID32 else {
            completion(nil)
            return
        }

        let requestURL = BASEURL.appendingPathComponent(ENDPOINTS.users.rawValue).appendingPathComponent(user.stringID)
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        request.setValue(UserController.shared.bearerToken, forHTTPHeaderField: "Authorization")
        SESSION.dataTask(with: request) { (_, _, error) in
            if let error = error {
                print("Error deleting entry from server: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }

    func fetchUserByID(uid: Int,
                       context: NSManagedObjectContext = CoreDataStack.shared.mainContext,
                       completion: @escaping (User?, Error?) -> Void) {
        guard uid > 0 else {
            completion(nil, nil)
            return
        }

        let requestURL = BASEURL.appendingPathComponent(ENDPOINTS.users.rawValue).appendingPathComponent(String(uid))
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        request.setValue(UserController.shared.bearerToken, forHTTPHeaderField: "Authorization")
        SESSION.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error fetching user by ID \(uid): \(error)")
                completion(nil, error)
                return
            }

            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    print("Non-200 response when fetching user by ID \(uid): \(response.statusCode)")
                    completion(nil, NSError(domain: "fetchUserByID", code: response.statusCode, userInfo: nil))
                    return
                }
            }

            guard let data = data else {
                print("No data when fetching user by ID \(uid)")
                completion(nil, NSError(domain: "fetchUserByID", code: NODATAERROR, userInfo: nil))
                return
            }

            let decoder = JSONDecoder()
            do {
                let representation = try decoder.decode(UserRepresentation.self, from: data)
                let foundUser = self.findUser(byID: representation.userId)
                if foundUser == nil {
                    let fetchedUser = User(representation: representation, context: context)
                    context.perform {
                        do {
                            try CoreDataStack.shared.save(context: context)
                        } catch {
                            print("Unable to save new user after fetching for ID \(uid): \(error)")
                            context.reset()
                            completion(fetchedUser, error)
                        }
                        completion(fetchedUser, nil)
                    }
                } else {
                    self.update(user: foundUser!, with: representation, saveOnMainContext: true)
                    completion(foundUser!, nil)
                }
            } catch {
                print("Unable to decode after fetching user for ID \(uid): \(error)")
                completion(nil, error)
            }
        }.resume()
    }

    func findOrCreateUserInCoreData(from rep: UserRepresentation,
                                    context: NSManagedObjectContext = CoreDataStack.shared.mainContext) -> User {
        var foundUser = findUser(byID: rep.userId)
        if foundUser == nil {
            foundUser = User(representation: rep, context: context)
        } else {
            updateUserInCoreData(foundUser!, rep: rep, context: context) { (_, _) in }
        }
        return foundUser!
    }

    func updateUserInCoreData(_ user: User,
                              rep: UserRepresentation,
                              context: NSManagedObjectContext = CoreDataStack.shared.mainContext,
                              completion: @escaping CompletionHandler) {
        let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateMOC.parent = context
        privateMOC.performAndWait {
            user.userId = Int32(rep.userId)
            user.accountType = rep.accountType
            user.email = rep.email
            user.firstName = rep.firstName
            user.lastName = rep.lastName
            user.phoneNumber = rep.phoneNumber
            user.stripeUUID = rep.stripeUUID
            user.streetAddress = rep.streetAddress
            user.streetAddress2 = rep.streetAddress2
            user.city = rep.city
            user.state = rep.state
            user.zip = rep.zip
            user.profilePicture = rep.profilePicture
            user.bannerImage = rep.bannerImage
            user.userRating = rep.userRating != nil ? rep.userRating! : user.userRating
            do {
                try privateMOC.save()
            } catch {
                print("Unable to save updated car: \(error)")
                context.reset()
                completion(nil, error)
            }
            completion(user, nil)
        }
    }
}
