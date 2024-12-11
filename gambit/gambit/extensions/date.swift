//
//  date.swift
//  node
//
//  Created by Nick Mantini on 11/13/24.
//

import Foundation

func convertToDate(dateSent: String, timeSent: String) -> Date? {
    // Create a formatter for the date part (MM/dd/yy)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yy"
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    
    // Create a formatter for the time part (h:mm a)
    let timeFormatter = DateFormatter()
    timeFormatter.dateFormat = "h:mm a"
    timeFormatter.locale = Locale(identifier: "en_US_POSIX")
    
    // Parse date and time separately
    guard let datePart = dateFormatter.date(from: dateSent),
          let timePart = timeFormatter.date(from: timeSent) else {
        return nil
    }
    
    // Combine the date and time into a single Date object
    let calendar = Calendar.current
    var dateComponents = calendar.dateComponents([.year, .month, .day], from: datePart)
    let timeComponents = calendar.dateComponents([.hour, .minute], from: timePart)
    
    dateComponents.hour = timeComponents.hour
    dateComponents.minute = timeComponents.minute
    
    return calendar.date(from: dateComponents)
}

extension Date {
    static func fromISOString(_ isoString: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds] // Matches JS `toISOString()`
        return formatter.date(from: isoString)
    }
}
