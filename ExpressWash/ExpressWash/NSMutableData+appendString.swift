//
//  NSMutableData+appendString.swift
//  ExpressWash
//
//  Created by Joel Groomer on 6/9/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import Foundation

extension NSMutableData {
    func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
