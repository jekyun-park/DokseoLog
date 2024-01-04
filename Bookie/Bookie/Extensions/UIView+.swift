//
//  UIView+.swift
//  Bookie
//
//  Created by 박제균 on 11/10/23.
//

import UIKit

extension UIView {
  func addSubviews(_ views: UIView...) {
    for view in views { self.addSubview(view) }
  }
}
