//
//  Calendar+extension.swift
//  LocalNotification
//
//  Created by Suguru Takahashi on 2021/05/24.
//

import Foundation

extension Calendar {
    static func getDefault() -> Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone.autoupdatingCurrent
        calendar.locale = Locale(identifier: "en_US_POSIX")
        return calendar
    }
}
