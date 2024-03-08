//
//  DLButton.swift
//  DokseoLog
//
//  Created by 박제균 on 11/10/23.
//

import UIKit

class DLButton: UIButton {

  // MARK: Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  convenience init(backgroundColor: UIColor, foregroundColor: UIColor, title: String, systemImage: UIImage) {
    self.init(frame: .zero)

//    self.backgroundColor = color
    configuration?.background.backgroundColor = backgroundColor
//    configuration?.baseBackgroundColor =
    configuration?.baseForegroundColor = foregroundColor
    configuration?.title = title

    configuration?.image = systemImage
    configuration?.imagePadding = 6
    configuration?.imagePlacement = .leading
  }

  convenience init(backgroundColor: UIColor, foregroundColor: UIColor, title: String) {
    self.init(frame: .zero)

    configuration?.background.backgroundColor = backgroundColor
    configuration?.baseForegroundColor = foregroundColor
    configuration?.title = title
  }

  // MARK: Private

  private func setup() {
    translatesAutoresizingMaskIntoConstraints = false
    configuration = .tinted()
    configuration?.cornerStyle = .medium
  }

}
