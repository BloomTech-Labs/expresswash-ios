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

    static func timeTaken(timeArrived: String, timeCompleted: String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeZone = TimeZone.current
        let arrivalDate = dateFormatter.date(from: timeArrived)
        let completedDate = dateFormatter.date(from: timeCompleted)

        let calendar = Calendar.current
        let arrivalComp = calendar.dateComponents([.hour, .minute], from: arrivalDate!)
        let completedComp = calendar.dateComponents([.hour, .minute], from: completedDate!)
        let arrivalHour = arrivalComp.hour ?? 0
        let arrivalMinute = arrivalComp.minute ?? 0

        let minutesArrived = (arrivalHour * 60) + arrivalMinute

        let completedHour = completedComp.hour ?? 0
        let completedMinute = completedComp.minute ?? 0

        let minutesCompleted = (completedHour * 60) + completedMinute

        let timeTaken = minutesCompleted - minutesArrived

        return timeTaken
    }
}
