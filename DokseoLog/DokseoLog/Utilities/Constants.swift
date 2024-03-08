//
//  Constants.swift
//  DokseoLog
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
  static let moveToBookCaseBarButtonImage = UIImage(systemName: "arrow.left.arrow.right.square.fill")
  static let plusButtonImage = UIImage(systemName: "plus")
  static let icloudLinkImage = UIImage(systemName: "link.icloud")
  static let infoImage = UIImage(systemName: "info.circle")
  static let xImage = UIImage(systemName: "xmark")
  static let saveRecordImage = UIImage(systemName: "xmark")
  static let trashImage = UIImage(systemName: "trash")
  static let calendarImage = UIImage(systemName: "calendar")
}

// MARK: - Fonts

enum Fonts {
  enum HanSansNeo{
    case bold, medium, light, thin, regular

    var description: String {
      switch self {
      case .bold:
        return "SpoqaHanSansNeo-Bold"
      case .medium:
        return "SpoqaHanSansNeo-Medium"
      case .light:
        return "SpoqaHanSansNeo-Light"
      case .thin:
        return "SpoqaHanSansNeo-Thin"
      case .regular:
        return "SpoqaHanSansNeo-Regular"
      }
    }
  }
}

// MARK: - UserDefaultsKey

enum UserDefaultsKey {
  static let isFirstLaunch = "isFirstLaunch"
  static let isContinueWithoutLogin = "isContinueWithoutLogin"
}

/// 버전 관리 관련 Constant
enum Versioning {
  static var appVersion: String? {
    guard let dictionary = Bundle.main.infoDictionary,
        let version = dictionary["CFBundleShortVersionString"] as? String else { return nil }
    return version
  }
}
