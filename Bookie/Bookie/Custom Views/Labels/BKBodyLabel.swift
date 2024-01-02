//
//  BKBodyLabel.swift
//  Bookie
//
//  Created by 박제균 on 11/9/23.
//

import UIKit

class BKBodyLabel: UILabel {

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
    guard let customFont = UIFont(name: Fonts.HanSansNeo.regular, size: fontSize) else { return }
    font = UIFontMetrics(forTextStyle: .body).scaledFont(for: customFont)
    adjustsFontForContentSizeCategory = true
  }

  // MARK: Private

  private func configureUI() {
    textColor = .secondaryLabel
    adjustsFontForContentSizeCategory = true
    adjustsFontSizeToFitWidth = true
    minimumScaleFactor = 0.75
    lineBreakMode = .byWordWrapping
    translatesAutoresizingMaskIntoConstraints = false
  }

}
