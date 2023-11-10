//
//  UIView+.swift
//  Bookie
//
//  Created by 박제균 on 11/10/23.
//

import UIKit

extension UIView {
  func addSubViews(_ views: UIView...) {
    for view in views { view.addSubview(view) }
  }
}
