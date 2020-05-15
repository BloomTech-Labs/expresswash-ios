//
//  JSONLoader.swift
//  ExpressWashTests
//
//  Created by Joel Groomer on 5/12/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import Foundation

class JSONLoader {
    static func readFrom(filename: String) -> Data? {
        print("********\nATTEMPTING TO LOAD FILE: \(filename)")
        var data: Data?
        let bundle = Bundle.init(for: self)
        if let fileUrl = bundle.url(forResource: filename, withExtension: "json") {
            do {
                data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                print("GOT DATA")
                print("********")
                return data
            } catch {
                print("COULDN'T GET DATA")
                fatalError("Unable to load JSON test data for \(filename)")
            }
        } else {
            print("INVALID PATH: nil")
        }
        print("********")
        return nil
    }
}
