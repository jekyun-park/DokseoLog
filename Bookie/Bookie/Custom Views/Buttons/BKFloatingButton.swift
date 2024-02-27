//
//  BKFloatingButton.swift
//  Bookie
//
//  Created by 박제균 on 2/27/24.
//

import UIKit

class BKFloatingButton: UIButton {

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setup() {
    layer.cornerRadius = 30
    layer.shadowRadius = 10
    layer.shadowOpacity = 0.2
    backgroundColor = .white
    let image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium))
    setImage(image, for: .normal)
    tintColor = .black
    setTitleColor(.label, for: .normal)
  }

}
