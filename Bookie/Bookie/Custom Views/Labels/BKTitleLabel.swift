//
//  BKTitleLabel.swift
//  Bookie
//
//  Created by 박제균 on 11/9/23.
//

import UIKit

class BKTitleLabel: UILabel {

  // MARK: Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  convenience init(textAlignment: NSTextAlignment, fontSize: CGFloat) {
    self.init(frame: .zero)
    self.textAlignment = textAlignment
    guard let customFont = UIFont(name: Fonts.HanSansNeo.medium, size: fontSize) else { return }
    font = UIFontMetrics(forTextStyle: .title1).scaledFont(for: customFont)
    adjustsFontForContentSizeCategory = true
  }

  // MARK: Private

  private func configureUI() {
    textColor = .label
    adjustsFontSizeToFitWidth = true
    minimumScaleFactor = 0.9
    lineBreakMode = .byTruncatingTail
    translatesAutoresizingMaskIntoConstraints = false
  }

}
