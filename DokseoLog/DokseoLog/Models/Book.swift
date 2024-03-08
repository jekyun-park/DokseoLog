//
//  Book.swift
//  DokseoLog
//
//  Created by 박제균 on 2/20/24.
//

import Foundation

// MARK: - Book

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
    title = dto.title
    link = dto.link
    author = dto.author
    description = dto.description
    publishedAt = dto.pubDate
    publisher = dto.publisher
    isbn13 = dto.isbn13
    coverURL = dto.coverURL
    page = dto.subInfo?.itemPage
  }
}
