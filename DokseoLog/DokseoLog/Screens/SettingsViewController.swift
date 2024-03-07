//
//  SettingsViewController.swift
//  Bookie
//
//  Created by 박제균 on 2023/08/11.
//

import UIKit

class SettingsViewController: UIViewController {

  let tableView = UITableView()

  override func viewDidLoad() {
    super.viewDidLoad()
    configureTableView()
  }

  private func configureTableView() {
    tableView.backgroundColor = .bkBackground
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

extension SettingsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.row {
    case 0:
      // App version
      let cell = UITableViewCell()
      var configuration = UIListContentConfiguration.cell()
      cell.backgroundColor = .bkBackground
      let color = configuration.textProperties.color
      configuration.text = "앱 버전"
      configuration.secondaryText = Versioning.appVersion
      configuration.prefersSideBySideTextAndSecondaryText = true
      cell.isUserInteractionEnabled = false
      cell.selectionStyle = .none
      configuration.textProperties.color = color
      cell.contentConfiguration = configuration
      return cell
    case 1:
      return UITableViewCell()
    case 2:
      return UITableViewCell()
    default:
      return UITableViewCell()
    }
  }

}

extension SettingsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    switch indexPath.row {
    case 0:
      return nil
    default: break
    }
    return indexPath
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.row {
    case 1:
      break
    case 2:
      break
    default: break
    }
  }
}
