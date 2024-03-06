//
//  UserDefaultsManager.swift
//  Bookie
//
//  Created by 박제균 on 1/31/24.
//

import Foundation

final class UserDefaultsManager {

  // MARK: Lifecycle

  private init() { }

  // MARK: Internal

  static let shared = UserDefaultsManager()

  /// 앱을 설치하고 처음 켜는지 확인하는 변수
  var isLaunchedBefore: Bool {
    UserDefaults.standard.bool(forKey: UserDefaultsKey.isFirstLaunch)
  }

//  /// 로그인 없이
//  var isContinueWithoutLogin: Bool {
//    UserDefaults.standard.bool(forKey: UserDefaultsKey.isContinueWithoutLogin)
//  }

  /// 앱을 설치하고 처음 켜는지 확인하는 변수를 true로 set해주는 함수
  func setLaunchedBefore() {
    UserDefaults.standard.setValue(true, forKey: UserDefaultsKey.isFirstLaunch)
  }

}
