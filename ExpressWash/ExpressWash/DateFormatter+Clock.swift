//
//  DateFormatter+Clock.swift
//  ExpressWash
//
//  Created by Joel Groomer on 5/27/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import Foundation

extension DateFormatter {
    static var Clock: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

    static var FromISODate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()

    static func clockString(from timeString: String) -> String {
        if let date = DateFormatter.FromISODate.date(from: timeString) {
            return DateFormatter.Clock.string(from: date)
        }

        return "00:00?"
    }
}
