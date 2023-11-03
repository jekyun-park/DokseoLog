//
//  BKError.swift
//  Bookie
//
//  Created by 박제균 on 10/31/23.
//

import Foundation

enum BKError: String, Error {
  case invalidAPIKey = "API 키가 잘못되었습니다. 개발자에게 문의하거나 다시 시도해 주세요."
  case invalidURL = "잘못된 URL입니다. 개발자에게 문의하거나 다시 시도해 주세요."
  case invalidResponse = "잘못된 응답입니다. 개발자에게 문의하거나 다시 시도해 주세요."
  case invalidData = "서버로부터 받은 데이터에 오류가 있습니다. 개발자에게 문의하거나 다시 시도해 주세요."
  case unableToComplete = "데이터 요청에 실패했습니다. 개발자에게 문의하거나 다시 시도해 주세요."
}
