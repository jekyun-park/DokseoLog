//
//  BKError.swift
//  Bookie
//
//  Created by 박제균 on 10/31/23.
//

import Foundation

enum BKError: Error {
  case invalidAPIKey
  case invalidURL
  case invalidResponse
  case invalidData
  case noData
  case unableToComplete

  var description: String {
    switch self {
    case .invalidAPIKey:
      return "API 키가 잘못되었습니다. 개발자에게 문의하거나 다시 시도해 주세요."
    case .invalidURL:
      return "잘못된 URL입니다. 개발자에게 문의하거나 다시 시도해 주세요."
    case .invalidResponse:
      return "잘못된 응답입니다. 개발자에게 문의하거나 다시 시도해 주세요."
    case .invalidData:
      return "서버로부터 받은 데이터에 오류가 있습니다. 개발자에게 문의하거나 다시 시도해 주세요."
    case .noData:
      return "요청한 데이터가 존재하지 않습니다. 개발자에게 문의하거나 다시 시도해 주세요."
    case .unableToComplete:
      return "데이터 요청에 실패했습니다. 개발자에게 문의하거나 다시 시도해 주세요."
    }
  }
}
