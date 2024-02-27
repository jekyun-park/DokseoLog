//
//  Sentence.swift
//  Bookie
//
//  Created by 박제균 on 2/22/24.
//

import Foundation

struct Sentence {
  var book: Book
  var page: Int
  var memo: String
  var id = UUID()
  var createdAt = Date()
}
