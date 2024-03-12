//
//  SentenceViewController.swift
//  DokseoLog
//
//  Created by 박제균 on 2/21/24.
//

import CoreData
import UIKit

// MARK: - SentenceViewController

class SentenceViewController: UIViewController {

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
  var sentences = [Sentence]()

  override func viewDidLoad() {
    super.viewDidLoad()
    getSentences()
    setupUI()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    getSentences()
    setupUI()
  }

  // MARK: Private

  private lazy var emptyLabel: DLBodyLabel = {
    let label = DLBodyLabel(textAlignment: .center, fontSize: 16, fontWeight: .medium)
    label.text = "인상깊었던 문장을 추가해보세요."
    return label
  }()

  private func getSentences() {
    sentences.removeAll()
    let result = PersistenceManager.shared.fetchSentences(book)
    switch result {
    case .success(let results):
      sentences = results
    case .failure(let error):
      presentDLAlert(title: "저장된 문장을 불러올 수 없어요.", message: error.description, buttonTitle: "확인")
    }
  }

  private func setupUI() {
    if sentences.isEmpty {
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
    view.backgroundColor = .dlBackgroundColor
    navigationController?.navigationBar.isHidden = false
    navigationController?.navigationItem.hidesSearchBarWhenScrolling = false
  }

  private func configureTableView() {
    tableView.register(SentenceTableViewCell.self, forCellReuseIdentifier: SentenceTableViewCell.reuseID)
    tableView.isScrollEnabled = true
    tableView.separatorStyle = .singleLine
    tableView.showsVerticalScrollIndicator = false

    tableView.backgroundColor = .dlBackgroundColor
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

extension SentenceViewController: UITableViewDataSource {

  func numberOfSections(in _: UITableView) -> Int {
    1
  }

  func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
    sentences.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: SentenceTableViewCell.reuseID) as? SentenceTableViewCell
    else { return UITableViewCell() }

    let sentence = sentences[indexPath.row]
    cell.setContents(sentence: sentence)
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

extension SentenceViewController: UITableViewDelegate {
  func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
    // move to detail view
    // then update data or delete data
    let sentence = sentences[indexPath.row]
    let viewController = ModifyRecordViewController(sentence: sentence, style: .withoutBookInformation)
//    self.navigationController?.pushViewController(viewController, animated: true)
    if
      let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
      let window = windowScene.windows.first,
      let rootViewController = window.rootViewController as? DLTabBarController
    {
      let vc = rootViewController.viewControllers?[1] as? UINavigationController
      vc?.pushViewController(viewController, animated: true)
    }
//    let navigationViewController = UINavigationController(rootViewController: viewController)
//    self.present(navigationViewController, animated: true)
  }
}
