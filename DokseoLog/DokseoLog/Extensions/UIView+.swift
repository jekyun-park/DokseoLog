//
//  UIView+.swift
//  DokseoLog
//
//  Created by 박제균 on 11/10/23.
//

import UIKit

extension UIView {

  func addSubviews(_ views: UIView...) {
    for view in views { addSubview(view) }
  }

  func showToast(message: String, duration: TimeInterval = 3.0) {
    let toastLabel = UILabel(frame: CGRect.zero)
    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    toastLabel.textColor = UIColor.white
    toastLabel.textAlignment = .center;
    toastLabel.font = UIFont(name: Fonts.HanSansNeo.medium.description, size: 15)
    toastLabel.text = message
    toastLabel.alpha = 0.0
    toastLabel.layer.cornerRadius = 4;
    toastLabel.layer.borderColor = UIColor.black.cgColor
    toastLabel.clipsToBounds = true

    self.addSubview(toastLabel)
    toastLabel.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      toastLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      toastLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -100),
      toastLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: 20),
      toastLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -20)
    ])

    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
      toastLabel.alpha = 1.0
    }, completion: { _ in
      UIView.animate(withDuration: 0.5, delay: duration, options: .curveEaseInOut, animations: {
        toastLabel.alpha = 0.0
      }, completion: {_ in
        toastLabel.removeFromSuperview()
      })
    })
  }

}
