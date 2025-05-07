//
// ComicDate.swift
//  xkcdME
//
//  Created by Micky McKeon on 5/7/25.
//

import Foundation

struct ComicDate {
    static func create<T: LosslessStringConvertible>(month: T, day: T, year: T) -> Date? {
        if let month = Int("\(month)"), let day = Int("\(day)"), let year = Int("\(year)") {
            let currentYear = Calendar.current.component(.year, from: Date())
            if year <= Int(currentYear) {
                var dateComponents = DateComponents()
                dateComponents.year = year
                dateComponents.month = month
                dateComponents.day = day
                
                let calendar = Calendar.current
                if let date = calendar.date(from: dateComponents) {
                    let validated = calendar.dateComponents([.year, .month, .day], from: date)
                    if validated.month == month,
                       validated.day == day,
                       validated.year == year {
                        return date
                    }
                }
            }
        }
        return nil
    }
}
