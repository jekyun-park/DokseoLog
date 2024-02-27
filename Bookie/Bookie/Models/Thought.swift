//
//  Thought.swift
//  Bookie
//
//  Created by 박제균 on 2/22/24.
//

import Foundation

struct Thought {
  var book: Book
  var memo: String
  var id = UUID()
  var createdAt = Date()
}
