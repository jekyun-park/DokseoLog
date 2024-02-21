//
//  Book.swift
//  Bookie
//
//  Created by 박제균 on 2/20/24.
//

import Foundation

struct Book {
  var title: String
  var link: String
  var author: String
  var description: String
  var publishedAt: String
  var isbn13: String
  var coverURL: String
  var publisher: String
  var page: Int?
}

extension Book {
  init(dto: BookDTO) {
    self.title = dto.title
    self.link = dto.link
    self.author = dto.author
    self.description = dto.description
    self.publishedAt = dto.pubDate
    self.publisher = dto.publisher
    self.isbn13 = dto.isbn13
    self.coverURL = dto.coverURL
    self.page = dto.subInfo?.itemPage
  }
}
