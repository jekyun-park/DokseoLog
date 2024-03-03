//
//  MyBookViewController.swift
//  Bookie
//
//  Created by 박제균 on 2/21/24.
//

import UIKit

// MARK: - MyBookViewController

class MyBookViewController: UIViewController {

  // MARK: Lifecycle

  init(book: Book) {
    self.book = book
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  let book: Book

  var dataViewControllers: [UIViewController] {
    [sentenceViewController, thoughtViewController]
  }

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

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    sentenceViewController.tableView.reloadData()
    thoughtViewController.tableView.reloadData()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    floatingButton.frame = CGRect(
      x: view.frame.size.width - 80,
      y: view.frame.size.height - 180,
      width: 60,
      height: 60)
  }

  // MARK: Private

  private let segmentedControl: UISegmentedControl = {
    let segmentedControl = UnderlineSegmentedControl(items: ["수집한 문장", "생각하기"])
    segmentedControl.translatesAutoresizingMaskIntoConstraints = false
    return segmentedControl
  }()

  private lazy var sentenceViewController: SentenceViewController = {
    let viewController = SentenceViewController(book: book)
    return viewController
  }()

  private lazy var thoughtViewController: ThoughtViewController = {
    let viewController = ThoughtViewController(book: book)
    return viewController
  }()

  private lazy var pageViewController: UIPageViewController = {
    let viewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    viewController.delegate = self
    viewController.dataSource = self
    viewController.view.translatesAutoresizingMaskIntoConstraints = false
    return viewController
  }()

  private lazy var bookInformationButton = UIBarButtonItem(
    image: Images.infoImage,
    style: .plain,
    target: self,
    action: #selector(bookInformationButtonTapped))

  private lazy var deleteButton = UIBarButtonItem(
    image: Images.trashImage,
    style: .plain,
    target: self,
    action: #selector(deleteButtonTapped))

  private lazy var floatingButton: BKFloatingButton = {
    let button = BKFloatingButton(frame: .zero)
    button.addTarget(self, action: #selector(floatingButtonTapped), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  private func setupUI() {
    view.backgroundColor = .bkBackground
    view.addSubviews(segmentedControl, pageViewController.view, floatingButton)

    NSLayoutConstraint.activate([
      segmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor),
      segmentedControl.rightAnchor.constraint(equalTo: view.rightAnchor),
      segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      segmentedControl.heightAnchor.constraint(equalToConstant: 50),
    ])

    NSLayoutConstraint.activate([
      pageViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 4),
      pageViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -4),
      pageViewController.view.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 5),
      pageViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ])
  }

  private func setupSegmentedControl() {
    segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .normal)

    if let hanSansNeoFont = UIFont(name: Fonts.HanSansNeo.bold.rawValue, size: 17) {
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

  private func setupNavigationController() {
    navigationItem.setRightBarButtonItems([deleteButton, bookInformationButton], animated: true)
    navigationController?.navigationBar.prefersLargeTitles = false
    navigationItem.title = book.title
    navigationController?.navigationBar.tintColor = .bkTabBarTint
    bookInformationButton.tintColor = .bkTabBarTint
    deleteButton.tintColor = .red
  }

  @objc
  private func changeValue(control: UISegmentedControl) {
    currentPage = control.selectedSegmentIndex
  }

  @objc
  private func bookInformationButtonTapped() {
    navigationController?.pushViewController(BookInformationViewController(book: book, style: .add), animated: true)
  }

  @objc
  private func floatingButtonTapped() {
    var viewController: AddRecordViewController

    if currentPage == 0 {
      viewController = AddRecordViewController(book: book, style: .sentence)
    } else {
      viewController = AddRecordViewController(book: book, style: .thought)
    }

    if
      let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
      let window = windowScene.windows.first,
      let rootViewController = window.rootViewController as? BKTabBarController
    {
      let vc = rootViewController.viewControllers?[1] as? UINavigationController
      vc?.pushViewController(viewController, animated: true)
    }
  }

  @objc
  private func deleteButtonTapped() {
    presentBKAlertWithDestructiveAction(title: "정말 삭제하시겠습니까?", message: "책을 삭제하면 모든 기록이 함께 삭제됩니다.", buttonTitle: "삭제") {
      let result = PersistenceManager.shared.deleteBook(self.book)
      switch result {
      case .success:
        self.navigationController?.popViewController(animated: true)
      case .failure(let error):
        self.presentBKAlert(title: "책을 삭제하지 못했습니다.", message: error.description, buttonTitle: "확인")
      }
    }
  }

}

// MARK: UIPageViewControllerDelegate

extension MyBookViewController: UIPageViewControllerDelegate {
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

extension MyBookViewController: UIPageViewControllerDataSource {

  func pageViewController(_: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard
      let index = dataViewControllers.firstIndex(of: viewController),
      index - 1 >= 0
    else { return nil }
    return dataViewControllers[index - 1]
  }

  func pageViewController(_: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard
      let index = dataViewControllers.firstIndex(of: viewController),
      index + 1 < dataViewControllers.count
    else { return nil }
    return dataViewControllers[index + 1]
  }
}
