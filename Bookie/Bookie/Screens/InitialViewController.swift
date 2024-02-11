//
//  LoginViewController.swift
//  Bookie
//
//  Created by 박제균 on 2/2/24.
//

import UIKit

class InitialViewController: UIViewController {

  private lazy var linkWithiCloudButton: BKButton = {
    guard let image = Images.icloudLinkImage else { return BKButton() }
    let button = BKButton(backgroundColor: .black, foregroundColor: .white, title: "icloud와 데이터 연동하기", systemImage: image)
    button.titleLabel?.font = UIFont(name: Fonts.HanSansNeo.bold.rawValue, size: 17)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(linkWithiCloudButtonTapped), for: .touchUpInside)
    return button
  }()

  private lazy var continueWithoutiCloudButton: BKButton = {
    let button = BKButton(backgroundColor: .systemGray3, foregroundColor: .label, title: "연동 없이 시작하기")
    button.titleLabel?.font = UIFont(name: Fonts.HanSansNeo.bold.rawValue, size: 17)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(continueWithoutLoginButtonTapped), for: .touchUpInside)
    return button
  }()

  private lazy var stackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [
      linkWithiCloudButton,
      continueWithoutiCloudButton
    ])
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.spacing = 15
    stackView.distribution = .fillEqually
    return stackView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

  private func setupUI() {
    view.addSubview(stackView)
    view.backgroundColor = .bkBackground

    NSLayoutConstraint.activate([
      stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
      stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
      stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
      stackView.heightAnchor.constraint(equalToConstant: 120)
    ])
  }

  @objc private func linkWithiCloudButtonTapped() {
    // iCloud 연동이 되어있지 않은 경우
    if FileManager.default.ubiquityIdentityToken == nil {
      self.presentBKAlertWithAction(title: "iCloud 연동을 해주세요", message: "설정 > iPhone에 로그인을 통해 iCloud와 연동할 수 있도록 해주세요", buttonTitle: "확인") {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(settingsURL)
      }
    } else { // iCloud 연동이 되어있는 경우
      self.presentBKAlertWithAction(title: "iCloud 연동 성공", message: "iCloud 연동에 성공했습니다!", buttonTitle: "확인") {
        self.view.window?.rootViewController = BKTabBarController()
      }

      UserDefaultsManager.shared.setLaunchedBefore()
    }
  }

  @objc private func continueWithoutLoginButtonTapped() {
    self.dismiss(animated: true)
    view.window?.rootViewController = BKTabBarController()
    UserDefaultsManager.shared.setLaunchedBefore()
  }

}
