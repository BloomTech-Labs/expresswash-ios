//
//  PhotoController.swift
//  ExpressWash
//
//  Created by Joel Groomer on 6/9/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import Foundation
import UIKit

enum ImageEndpoint: String {
    case imagesProfile = "images/profile"       // POST or PUT  /:id    Add/update a profile picture
    case imagesBanner = "images/banner"         // POST or PUT  /:id    Add/update a banner image
    case imagesJobBefore = "images/job/before"  // POST         /:jobId Add a before image for a job
    case imagesJobAfter = "images/job/after"    // POST         /:jobId Add an after image for a job
    case imagesCar = "images/car"               // POST         /:carId Add an image for a specific car
}

class PhotoController {
    static var shared = PhotoController()

    enum FormKeys: String {
        // the key for the multi-part form submmission
        // (the value will be the jpg data)
        case bannerImage
        case car = "photo"
        case photoAfterJob
        case photoBeforeJob
        case profilePicture
    }

    func uploadPhoto(_ image: UIImage,
                     httpMethod: String,
                     endpoint: ImageEndpoint,
                     theID: Int,
                     completion: @escaping (Data?, Error?) -> Void) {
        guard httpMethod == "POST" || httpMethod == "PUT", theID > 0 else {
            completion(nil, NSError(domain: "PhotoController", code: BADPHOTOREQUEST, userInfo: nil))
            return
        }

        guard let jpg = image.jpegData(compressionQuality: 0.8) else {
            completion(nil, NSError(domain: "PhotoController", code: CANNOTCONVERT, userInfo: nil))
            return
        }

        let boundary = "Boundary-\(UUID().uuidString)"
        let baseURL = BASEURL.appendingPathComponent(endpoint.rawValue)
        let url = baseURL.appendingPathComponent(String(theID))
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        let fieldName = getFieldName(for: endpoint)
        let httpBody = NSMutableData()
        let fileData = convertFileData(fieldName: fieldName,
                                       fileName: "\(fieldName)\(theID).jpg",
                                       mimeType: "image/jpeg",
                                       fileData: jpg,
                                       using: boundary)
        httpBody.append(fileData)
        httpBody.appendString("--\(boundary)--")
        request.httpBody = httpBody as Data

        SESSION.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error uploading photo: \(error)")
                completion(nil, error)
                return
            }

            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 && response.statusCode != 201 {
                    completion(nil, NSError(domain: "PhotoController", code: response.statusCode, userInfo: nil))
                } else {
                    if let data = data {
                        completion(data, nil)
                    } else {
                        completion(nil, NSError(domain: "PhotoController", code: NODATAERROR, userInfo: nil))
                    }
                }
            }
        }.resume()
    }

    private func getFieldName(for endpoint: ImageEndpoint) -> String {
        switch endpoint {
        case .imagesBanner:
            return FormKeys.bannerImage.rawValue
        case .imagesCar:
            return FormKeys.car.rawValue
        case .imagesJobAfter:
            return FormKeys.photoAfterJob.rawValue
        case .imagesJobBefore:
            return FormKeys.photoBeforeJob.rawValue
        case .imagesProfile:
            return FormKeys.profilePicture.rawValue
        }
    }

    private func convertFileData(fieldName: String,
                                 fileName: String,
                                 mimeType: String,
                                 fileData: Data,
                                 using boundary: String) -> Data {
        let data = NSMutableData()

        data.appendString("--\(boundary)\r\n")
        data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
        data.appendString("Content-Type: \(mimeType)\r\n\r\n")
        data.append(fileData)
        data.appendString("\r\n")

        return data as Data
    }
}
