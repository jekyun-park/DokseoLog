//
//  UnderlineSegmentedControl.swift
//  Bookie
//
//  Created by 박제균 on 2/15/24.
//

import UIKit

final class UnderlineSegmentedControl: UISegmentedControl {

  private lazy var underlineView: UIView = {
    let width = self.bounds.width / CGFloat(self.numberOfSegments)
    let height = 2.0
    let x = CGFloat(self.selectedSegmentIndex * Int(width))
    let y = self.bounds.height - 1.0
    let frame = CGRect(x: x, y: y, width: width, height: height)
    let view = UIView(frame: frame)
    view.backgroundColor = .label
    self.addSubviews(view)
    return view
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  override init(items: [Any]?) {
    super.init(items: items)
    setup()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    let underlineX = (self.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(self.selectedSegmentIndex)

    UIView.animate(withDuration: 0.1) {
      self.underlineView.frame.origin.x = underlineX
    }
  }

  private func setup() {
    let image = UIImage()
    self.setBackgroundImage(image, for: .normal, barMetrics: .default)
    self.setBackgroundImage(image, for: .selected, barMetrics: .default)
    self.setBackgroundImage(image, for: .highlighted, barMetrics: .default)
    self.setDividerImage(image, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
  }

}
