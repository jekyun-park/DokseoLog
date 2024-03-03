//
//  UIViewController+.swift
//  Bookie
//
//  Created by 박제균 on 2/6/24.
//

import UIKit

extension UIViewController {

  func presentBKAlert(title: String, message: String, buttonTitle: String) {
    let alertViewController = BKAlertViewController(title: title, message: message, buttonTitle: buttonTitle, style: .normal)
    alertViewController.modalPresentationStyle = .overFullScreen
    alertViewController.modalTransitionStyle = .crossDissolve
    present(alertViewController, animated: true)
  }

  func presentBKAlertWithConfirmAction(title: String, message: String, buttonTitle: String, action: (() -> Void)?) {
    let alertViewController = BKAlertViewController(
      title: title,
      message: message,
      buttonTitle: buttonTitle,
      style: .confirm,
      action: action)
    alertViewController.modalPresentationStyle = .overFullScreen
    alertViewController.modalTransitionStyle = .crossDissolve
    present(alertViewController, animated: true)
  }

  func presentBKAlertWithDestructiveAction(title: String, message: String, buttonTitle: String, action: (() -> Void)?) {
    let alertViewController = BKAlertViewController(
      title: title,
      message: message,
      buttonTitle: buttonTitle,
      style: .destructive,
      action: action)
    alertViewController.modalPresentationStyle = .overFullScreen
    alertViewController.modalTransitionStyle = .crossDissolve
    present(alertViewController, animated: true)
  }

  /// viewController의 터치가 일어나면 키보드를 내려줍니다.
  func hideKeyboardWhenTappedAround() {
    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
    gestureRecognizer.cancelsTouchesInView = false
    view.addGestureRecognizer(gestureRecognizer)
  }

  @objc
  func dismissKeyboard() {
    view.endEditing(true)
  }

}
