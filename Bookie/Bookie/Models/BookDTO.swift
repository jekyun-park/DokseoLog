//
//  Book.swift
//  Bookie
//
//  Created by 박제균 on 2/8/24.
//

// MARK: - Book

struct BookDTO: Codable {
  enum CodingKeys: String, CodingKey {
    case title, link, author, pubDate, description, isbn, isbn13
    case itemID = "itemId"
    case priceSales, priceStandard, mallType, stockStatus, mileage
    case coverURL = "cover"
    case categoryID = "categoryId"
    case categoryName, publisher, salesPoint, adult, customerReviewRank, seriesInfo, subInfo, fixedPrice
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
  let adult: Bool
  let customerReviewRank: Int
  let seriesInfo: SeriesInfo?
  let subInfo: SubInfo?
  let fixedPrice: Bool?
}

extension BookDTO {
  func toModel() -> Book {
    return Book(dto: self)
  }
}
