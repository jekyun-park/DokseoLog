//
//  Constants.swift
//  Bookie
//
//  Created by 박제균 on 2023/08/11.
//

import UIKit

// MARK: - Images

enum Images {
  static let searchTabBarImage = UIImage(systemName: "magnifyingglass")
  static let bookCaseTabBarImage = UIImage(systemName: "books.vertical.fill")
  static let habitTabBarImage = UIImage(systemName: "figure.mind.and.body")
  static let settingsTabBarImage = UIImage(systemName: "gearshape.2.fill")
  static let placeholderBookImage = UIImage(systemName: "book")
  static let basketBarButtonImage = UIImage(systemName: "basket.fill")
  static let addBookBarButtonImage = UIImage(systemName: "plus")
  static let icloudLinkImage = UIImage(systemName: "link.icloud")
}

// MARK: - Fonts

enum Fonts {
  enum HanSansNeo: String {
    case bold = "SpoqaHanSansNeo-Bold"
    case medium = "SpoqaHanSansNeo-Medium"
    case light = "SpoqaHanSansNeo-Light"
    case thin = "SpoqaHanSansNeo-Thin"
    case regular = "SpoqaHanSansNeo-Regular"
  }
}

enum UserDefaultsKey {
  static let isFirstLaunch = "isFirstLaunch"
  static let isContinueWithoutLogin = "isContinueWithoutLogin"
}
