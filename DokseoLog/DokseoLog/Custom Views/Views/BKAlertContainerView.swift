//
//  BKAlertContainerView.swift
//  DokseoLog
//
//  Created by 박제균 on 2/6/24.
//

import UIKit

class BKAlertContainerView: UIView {

  // MARK: Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Private

  private func setup() {
    backgroundColor = .bkBackgroundColor
    layer.cornerRadius = 16
    layer.borderWidth = 2
    layer.borderColor = UIColor.white.cgColor
    translatesAutoresizingMaskIntoConstraints = false
  }

}
