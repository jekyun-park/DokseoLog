//
//  BookCaseViewController.swift
//  DokseoLog
//
//  Created by 박제균 on 2023/08/11.
//

import UIKit

// MARK: - BookCaseViewController

class BookCaseViewController: UIViewController {

  // MARK: Internal

  var dataViewControllers: [UIViewController] {
    [myBookViewController, wishListViewController]
  }

  /// 현재 페이지의 인덱스를 나타낸다.
  /// currentPage의 값에 따라 UIPageViewController의 방향을 결정한다
  /// 이전 값이 현재 값보다 작거나 같다면, forward 이동, 아니라면 reverse 이동.
  /// print("이전 페이지: \(oldValue)", "현재 페이지: \(self.currentPage)")
  var currentPage = 0 {
    didSet {
      let direction: UIPageViewController.NavigationDirection = oldValue <= self.currentPage ? .forward : .reverse
      self.pageViewController.setViewControllers(
        [dataViewControllers[self.currentPage]],
        direction: direction,
        animated: true,
        completion: nil)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupSegmentedControl()
    setupNavigationController()
    setupUI()
  }

  // MARK: Private

  private let segmentedControl: UISegmentedControl = {
    let segmentedControl = UnderlineSegmentedControl(items: ["내 책장", "위시리스트"])
    segmentedControl.translatesAutoresizingMaskIntoConstraints = false
    return segmentedControl
  }()

  private let myBookViewController: MyBookCaseViewController = {
    let viewController = MyBookCaseViewController()
    return viewController
  }()

  private let wishListViewController: WishListViewController = {
    let viewController = WishListViewController()
    return viewController
  }()

  private lazy var pageViewController: UIPageViewController = {
    let viewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    viewController.delegate = self
    viewController.dataSource = self
    viewController.view.translatesAutoresizingMaskIntoConstraints = false
    return viewController
  }()

  private func setupUI() {
    view.addSubview(segmentedControl)
    view.addSubview(pageViewController.view)

    NSLayoutConstraint.activate([
      segmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor),
      segmentedControl.rightAnchor.constraint(equalTo: view.rightAnchor),
      segmentedControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
      segmentedControl.heightAnchor.constraint(equalToConstant: 50),
    ])

    NSLayoutConstraint.activate([
      pageViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 4),
      pageViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -4),
      pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -4),
      pageViewController.view.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 5),
    ])
  }

  private func setupSegmentedControl() {
    segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .normal)

    if let hanSansNeoFont = UIFont(name: Fonts.HanSansNeo.bold.description, size: 17) {
      segmentedControl.setTitleTextAttributes(
        [
          NSAttributedString.Key.foregroundColor: UIColor.label,
          .font: hanSansNeoFont,
        ],
        for: .selected)
    } else {
      segmentedControl.setTitleTextAttributes(
        [
          NSAttributedString.Key.foregroundColor: UIColor.label,
          .font: UIFont.systemFont(ofSize: 17, weight: .semibold),
        ],
        for: .selected)
    }

    segmentedControl.addTarget(self, action: #selector(changeValue(control:)), for: .valueChanged)
    segmentedControl.selectedSegmentIndex = 0
    changeValue(control: segmentedControl)
  }

  @objc
  private func changeValue(control: UISegmentedControl) {
    currentPage = control.selectedSegmentIndex
  }

  private func setupNavigationController() {
    navigationController?.navigationBar.prefersLargeTitles = false
    navigationItem.title = nil
  }

}

// MARK: UIPageViewControllerDelegate

extension BookCaseViewController: UIPageViewControllerDelegate {
  func pageViewController(
    _ pageViewController: UIPageViewController,
    didFinishAnimating _: Bool,
    previousViewControllers _: [UIViewController],
    transitionCompleted _: Bool)
  {
    guard
      let viewController = pageViewController.viewControllers?[0],
      let index = dataViewControllers.firstIndex(of: viewController)
    else { return }
    currentPage = index
    segmentedControl.selectedSegmentIndex = index
  }
}

// MARK: UIPageViewControllerDataSource

extension BookCaseViewController: UIPageViewControllerDataSource {

  func pageViewController(_: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard
      let index = dataViewControllers.firstIndex(of: viewController),
      index - 1 >= 0
    else { return nil }
    return dataViewControllers[index - 1]
  }

  func pageViewController(
    _: UIPageViewController,
    viewControllerAfter viewController: UIViewController)
    -> UIViewController?
  {
    guard
      let index = dataViewControllers.firstIndex(of: viewController),
      index + 1 < dataViewControllers.count
    else { return nil }
    return dataViewControllers[index + 1]
  }
}
