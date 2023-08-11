//
//  BKTabBarController.swift
//  Bookie
//
//  Created by 박제균 on 2023/08/11.
//

import UIKit

class BKTabBarController: UITabBarController {

  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
  }

  private func configure() {
    viewControllers = createNavigationControllers()
    view.backgroundColor = .systemBackground

    let appearance = UITabBarAppearance()
    appearance.configureWithOpaqueBackground()
    UITabBar.appearance().tintColor = .systemGreen
    UITabBar.appearance().standardAppearance = appearance
    UITabBar.appearance().scrollEdgeAppearance = appearance
  }

  private func createNavigationControllers() -> [UIViewController] {
    let homeViewController = HomeViewController()
    homeViewController.title = "Bookie"
    homeViewController.tabBarItem = UITabBarItem(title: "홈", image: Images.homeTabBarImage, tag: 0)
    let homeNavigationController = UINavigationController(rootViewController: homeViewController)
    homeNavigationController.navigationBar.prefersLargeTitles = true

    let searchViewController = SearchViewController()
    searchViewController.title = "도서 검색하기"
    searchViewController.tabBarItem = UITabBarItem(title: "검색", image: Images.searchTabBarImage, tag: 1)
    let searchNavigationController = UINavigationController(rootViewController: searchViewController)
    searchNavigationController.navigationBar.prefersLargeTitles = true

    let bookCaseViewController = BookCaseViewController()
    bookCaseViewController.title = "내 책장"
    bookCaseViewController.tabBarItem = UITabBarItem(title: "내 책장", image: Images.bookCaseTabBarImage, tag: 2)
    let bookCaseNavigationController = UINavigationController(rootViewController: bookCaseViewController)
    bookCaseNavigationController.navigationBar.prefersLargeTitles = true

    let habitViewController = HabitsViewController()
    habitViewController.title = "나의 독서습관"
    habitViewController.tabBarItem = UITabBarItem(title: "독서 습관", image: Images.habitTabBarImage, tag: 3)
    let habitNavigationController = UINavigationController(rootViewController: habitViewController)
    habitNavigationController.navigationBar.prefersLargeTitles = true

    let settingViewController = SettingsViewController()
    settingViewController.title = "설정"
    settingViewController.tabBarItem = UITabBarItem(title: "설정", image: Images.settingsTabBarImage, tag: 4)
    let settingNavigationController = UINavigationController(rootViewController: settingViewController)
    settingNavigationController.navigationBar.prefersLargeTitles = true

    return [homeNavigationController, searchNavigationController, bookCaseNavigationController, habitNavigationController, settingNavigationController]
  }

}
