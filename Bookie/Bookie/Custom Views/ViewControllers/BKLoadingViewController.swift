//
//  BKLoadingViewController.swift
//  Bookie
//
//  Created by 박제균 on 1/26/24.
//

import UIKit

class BKLoadingViewController: UIViewController {

  var containerView: UIView!

  func showLoadingView() {
    containerView = UIView(frame: view.bounds)
    view.addSubview(containerView)

    containerView.backgroundColor = .systemBackground
    containerView.alpha = 0

    UIView.animate(withDuration: 0.25) { self.containerView.alpha = 0.8 }

    let activityIndicator = UIActivityIndicatorView(style: .large)
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    containerView.addSubview(activityIndicator)

    NSLayoutConstraint.activate([
      activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
      activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
    ])

    activityIndicator.startAnimating()
  }

  func dismissLoadingView() {
    DispatchQueue.main.async {
      self.containerView.removeFromSuperview()
      self.containerView = nil
    }
  }

}
