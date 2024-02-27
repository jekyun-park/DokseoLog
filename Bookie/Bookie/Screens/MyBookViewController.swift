//
//  MyBookViewController.swift
//  Bookie
//
//  Created by 박제균 on 2/21/24.
//

import UIKit

class MyBookViewController: UIViewController {

  let book: Book

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

  var dataViewControllers: [UIViewController] {
    [self.sentenceViewController, self.thoughtViewController]
  }

  private lazy var bookInformationButton = UIBarButtonItem(
    image: Images.infoImage,
    style: .plain,
    target: self,
    action: #selector(bookInformationButtonTapped)
  )

  private lazy var deleteButton = UIBarButtonItem(
    image: Images.trashImage,
    style: .plain,
    target: self,
    action: #selector(deleteButtonTapped)
  )

  private lazy var floatingButton: BKFloatingButton = {
    let button = BKFloatingButton(frame: .zero)
    button.addTarget(self, action: #selector(floatingButtonTapped), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

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

  init(book: Book) {
    self.book = book
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupSegmentedControl()
    setupNavigationController()
    setupUI()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.sentenceViewController.tableView.reloadData()
    self.thoughtViewController.tableView.reloadData()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    floatingButton.frame = CGRect(
      x: view.frame.size.width - 80,
      y: view.frame.size.height - 180,
      width: 60,
      height: 60
    )

  }

  private func setupUI() {
    view.backgroundColor = .bkBackground
    view.addSubviews(segmentedControl, pageViewController.view, floatingButton)

    NSLayoutConstraint.activate([
      self.segmentedControl.leftAnchor.constraint(equalTo: self.view.leftAnchor),
      self.segmentedControl.rightAnchor.constraint(equalTo: self.view.rightAnchor),
      self.segmentedControl.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
      self.segmentedControl.heightAnchor.constraint(equalToConstant: 50),
    ])

    NSLayoutConstraint.activate([
      self.pageViewController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 4),
      self.pageViewController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -4),
      self.pageViewController.view.topAnchor.constraint(equalTo: self.segmentedControl.bottomAnchor, constant: 5),
      self.pageViewController.view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
    ])
  }

  private func setupSegmentedControl()  {
    self.segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .normal)

    if let hanSansNeoFont = UIFont(name: Fonts.HanSansNeo.bold.rawValue, size: 17) {
      self.segmentedControl.setTitleTextAttributes(
        [
          NSAttributedString.Key.foregroundColor: UIColor.label,
          .font: hanSansNeoFont
        ],
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

  private func setupNavigationController() {
    self.navigationItem.setRightBarButtonItems([deleteButton, bookInformationButton], animated: true)
    self.navigationController?.navigationBar.prefersLargeTitles = false
    self.navigationItem.title = book.title
    navigationController?.navigationBar.tintColor = .bkTabBarTint
    bookInformationButton.tintColor = .bkTabBarTint
    deleteButton.tintColor = .red
  }

  @objc private func changeValue(control: UISegmentedControl) {
    self.currentPage = control.selectedSegmentIndex
  }

  @objc private func bookInformationButtonTapped() {
    self.navigationController?.pushViewController(BookInformationViewController(book: book, style: .add), animated: true)
  }

  @objc private func floatingButtonTapped() {
    var viewController: AddRecordViewController

    if currentPage == 0 {
      viewController = AddRecordViewController(book: book, style: .sentence)
    } else {
      viewController = AddRecordViewController(book: book, style: .thought)
    }

    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let window = windowScene.windows.first,
       let rootViewController = window.rootViewController as? BKTabBarController {
      let vc = rootViewController.viewControllers?[1] as? UINavigationController
      vc?.pushViewController(viewController, animated: true)
    }
  }

  @objc private func deleteButtonTapped() {
    self.presentBKAlertWithDestructiveAction(title: "정말 삭제하시겠습니까?", message: "책을 삭제하면 모든 기록이 함께 삭제됩니다.", buttonTitle: "삭제") {
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

extension MyBookViewController: UIPageViewControllerDelegate {
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

extension MyBookViewController: UIPageViewControllerDataSource {

  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard
      let index = self.dataViewControllers.firstIndex(of: viewController),
      index - 1 >= 0
    else { return nil }
    return self.dataViewControllers[index - 1]
  }

  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard
      let index = self.dataViewControllers.firstIndex(of: viewController),
      index + 1 < self.dataViewControllers.count
    else { return nil }
    return self.dataViewControllers[index + 1]
  }
}
