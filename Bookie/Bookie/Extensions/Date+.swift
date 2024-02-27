//
//  Date+.swift
//  Bookie
//
//  Created by 박제균 on 2/22/24.
//

import Foundation

extension Date {

  func formatted() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd, HH:mm"
    return dateFormatter.string(from: self)
  }
}
