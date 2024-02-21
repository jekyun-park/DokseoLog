//
//  SeriesInfo.swift
//  Bookie
//
//  Created by 박제균 on 2/8/24.
//

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
