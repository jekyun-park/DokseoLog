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
  let items: [Item]

  enum CodingKeys: String, CodingKey {
    case version, logo, title, link, pubDate, totalResults, startIndex, itemsPerPage, query, searchCategoryName
    case searchCategoryID = "searchCategoryId"
    case items = "item"
  }
}

// MARK: - Item

struct Item: Codable {
  enum CodingKeys: String, CodingKey {
    case title, link, author, pubDate, description, isbn, isbn13
    case itemID = "itemId"
    case priceSales, priceStandard, mallType, stockStatus, mileage
    case coverURL = "cover"
    case categoryID = "categoryId"
    case categoryName, publisher, salesPoint, adult, fixedPrice, customerReviewRank, subInfo, seriesInfo
  }

  let title: String
  let link: String
  let author, pubDate, description, isbn: String
  let isbn13: String
  let itemID, priceSales, priceStandard: Int
  let mallType: MallType
  let stockStatus: String
  let mileage: Int
  let coverURL: String
  let categoryID: Int
  let categoryName, publisher: String
  let salesPoint: Int
  let adult, fixedPrice: Bool
  let customerReviewRank: Int
  let subInfo: SubInfo
  let seriesInfo: SeriesInfo?

}

// MARK: - MallType

enum MallType: String, Codable {
  case book = "BOOK"
}

// MARK: - SeriesInfo

struct SeriesInfo: Codable {
  let seriesID: Int
  let seriesLink: String
  let seriesName: String

  enum CodingKeys: String, CodingKey {
    case seriesID = "seriesId"
    case seriesLink, seriesName
  }
}

// MARK: - SubInfo

struct SubInfo: Codable { }
