//
//  BookCaseViewController.swift
//  Bookie
//
//  Created by 박제균 on 2023/08/11.
//

import UIKit

class BookCaseViewController: UIViewController {

  private let segmentedControl: UISegmentedControl = {
    let segmentedControl = UnderlineSegmentedControl(items: ["내 책장", "책바구니"])
    segmentedControl.translatesAutoresizingMaskIntoConstraints = false
    return segmentedControl
  }()

  private let myBookViewController: MyBookViewController = {
    let viewController = MyBookViewController()
    return viewController
  }()

  private let bookBasketViewController: BookBasketViewController = {
    let viewController = BookBasketViewController()
    return viewController
  }()

  private lazy var pageViewController: UIPageViewController = {
    let viewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    viewController.delegate = self
    viewController.dataSource = self
    viewController.view.translatesAutoresizingMaskIntoConstraints = false
    return viewController
  }()

  var dataViewControllers: [UIViewController] {
    [self.myBookViewController, self.bookBasketViewController]
  }

  /// 현재 페이지의 인덱스를 나타낸다.
  /// currentPage의 값에 따라 UIPageViewController의 방향을 결정한다
  /// 이전 값이 현재 값보다 작거나 같다면, forward 이동, 아니라면 reverse 이동.
  /// print("이전 페이지: \(oldValue)", "현재 페이지: \(self.currentPage)")
  var currentPage: Int = 0 {
    didSet {
      let direction: UIPageViewController.NavigationDirection = oldValue <= self.currentPage ? .forward : .reverse
      self.pageViewController.setViewControllers(
        [dataViewControllers[self.currentPage]],
        direction: direction,
        animated: true,
        completion: nil
      )
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupSegmentedControl()
    setupNavigationController()
    setupUI()
  }

  private func setupUI() {
    self.view.addSubview(self.segmentedControl)
    self.view.addSubview(self.pageViewController.view)

    NSLayoutConstraint.activate([
      self.segmentedControl.leftAnchor.constraint(equalTo: self.view.leftAnchor),
      self.segmentedControl.rightAnchor.constraint(equalTo: self.view.rightAnchor),
      self.segmentedControl.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80),
      self.segmentedControl.heightAnchor.constraint(equalToConstant: 50),
    ])

    NSLayoutConstraint.activate([
      self.pageViewController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 4),
      self.pageViewController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -4),
      self.pageViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -4),
      self.pageViewController.view.topAnchor.constraint(equalTo: self.segmentedControl.bottomAnchor, constant: 5),
    ])
  }

  private func setupSegmentedControl()  {
    self.segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .normal)

    if let hanSansNeoFont = UIFont(name: Fonts.HanSansNeo.bold.rawValue, size: 17) {
      self.segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.label, .font: hanSansNeoFont],
                                                   for: .selected
      )
    } else {
      self.segmentedControl.setTitleTextAttributes(
        [
          NSAttributedString.Key.foregroundColor: UIColor.label,
          .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
        ],
        for: .selected
      )
    }

    self.segmentedControl.addTarget(self, action: #selector(changeValue(control:)), for: .valueChanged)
    self.segmentedControl.selectedSegmentIndex = 0
    self.changeValue(control: self.segmentedControl)
  }

  @objc private func changeValue(control: UISegmentedControl) {
    self.currentPage = control.selectedSegmentIndex
  }

  private func setupNavigationController() {
    self.navigationController?.navigationBar.prefersLargeTitles = false
    self.navigationItem.title = nil
  }

}

extension BookCaseViewController: UIPageViewControllerDelegate {
  func pageViewController(
    _ pageViewController: UIPageViewController,
    didFinishAnimating finished: Bool,
    previousViewControllers: [UIViewController],
    transitionCompleted completed: Bool
  ) {
    guard
      let viewController = pageViewController.viewControllers?[0],
      let index = self.dataViewControllers.firstIndex(of: viewController)
    else { return }
    self.currentPage = index
    self.segmentedControl.selectedSegmentIndex = index
  }
}

extension BookCaseViewController: UIPageViewControllerDataSource {

  func pageViewController(
    _ pageViewController: UIPageViewController,
    viewControllerBefore viewController: UIViewController
  ) -> UIViewController? {
    guard
      let index = self.dataViewControllers.firstIndex(of: viewController),
      index - 1 >= 0
    else { return nil }
    return self.dataViewControllers[index - 1]
  }

  func pageViewController(
    _ pageViewController: UIPageViewController,
    viewControllerAfter viewController: UIViewController
  ) -> UIViewController? {
    guard
      let index = self.dataViewControllers.firstIndex(of: viewController),
      index + 1 < self.dataViewControllers.count
    else { return nil }
    return self.dataViewControllers[index + 1]
  }
}
