//
//  BKAlertContainerView.swift
//  Bookie
//
//  Created by 박제균 on 2/6/24.
//

import UIKit

class BKAlertContainerView: UIView {

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setup() {
    backgroundColor = .bkBackgroundColor
    layer.cornerRadius = 16
    layer.borderWidth = 2
    layer.borderColor = UIColor.white.cgColor
    translatesAutoresizingMaskIntoConstraints = false
  }

}
