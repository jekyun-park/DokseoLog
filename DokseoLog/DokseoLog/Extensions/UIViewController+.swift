//
//  UIViewController+.swift
//  DokseoLog
//
//  Created by 박제균 on 2/6/24.
//

import UIKit

extension UIViewController {

  func presentDLAlert(title: String, message: String, buttonTitle: String) {
    let alertViewController = DLAlertViewController(title: title, message: message, buttonTitle: buttonTitle, style: .normal)
    alertViewController.modalPresentationStyle = .overFullScreen
    alertViewController.modalTransitionStyle = .crossDissolve
    present(alertViewController, animated: true)
  }

  func presentDLAlertWithConfirmAction(title: String, message: String, buttonTitle: String, action: (() -> Void)?) {
    let alertViewController = DLAlertViewController(
      title: title,
      message: message,
      buttonTitle: buttonTitle,
      style: .confirm,
      action: action)
    alertViewController.modalPresentationStyle = .overFullScreen
    alertViewController.modalTransitionStyle = .crossDissolve
    present(alertViewController, animated: true)
  }

  func presentDLAlertWithDestructiveAction(title: String, message: String, buttonTitle: String, action: (() -> Void)?) {
    let alertViewController = DLAlertViewController(
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
