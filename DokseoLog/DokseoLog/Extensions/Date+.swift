//
//  Date+.swift
//  DokseoLog
//
//  Created by 박제균 on 2/22/24.
//

import Foundation

extension Date {

  func formattedWithTime() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd, HH:mm"
    return dateFormatter.string(from: self)
  }

  func formattedWithDay() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.string(from: self)
  }

  func isSameDay(_ date: Date) -> Bool {
    let calendar = Calendar.current

    let selfDate = calendar.dateComponents([.month, .day], from: self)
    let compareDate = calendar.dateComponents([.month, .day], from: date)

    return selfDate == compareDate
  }

}
