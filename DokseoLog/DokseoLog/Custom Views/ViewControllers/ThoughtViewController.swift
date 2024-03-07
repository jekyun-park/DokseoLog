//
//  ThoughtViewController.swift
//  Bookie
//
//  Created by 박제균 on 2/21/24.
//

import UIKit

// MARK: - ThoughtViewController

class ThoughtViewController: UIViewController {

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
  let tableView = UITableView()
  var thoughts = [Thought]()

  private lazy var emptyLabel: BKBodyLabel = {
    let label = BKBodyLabel(textAlignment: .center, fontSize: 16, fontWeight: .medium)
    label.text = "책을 읽으며 했던 생각을 추가해보세요."
    return label
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    getThoughts()
    setupUI()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    getThoughts()
    setupUI()
  }

  // MARK: Private

  private func getThoughts() {
    thoughts.removeAll()
    let result = PersistenceManager.shared.fetchThoughts(book)

    switch result {
    case .success(let results):
      thoughts = results
    case .failure(let error):
      presentBKAlert(title: "저장된 데이터를 불러올 수 없어요.", message: error.description, buttonTitle: "확인")
    }
  }

  private func setupUI() {
    if thoughts.isEmpty {
      setupEmptyState()
    } else {
      configureTableView()
      tableView.reloadData()
    }
    configureViewController()
  }

  private func setupEmptyState() {
      view.addSubviews(emptyLabel)
      NSLayoutConstraint.activate([
        emptyLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
        emptyLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
        emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
        emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
        emptyLabel.heightAnchor.constraint(equalToConstant: 24),
      ])
  }

  private func configureViewController() {
    view.backgroundColor = .bkBackgroundColor
    navigationController?.navigationBar.isHidden = false
    navigationController?.navigationItem.hidesSearchBarWhenScrolling = false
  }

  private func configureTableView() {
    tableView.register(ThoughtTableViewCell.self, forCellReuseIdentifier: ThoughtTableViewCell.reuseID)
    tableView.isScrollEnabled = true
    tableView.separatorStyle = .singleLine
    tableView.showsVerticalScrollIndicator = false

    tableView.backgroundColor = .bkBackgroundColor
    tableView.translatesAutoresizingMaskIntoConstraints = false

    tableView.delegate = self
    tableView.dataSource = self
    view.addSubview(tableView)

    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ])
  }

}

// MARK: UITableViewDataSource

extension ThoughtViewController: UITableViewDataSource {

  func numberOfSections(in _: UITableView) -> Int {
    1
  }

  func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
    thoughts.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: ThoughtTableViewCell.reuseID) as? ThoughtTableViewCell
    else { return UITableViewCell() }

    let thought = thoughts[indexPath.row]
    cell.setContents(thought: thought)
    cell.separatorInset = UIEdgeInsets.zero
    return cell
  }

  func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
    UITableView.automaticDimension
  }

  func tableView(_: UITableView, estimatedHeightForRowAt _: IndexPath) -> CGFloat {
    600
  }
}

// MARK: UITableViewDelegate

extension ThoughtViewController: UITableViewDelegate {
  func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
    // move to detail view
    // then update data or delete data
    let thought = thoughts[indexPath.row]
    let viewController = ModifyRecordViewController(thought: thought, style: .withoutBookInformation)
//    self.navigationController?.pushViewController(viewController, animated: true)

    if
      let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
      let window = windowScene.windows.first,
      let rootViewController = window.rootViewController as? BKTabBarController
    {
      let vc = rootViewController.viewControllers?[1] as? UINavigationController
      vc?.pushViewController(viewController, animated: true)
    }
//    let navigationViewController = UINavigationController(rootViewController: viewController)
//    self.present(navigationViewController, animated: true)
  }
}
