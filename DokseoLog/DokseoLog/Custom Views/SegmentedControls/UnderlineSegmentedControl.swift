//
//  UnderlineSegmentedControl.swift
//  DokseoLog
//
//  Created by 박제균 on 2/15/24.
//

import UIKit

final class UnderlineSegmentedControl: UISegmentedControl {

  // MARK: Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  override init(items: [Any]?) {
    super.init(items: items)
    setup()
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  override func layoutSubviews() {
    super.layoutSubviews()

    let underlineX = (bounds.width / CGFloat(numberOfSegments)) * CGFloat(selectedSegmentIndex)

    UIView.animate(withDuration: 0.1) {
      self.underlineView.frame.origin.x = underlineX
    }
  }

  // MARK: Private

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

  private func setup() {
    let image = UIImage()
    setBackgroundImage(image, for: .normal, barMetrics: .default)
    setBackgroundImage(image, for: .selected, barMetrics: .default)
    setBackgroundImage(image, for: .highlighted, barMetrics: .default)
    setDividerImage(image, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
  }

}
