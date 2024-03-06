//
//  BKTabBarController.swift
//  Bookie
//
//  Created by 박제균 on 2023/08/11.
//

import UIKit

class BKTabBarController: UITabBarController {

  // MARK: Internal

  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }

  // MARK: Private

  private func configureUI() {
    viewControllers = createNavigationControllers()
    view.backgroundColor = .bkBackgroundColor
    tabBar.tintColor = .bkTabBarTintColor

    let appearance = UITabBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = .bkTabBarBackgroundColor
    UITabBar.appearance().standardAppearance = appearance
    UITabBar.appearance().scrollEdgeAppearance = appearance
  }

  private func createNavigationControllers() -> [UIViewController] {
    let searchViewController = SearchViewController()
    searchViewController.title = "책 검색"
    searchViewController.tabBarItem = UITabBarItem(title: "검색", image: Images.searchTabBarImage, tag: 0)
    let searchNavigationController = UINavigationController(rootViewController: searchViewController)
    searchNavigationController.navigationBar.prefersLargeTitles = false
    searchNavigationController.view.backgroundColor = .bkBackgroundColor

    let bookCaseViewController = BookCaseViewController()
    bookCaseViewController.title = "책장"
    bookCaseViewController.tabBarItem = UITabBarItem(title: "책장", image: Images.bookCaseTabBarImage, tag: 1)
    let bookCaseNavigationController = UINavigationController(rootViewController: bookCaseViewController)
    bookCaseNavigationController.navigationBar.prefersLargeTitles = true

    let calendarViewController = CalendarViewController()
    calendarViewController.title = "달력"
    calendarViewController.tabBarItem = UITabBarItem(title: "달력", image: Images.calendarImage, tag: 2)
    let habitNavigationController = UINavigationController(rootViewController: calendarViewController)
    habitNavigationController.navigationBar.prefersLargeTitles = true

    let settingViewController = SettingsViewController()
    settingViewController.title = "설정"
    settingViewController.tabBarItem = UITabBarItem(title: "설정", image: Images.settingsTabBarImage, tag: 3)
    let settingNavigationController = UINavigationController(rootViewController: settingViewController)
    settingNavigationController.navigationBar.prefersLargeTitles = true

    return [
      searchNavigationController,
      bookCaseNavigationController,
      habitNavigationController,
      settingNavigationController,
    ]
  }

}
