//
//  Bundle+.swift
//  DokseoLog
//
//  Created by 박제균 on 10/31/23.
//

import Foundation

extension Bundle {

  var APIKey: String {
    Bundle.main.object(forInfoDictionaryKey: "SEARCH_API_KEY") as? String ?? BKError.invalidAPIKey.description
  }
}
