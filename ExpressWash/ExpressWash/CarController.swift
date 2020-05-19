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

    // MARK: - Networking Methods

    func createCar(car: Car, completion: @escaping CompletionHandler) {

        let createCarURL = BASEURL.appendingPathComponent("cars/")
        var request = URLRequest(url: createCarURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let encoder = JSONEncoder()

        do {
            let data = try encoder.encode(car.representation)
            request.httpBody = data
        } catch {
            print("Error Encoding Car: \(error)")
            completion(nil, error)
            return
        }

        SESSION.dataTask(with: request) { (data, response, error) in

            if let error = error {
                print("Error Adding Car: \(error)")
                completion(nil, error)
                return
            }

            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    completion(nil, NSError(domain: "Adding Car", code: response.statusCode, userInfo: nil))
                    return
                }
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

    func editCar(car: Car, completion: @escaping CompletionHandler) {

        let editCarURL = BASEURL.appendingPathComponent("cars/\(car.carId)")
        var request = URLRequest(url: editCarURL)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let encoder = JSONEncoder()

        do {
            let data = try encoder.encode(car.representation)
            request.httpBody = data
        } catch {
            print("Error Encoding Car: \(error)")
            completion(nil, error)
            return
        }

        SESSION.dataTask(with: request) { (data, response, error) in

            if let error = error {
                print("Error Editing Car: \(error)")
                completion(nil, error)
                return
            }

            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    completion(nil, NSError(domain: "Editing Car", code: response.statusCode, userInfo: nil))
                    return
                }

                guard let data = data else {
                    completion(nil, NSError(domain: "Editing Car", code: response.statusCode, userInfo: nil))
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
            }
        }.resume()
    }

    func deleteCar(car: Car, completion: @escaping (Error?) -> Void) {

        let deleteCarURL = BASEURL.appendingPathComponent("cars/\(car.carId)")
        var request = URLRequest(url: deleteCarURL)
        request.httpMethod = "DELETE"

        SESSION.dataTask(with: request) { (_, _, error) in
            if let error = error {
                print("Error Deleting Car: \(error)")
                completion(error)
                return
            }
        }
    }

}
