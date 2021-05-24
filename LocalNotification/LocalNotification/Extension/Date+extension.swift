//
//  Date+extension.swift
//  LocalNotification
//
//  Created by Suguru Takahashi on 2021/05/24.
//

import Foundation

extension Date {
    init?(dateString: String, with format: String = "yyyy-MM-dd") {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.calendar = Calendar.getDefault()
        guard let res = formatter.date(from: dateString) else {
            return nil
        }
        self = res
    }

    var minute: Int {
        let gregorian = Calendar(identifier: .gregorian)
        return gregorian.component(.minute, from: self)
    }

    var hour: Int {
        let gregorian = Calendar(identifier: .gregorian)
        return gregorian.component(.hour, from: self)
    }
}

// AppStorageにDate型を使用するために設定
extension Date: RawRepresentable {
    private static let formatter = ISO8601DateFormatter()

    public var rawValue: String {
        Date.formatter.string(from: self)
    }

    public init?(rawValue: String) {
        self = Date.formatter.date(from: rawValue) ?? Date()
    }
}
