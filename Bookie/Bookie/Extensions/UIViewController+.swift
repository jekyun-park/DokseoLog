//
//  UIViewController+.swift
//  Bookie
//
//  Created by 박제균 on 2/6/24.
//

import UIKit

extension UIViewController {

  func presentBKAlert(title: String, message: String, buttonTitle: String, action: @escaping () -> Void) {
    let alertViewController = BKAlertViewController(title: title, message: message, buttonTitle: buttonTitle, action: action)
    alertViewController.modalPresentationStyle = .overFullScreen
    alertViewController.modalTransitionStyle = .crossDissolve
    self.present(alertViewController, animated: true)
  }

}
