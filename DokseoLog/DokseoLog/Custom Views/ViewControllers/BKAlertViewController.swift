//
//  BKAlertViewController.swift
//  DokseoLog
//
//  Created by 박제균 on 2/6/24.
//

import UIKit

class BKAlertViewController: UIViewController {

  // MARK: Lifecycle

  init(title: String, message: String, buttonTitle: String, style: BKAlertViewController.Style) {
    super.init(nibName: nil, bundle: nil)
    alertTitle = title
    self.message = message
    self.buttonTitle = buttonTitle
    self.style = style
  }

  convenience init(
    title: String,
    message: String,
    buttonTitle: String,
    style: BKAlertViewController.Style,
    action: (() -> Void)?)
  {
    self.init(title: title, message: message, buttonTitle: buttonTitle, style: style)
    self.action = action
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  enum Style {
    case confirm, destructive, normal
  }

  var alertTitle: String?
  var message: String?
  var buttonTitle: String?
  var action: (() -> Void)?
  var style: BKAlertViewController.Style = .normal

  override func viewDidLoad() {
    super.viewDidLoad()
    switch style {
    case .confirm:
      setupConfirmUI()
    case .destructive:
      setupDestructiveUI()
    case .normal:
      setupUI()
    }
  }

  // MARK: Private

  private let containerView = BKAlertContainerView()
  private let titleLabel: BKTitleLabel = {
    let label = BKTitleLabel(textAlignment: .center, fontSize: 17, fontWeight: .medium)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let messageLabel: BKBodyLabel = {
    let label = BKBodyLabel(textAlignment: .center, fontSize: 13, fontWeight: .regular)
    label.numberOfLines = 4
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private lazy var actionButton: BKButton = {
    let button = BKButton(backgroundColor: .black, foregroundColor: .white, title: "OK")
    button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  private lazy var normalButton: BKButton = {
    let button = BKButton(backgroundColor: .black, foregroundColor: .white, title: "OK")
    button.addTarget(self, action: #selector(normalButtonTapped), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  private func setupUI() {
    titleLabel.text = alertTitle ?? "알 수 없는 에러가 발생했어요."
    messageLabel.text = message ?? "설정 > 문의에서 개발자에게 문의해 주세요."
    actionButton.setTitle(buttonTitle ?? "확인", for: .normal)

    view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
    view.addSubviews(containerView, titleLabel, messageLabel, actionButton)
    let padding: CGFloat = 20

    NSLayoutConstraint.activate([
      containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      containerView.widthAnchor.constraint(equalToConstant: 280),
      containerView.heightAnchor.constraint(equalToConstant: 220),

      titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
      titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
      titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
      titleLabel.heightAnchor.constraint(equalToConstant: 28),

      messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
      messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
      messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
      messageLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -12),

      actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
      actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
      actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
      actionButton.heightAnchor.constraint(equalToConstant: 44),
    ])
  }

  private func setupConfirmUI() {
    titleLabel.text = alertTitle ?? "알 수 없는 에러가 발생했어요."
    messageLabel.text = message ?? "설정 > 문의에서 개발자에게 문의해 주세요."
    actionButton.setTitle(buttonTitle ?? "확인", for: .normal)
    normalButton.setTitle("취소", for: .normal)

    view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
    view.addSubviews(containerView, titleLabel, messageLabel, actionButton, normalButton)
    let padding: CGFloat = 20

    NSLayoutConstraint.activate([
      containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      containerView.widthAnchor.constraint(equalToConstant: 280),
      containerView.heightAnchor.constraint(equalToConstant: 220),

      titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
      titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
      titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
      titleLabel.heightAnchor.constraint(equalToConstant: 28),

      messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
      messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
      messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
      messageLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -12),

      actionButton.bottomAnchor.constraint(equalTo: normalButton.topAnchor, constant: -padding),
      actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
      actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
      actionButton.heightAnchor.constraint(equalToConstant: 44),

      normalButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
      normalButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
      normalButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
      normalButton.heightAnchor.constraint(equalToConstant: 44),
    ])
  }

  private func setupDestructiveUI() {
    titleLabel.text = alertTitle ?? "알 수 없는 에러가 발생했어요."
    messageLabel.text = message ?? "설정 > 문의에서 개발자에게 문의해 주세요."
    actionButton.setTitle(buttonTitle ?? "확인", for: .normal)
    actionButton.configuration?.background.backgroundColor = .red
    actionButton.configuration?.baseForegroundColor = .white
    normalButton.setTitle("취소", for: .normal)

    view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
    view.addSubviews(containerView, titleLabel, messageLabel, actionButton, normalButton)
    let padding: CGFloat = 20

    NSLayoutConstraint.activate([
      containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      containerView.widthAnchor.constraint(equalToConstant: 280),
      containerView.heightAnchor.constraint(equalToConstant: 280),

      titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
      titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
      titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
      titleLabel.heightAnchor.constraint(equalToConstant: 28),

      messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
      messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
      messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
      messageLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -12),

      actionButton.bottomAnchor.constraint(equalTo: normalButton.topAnchor, constant: -padding),
      actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
      actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
      actionButton.heightAnchor.constraint(equalToConstant: 44),

      normalButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
      normalButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
      normalButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
      normalButton.heightAnchor.constraint(equalToConstant: 44),
    ])
  }

  @objc
  private func actionButtonTapped() {
    if let action {
      action()
    }
    dismiss(animated: true)
  }

  @objc
  private func normalButtonTapped() {
    dismiss(animated: true)
  }

}
