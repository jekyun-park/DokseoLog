//
//  SettingsViewController.swift
//  DokseoLog
//
//  Created by 박제균 on 2023/08/11.
//

import SafariServices
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

  private func showEmailWithTemplate(subject: String, body: String) {
    var components = URLComponents()
    components.scheme = "mailto"
    components.path = "jegyun@icloud.com"
    components.queryItems = [
      URLQueryItem(name: "subject", value: subject),
      URLQueryItem(name: "body", value: body)
    ]

    guard let url = components.url else { return }

    if UIApplication.shared.canOpenURL(url) {
      UIApplication.shared.open(url)
    }
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
      // 문의/의견 보내기
      let cell = UITableViewCell()
      var configuration = UIListContentConfiguration.cell()
      cell.backgroundColor = .bkBackground
      configuration.text = "문의 및 의견 보내기"
      cell.accessoryType = .disclosureIndicator
      cell.contentConfiguration = configuration
      return cell
    case 2:
      // 문의/의견 보내기
      let cell = UITableViewCell()
      var configuration = UIListContentConfiguration.cell()
      cell.backgroundColor = .bkBackground
      configuration.text = "개인정보 처리방침"
      cell.accessoryType = .disclosureIndicator
      cell.contentConfiguration = configuration
      return cell
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
      //mailto
    case 1:
      let subject = "독서Log: 문의 및 의견"
      let body = """
                    보다 나은 서비스와 사용 경험을 제공할 수 있도록 의견을 남겨주세요.
                    혹은 문제가 발생했다면 문제상황을 말씀해주시고, 가능한 경우 이미지 혹은 스크린샷 등의 자료를 남겨 제보해 주세요. 자세할수록 좋습니다.

                    1. 의견/문제
                    2. (문제라면) 어떤 상황에서 발생했는지
                    3. 이미지 혹은 스크린샷 등의 자료
                 """
      showEmailWithTemplate(subject: subject, body: body)
    case 2:
      if let url = URL(string: "https://jegyun.notion.site/dd7d6215eb8f4087addc01af3a1f5af2?pvs=4") {
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true)
      }
    default: break
    }
  }

}
