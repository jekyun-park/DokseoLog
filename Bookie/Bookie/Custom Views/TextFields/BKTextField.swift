//
//  BKTextField.swift
//  Bookie
//
//  Created by 박제균 on 11/9/23.
//

import UIKit

class BKTextField: UITextField {

  // MARK: Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Private

  private func configureUI() {
    translatesAutoresizingMaskIntoConstraints = false

    layer.cornerRadius = 10
    layer.borderWidth = 2
    layer.borderColor = UIColor.systemGray4.cgColor

    textColor = .bkText
    tintColor = .bkTabBarTint
    textAlignment = .center
    font = UIFont(name: Fonts.HanSansNeo.regular.rawValue, size: UIFont.preferredFont(forTextStyle: .title2).pointSize)
    adjustsFontSizeToFitWidth = true
    minimumFontSize = 12

    backgroundColor = .tertiarySystemBackground
    autocorrectionType = .no
    autocapitalizationType = .none
    returnKeyType = .go
    clearButtonMode = .whileEditing
    placeholder = "책 이름을 입력하세요"
  }

}
