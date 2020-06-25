//
//  DateFormatter+Clock.swift
//  ExpressWash
//
//  Created by Joel Groomer on 5/27/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import Foundation

extension DateFormatter {
    public static var Clock: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter
    }()

    public static var FromISODate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        return formatter
    }()

    public static var nowAsISOString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        return formatter.string(from: Foundation.Date())
    }

    public static func clockString(from timeString: String) -> String {
        if let date = DateFormatter.FromISODate.date(from: timeString) {
            return DateFormatter.Clock.string(from: date)
        }

        return "00:00?"
    }

    public static var Date: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, YYYY"
        return formatter
    }()

    public static func timeTaken(timeArrived: String?, timeCompleted: String?) -> String {
        guard let timeArrived = timeArrived, let timeCompleted = timeCompleted else { return "In Progress"}
        let dateFormatter = DateFormatter.FromISODate
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

        return "\(timeTaken) min"
    }
}
