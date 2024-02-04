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
    configureUI()
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

//  convenience init(color : UIColor, title : String, systemImageName : String) {
//    self.init(frame: .zero)
//    set(color: color, title: title, systemImageName: systemImageName )
//  }

  convenience init(color: UIColor, title: String) {
    self.init(frame: .zero)
    set(color: color, title: title)
  }

  // MARK: Internal

  private func set(color: UIColor, title: String) {
    configuration?.baseBackgroundColor = color
    configuration?.baseForegroundColor = color
    configuration?.title = title
  }

  // MARK: Private

  private func configureUI() {
    translatesAutoresizingMaskIntoConstraints = false
    configuration = .tinted()
    configuration?.cornerStyle = .medium
  }

}
