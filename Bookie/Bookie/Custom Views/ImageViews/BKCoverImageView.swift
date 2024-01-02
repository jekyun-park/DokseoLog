//
//  BKCoverImageView.swift
//  Bookie
//
//  Created by 박제균 on 11/9/23.
//

import UIKit

class BKCoverImageView: UIImageView {

  // MARK: Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  let placeholderImage = Images.placeholderBookImage

  func downloadImage(fromURL urlString: String) {
    NetworkManager.shared.downloadImage(from: urlString, completion: { [weak self] image in
      guard let self else { return }
      DispatchQueue.main.async { self.image = image }
    })
  }

  // MARK: Private

  private func configureUI() {
    translatesAutoresizingMaskIntoConstraints = false
    layer.cornerRadius = 10
    clipsToBounds = true
    image = placeholderImage
    contentMode = .scaleAspectFit
    translatesAutoresizingMaskIntoConstraints = false
  }

}
