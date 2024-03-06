//
//  DateRecordViewController.swift
//  Bookie
//
//  Created by 박제균 on 3/5/24.
//

import UIKit

class DateRecordViewController: UIViewController {

  let date: Date
  let tableView = UITableView()
  var data: [Any] = []

  init(date: Date) {
    self.date = date
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureViewController()
    configureTableView()
    getData()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    getData()
  }

  private func getData() {
    data.removeAll()
    let result = PersistenceManager.shared.fetchRecords(date)
    switch result {
    case .success(let results):
      data.append(contentsOf: results.sentences)
      data.append(contentsOf: results.thoughts)
    case .failure(let error):
      presentBKAlert(title: "데이터를 가져오지 못했어요", message: error.description, buttonTitle: "확인")
      self.navigationController?.popViewController(animated: true)
    }
    tableView.reloadData()
  }

  private func configureViewController() {
    view.backgroundColor = .bkBackgroundColor
    navigationController?.navigationBar.isHidden = false
    navigationController?.navigationBar.tintColor = .bkTabBarTint
    self.title = "\(date.formattedWithDay()) 의 기록"
  }

  private func configureTableView() {
    tableView.register(SentenceTableViewCell.self, forCellReuseIdentifier: SentenceTableViewCell.reuseID)
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

extension DateRecordViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let sentence = data[indexPath.row] as? Sentence {
      let viewController = ModifyRecordViewController(sentence: sentence, style: .withBookInformation)
      self.navigationController?.pushViewController(viewController, animated: true)
    } else if let thought = data[indexPath.row] as? Thought {
      let viewController = ModifyRecordViewController(thought: thought, style: .withBookInformation)
      self.navigationController?.pushViewController(viewController, animated: true)
    } else {
      self.presentBKAlert(title: "기록을 가져올 수 없어요.", message: BKError.failToFetchData.description, buttonTitle: "확인")
    }
  }
}

extension DateRecordViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    if let sentence = data[indexPath.row] as? Sentence {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: SentenceTableViewCell.reuseID, for: indexPath) as? SentenceTableViewCell else {
        return UITableViewCell()
      }
      cell.setContents(sentence: sentence)
      cell.separatorInset = UIEdgeInsets.zero
      return cell
    } else if let thought = data[indexPath.row] as? Thought {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: ThoughtTableViewCell.reuseID, for: indexPath) as? ThoughtTableViewCell else {
        return UITableViewCell()
      }
      cell.setContents(thought: thought)
      cell.separatorInset = UIEdgeInsets.zero
      return cell
    } else {
      return UITableViewCell()
    }
  }

}
