//
//  BKCoverImageView.swift
//  DokseoLog
//
//  Created by 박제균 on 11/9/23.
//

import UIKit

class BKCoverImageView: UIImageView {

  // MARK: Lifecycle
  private let indicatorView: UIActivityIndicatorView = {
    let indicatorView = UIActivityIndicatorView(style: .large)
    indicatorView.hidesWhenStopped = true
    return indicatorView
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  func downloadImage(fromURL urlString: String?) {

    indicatorView.startAnimating()
    guard let url = urlString else {
      return
    }

    NetworkManager.shared.downloadImage(from: url, completion: { [weak self] image in
      guard let self else { return }
      DispatchQueue.main.async {
        self.image = image
        self.indicatorView.stopAnimating()
      }
    })
  }

  // MARK: Private

  private func configureUI() {
    self.addSubview(indicatorView)
    translatesAutoresizingMaskIntoConstraints = false
    indicatorView.center = self.center
    layer.cornerRadius = 10
    clipsToBounds = true
    contentMode = .scaleToFill
  }

}
