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

            context.perform {
                do {
                    try CoreDataStack.shared.save(context: context)
                } catch {
                    print("Unable to save car to user: \(error)")
                    context.reset()
                }
            }
        }
    }

    func updateCar(carRepresentation: CarRepresentation,
                   context: NSManagedObjectContext = CoreDataStack.shared.mainContext,
                   completion: @escaping CompletionHandler) {

        editCar(carRepresentation: carRepresentation) { (car, error) in
            if let error = error {
                print("Error updating car: \(error)")
                completion(nil, error)
                return
            }

            guard let car = car else { return }

            completion(car, nil)

            context.perform {
                do {
                    try CoreDataStack.shared.save(context: context)
                } catch {
                    print("Unable to update car: \(error)")
                    context.reset()
                }
            }
        }
    }

    func deleteCar(car: Car, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {

        deleteCar(car: car) { _, error  in
            if let error = error {
                print("Error deleting car: \(error)")
                return
            } else {
                context.perform {
                    do {
                        context.delete(car)
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
                let car = Car(representation: editedCarRepresentation)
                completion(car, nil)
            } catch {
                print("Error Decoding Car: \(error)")
                completion(nil, error)
                return
            }
        }.resume()
    }

    func deleteCar(car: Car, completion: @escaping (String?, Error?) -> Void) {

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

    struct Message: Decodable {
        var message: String
        var updatedCar: CarRepresentation
    }
}
