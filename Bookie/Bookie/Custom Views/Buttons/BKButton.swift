//
//  BKButton.swift
//  Bookie
//
//  Created by 박제균 on 11/10/23.
//

import UIKit

class BKButton: UIButton {

  // MARK: Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  convenience init(color _: UIColor, title _: String, systemImageName _: String) {
    self.init(frame: .zero)
  }

  // MARK: Internal

  func set(color: UIColor, title: String, systemImageName: String) {
    configuration?.baseBackgroundColor = color
    configuration?.baseForegroundColor = color
    configuration?.title = title

    configuration?.image = UIImage(systemName: systemImageName)
    configuration?.imagePadding = 6
    configuration?.imagePlacement = .leading
  }

  // MARK: Private

  private func configure() {
    translatesAutoresizingMaskIntoConstraints = false
    configuration = .tinted()
    configuration?.cornerStyle = .medium
  }

}
