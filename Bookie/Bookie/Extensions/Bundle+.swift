//
//  Bundle+.swift
//  Bookie
//
//  Created by 박제균 on 10/31/23.
//

import Foundation

extension Bundle {
  var apiKey: String? {
          guard let file = self.path(forResource: "Info", ofType: "plist"),
                let resource = NSDictionary(contentsOfFile: file),
                let key = resource["SEARCH_API_KEY"] as? String else {
              return nil
          }
          return key
      }
}
