//
//  Date+.swift
//  Snowman
//
//  Created by Yonghyun on 2021/11/20.
//

import Foundation

extension Date {
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }

    var month: Int {
        return Calendar.current.component(.month, from: self)
    }

    var year: Int {
        return Calendar.current.component(.year, from: self)
    }

    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        return dateFormatter.string(from: self)
    }

    static func getTodayString() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        return formatter.string(from: date)
    }

    static func numberOfWeeksInMonth(_ date: Date) -> Int {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 1
        let weekRange = calendar.range(of: .weekOfMonth, in: .month, for: date)
        return weekRange!.count
   }

    func startOfMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")

        let date = dateFormatter.string(from: Date())
        let start = date + "-01"

        return start
    }

    func endOfMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")

        var endDay: String?

        switch Int(dateFormatter.string(from: Date())) {
        case 1, 3, 5, 7, 8, 10, 12: endDay = "-31"
        case 4, 6, 9, 11: endDay = "-30"
        case 2: endDay = "-27"
        default:
            break
        }

        dateFormatter.dateFormat = "yyyy-MM"
        let date = dateFormatter.string(from: Date())
        let end = date + endDay!

        return end
    }

    public var removeTimeStamp : Date? {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self)) else {
            return nil
    }
        return date
    }
}
