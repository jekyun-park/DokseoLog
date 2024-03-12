//
//  DLBodyLabel.swift
//  DokseoLog
//
//  Created by 박제균 on 11/9/23.
//

import UIKit

class DLBodyLabel: UILabel {

  // MARK: Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  convenience init(textAlignment: NSTextAlignment, fontSize: CGFloat, fontWeight: Fonts.HanSansNeo) {
    self.init(frame: .zero)
    self.textAlignment = textAlignment
    font = UIFont(name: fontWeight.description, size: fontSize)
  }

  // MARK: Private

  private func configureUI() {
    textColor = .secondaryLabel
    adjustsFontForContentSizeCategory = true
    adjustsFontSizeToFitWidth = false
    minimumScaleFactor = 0.75
    lineBreakMode = .byTruncatingTail
    numberOfLines = 0
    translatesAutoresizingMaskIntoConstraints = false
  }

}
