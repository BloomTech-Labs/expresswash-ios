//
//  CarController.swift
//  ExpressWash
//
//  Created by Bobby Keffury on 5/18/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import Foundation
import CoreData

class CarController {

    // MARK: - Properties

    static let shared = CarController()

    typealias CompletionHandler = (Car?, Error?) -> Void

    // MARK: - Local Methods

    func addCar(carRepresentation: CarRepresentation,
                context: NSManagedObjectContext = CoreDataStack.shared.mainContext,
                completion: @escaping CompletionHandler) {

        createCar(carRepresentation: carRepresentation) { (car, error) in
            if let error = error {
                print("Error creating car: \(error)")
                completion(nil, error)
                return
            }

            guard let car = car else {
                return
            }

            completion(car, nil)
        }
    }

    func updateCar(carRepresentation: CarRepresentation,
                   baseCar: Car,
                   context: NSManagedObjectContext = CoreDataStack.shared.mainContext,
                   completion: @escaping CompletionHandler) {

        editCar(carRepresentation: carRepresentation) { (car, error) in
            if let error = error {
                print("Error updating car: \(error)")
                completion(nil, error)
                return
            }

            guard let car = car else { return }

            context.perform {
                do {
                    try CoreDataStack.shared.save(context: context)
                } catch {
                    print("Unable to update car: \(error)")
                    context.reset()
                    completion(nil, error)
                }
                completion(car, nil)
            }
        }
    }

    func updateCarInCoreData(_ car: Car,
                             rep: CarRepresentation,
                             context: NSManagedObjectContext = CoreDataStack.shared.mainContext,
                             completion: @escaping CompletionHandler) {
        let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateMOC.parent = context
        privateMOC.performAndWait {
            car.carId = Int32(rep.carId ?? NOID)
            car.category = rep.category
            car.clientId = Int16(rep.clientId)
            car.color = rep.color
            car.licensePlate = rep.licensePlate
            car.make = rep.make
            car.model = rep.model
            car.photo = rep.photo
            car.size = rep.size
            car.year = rep.year
            do {
                try privateMOC.save()
            } catch {
                print("Unable to save updated car: \(error)")
                context.reset()
                completion(nil, error)
            }
            completion(car, nil)
        }
    }

    func deleteCar(car: Car,
                   context: NSManagedObjectContext = CoreDataStack.shared.mainContext,
                   completion: @escaping (String?, Error?) -> Void = { _, _ in }) {

        deleteCarFromServer(car: car) { msg, error  in
            if let error = error {
                print("Error deleting car: \(error)")
                return
            } else {
                context.perform {
                    do {
                        context.delete(car)
                        try CoreDataStack.shared.save(context: context)
                        completion(msg, nil)
                    } catch {
                        print("Could not save after deleting: \(error)")
                        context.reset()
                        completion(nil, error)
                    }
                }
            }
        }
    }

    func findCar(by carId: Int, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) -> Car? {
        var foundCar: Car?
        let objcCarId = NSNumber(value: carId)
        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "carId == %@", objcCarId)
        do {
            let matchedCars = try context.fetch(fetchRequest)

            if matchedCars.count == 1 {
                foundCar = matchedCars[0]
            }

            return foundCar
        } catch {
            print("Error when searching core data for carId \(carId): \(error)")
            return nil
        }
    }

    // finds or creates a Car in Core Data (not on the server)
    func findOrCreateCarInCoreData(from rep: CarRepresentation,
                                   context: NSManagedObjectContext = CoreDataStack.shared.mainContext) -> Car {
        var foundCar = findCar(by: rep.carId ?? 0)
        if foundCar == nil {
            foundCar = Car(representation: rep, context: context)
        } else {
            // if the Car already exists in Core Data, update based on rep
            updateCarInCoreData(foundCar!, rep: rep, context: context) { (_, _) in }
        }
        return foundCar!
    }

    struct Message: Decodable {
        var message: String
        var updatedCar: CarRepresentation
    }
}

extension CarController {
    // MARK: - Networking Methods

    func createCar(carRepresentation: CarRepresentation, completion: @escaping CompletionHandler) {

        let createCarURL = BASEURL.appendingPathComponent("cars/")
        var request = URLRequest(url: createCarURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(UserController.shared.bearerToken, forHTTPHeaderField: "Authorization")

        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(carRepresentation)
            request.httpBody = data
        } catch {
            print("Error Encoding Car: \(error)")
            completion(nil, error)
            return
        }

        SESSION.dataTask(with: request) { (data, _, error) in

            if let error = error {
                print("Error Adding Car: \(error)")
                completion(nil, error)
                return
            }

            guard let data = data else {
                completion(nil, NSError(domain: "Adding Car", code: NODATAERROR, userInfo: nil))
                return
            }

            let decoder = JSONDecoder()

            do {
                let carRepresentation = try decoder.decode(CarRepresentation.self, from: data)
                let car = Car(representation: carRepresentation)
                completion(car, nil)
            } catch {
                print("Error Decoding Car: \(error)")
                completion(nil, error)
                return
            }
        }.resume()
    }

    func editCar(carRepresentation: CarRepresentation, completion: @escaping CompletionHandler) {

        let editCarURL = BASEURL.appendingPathComponent("cars/\(carRepresentation.carId ?? NOID)")
        var request = URLRequest(url: editCarURL)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(UserController.shared.bearerToken, forHTTPHeaderField: "Authorization")

        let encoder = JSONEncoder()

        do {
            let data = try encoder.encode(carRepresentation)
            request.httpBody = data
        } catch {
            print("Error Encoding Car: \(error)")
            completion(nil, error)
            return
        }

        SESSION.dataTask(with: request) { (data, _, error) in

            if let error = error {
                print("Error Editing Car: \(error)")
                completion(nil, error)
                return
            }

            guard let data = data else {
                completion(nil, error)
                return
            }

            let decoder = JSONDecoder()

            do {
                let editedCarRepresentation = try decoder.decode(CarRepresentation.self, from: data)
                let car = self.findOrCreateCarInCoreData(from: editedCarRepresentation)
                completion(car, nil)
            } catch {
                print("Error Decoding Car: \(error)")
                completion(nil, error)
                return
            }
        }.resume()
    }

    func deleteCarFromServer(car: Car, completion: @escaping (String?, Error?) -> Void) {

        let deleteCarURL = BASEURL.appendingPathComponent("cars/\(car.carId)")
        var request = URLRequest(url: deleteCarURL)
        request.httpMethod = "DELETE"
        request.setValue(UserController.shared.bearerToken, forHTTPHeaderField: "Authorization")

        SESSION.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error Deleting Car: \(error)")
                completion(nil, error)
                return
            }

            guard let data = data else {
                completion(nil, error)
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

    func tieCar(_ carRepresentation: CarRepresentation, with carID: Int, completion: @escaping CompletionHandler) {

        let tieCarURL = BASEURL.appendingPathComponent("cars/\(carID)")
        var request = URLRequest(url: tieCarURL)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(UserController.shared.bearerToken, forHTTPHeaderField: "Authorization")

        let encoder = JSONEncoder()

        do {
            let data = try encoder.encode(carRepresentation)
            request.httpBody = data
        } catch {
            print("Error Encoding Car: \(error)")
            completion(nil, error)
            return
        }

        SESSION.dataTask(with: request) { (data, _, error) in

            if let error = error {
                print("Error Editing Car: \(error)")
                completion(nil, error)
                return
            }

            guard let data = data else {
                completion(nil, error)
                return
            }

            let decoder = JSONDecoder()

            do {
                let editedCarRepresentation = try decoder.decode(Message.self, from: data)
                let car = Car(representation: editedCarRepresentation.updatedCar)
                completion(car, nil)
            } catch {
                print("Error Decoding Car: \(error)")
                completion(nil, error)
                return
            }
        }.resume()
    }

    func decodeCar(with data: Data) -> Car? {
        let decoder = JSONDecoder()

        do {
            let carRep = try decoder.decode(CarRepresentation.self, from: data)
            let car = Car(representation: carRep)
            return car
        } catch {
            print("Error decoding car from data: \(error)")
            return nil
        }
    }

    func decodeCarRep(with data: Data) -> CarRepresentation? {
        let decoder = JSONDecoder()

        do {
            let carRep = try decoder.decode(CarRepresentation.self, from: data)
            return carRep
        } catch {
            print("Error decoding car from data: \(error)")
            return nil
        }
    }
}
