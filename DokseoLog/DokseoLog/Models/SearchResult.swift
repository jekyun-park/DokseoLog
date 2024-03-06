//
//  SearchResult.swift
//  Bookie
//
//  Created by 박제균 on 11/3/23.
//

import Foundation

// MARK: - SearchResult

struct SearchResult: Codable {
  let version: String
  let logo: String
  let title: String
  let link: String
  let pubDate: String
  let totalResults, startIndex, itemsPerPage: Int
  let query: String
  let searchCategoryID: Int
  let searchCategoryName: String
  let books: [BookDTO]

  enum CodingKeys: String, CodingKey {
    case version, logo, title, link, pubDate, totalResults, startIndex, itemsPerPage, query
    case searchCategoryID = "searchCategoryId"
    case searchCategoryName
    case books = "item"
  }
}

// MARK: - MallType

enum MallType: String, Codable {
  case book = "BOOK"
  case foreign = "FOREIGN"
  case music = "MUSIC"
  case dvd = "DVD"
  case used = "USED"
  case ebook = "EBOOK"
}
