//
//  LoginViewController.swift
//  Bookie
//
//  Created by 박제균 on 2/2/24.
//

import AuthenticationServices
import UIKit

class InitialViewController: UIViewController {

  private lazy var appleLoginButton: ASAuthorizationAppleIDButton = {
    let button = ASAuthorizationAppleIDButton(authorizationButtonType: .default, authorizationButtonStyle: .black)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(appleLoginButtonTapped), for: .touchUpInside)
    return button
  }()

  private lazy var continueWithoutLoginButton: BKButton = {
    let button = BKButton(color: .label, title: "로그인 없이 시작하기")
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(continueWithoutLoginButtonTapped), for: .touchUpInside)
    return button
  }()

  private lazy var stackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [
      appleLoginButton,
      continueWithoutLoginButton
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

  @objc private func appleLoginButtonTapped() {
    let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
  }

  @objc private func continueWithoutLoginButtonTapped() {
    self.dismiss(animated: true)
    view.window?.rootViewController = BKTabBarController()
  }

}

extension InitialViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding{

  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    guard let window = self.view.window else { return ASPresentationAnchor() }
    return window
  }

  /// 인증 성공시 성공되는 함수
  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    switch authorization.credential {
    case let appleIDCredential as ASAuthorizationAppleIDCredential:
      let userCredential = appleIDCredential.user
      let email = appleIDCredential.email
      let fullName = appleIDCredential.fullName

    default:
      break
    }
  }

  /// 인증 실패시 실행되는 함수
  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    
  }
}
