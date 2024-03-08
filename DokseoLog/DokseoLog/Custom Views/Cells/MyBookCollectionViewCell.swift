//
//  BookCollectionViewCell.swift
//  DokseoLog
//
//  Created by 박제균 on 2/15/24.
//

import UIKit

class MyBookCollectionViewCell: UICollectionViewCell {

  // MARK: Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  static let reuseID = "MyBookCollectionViewCell"

  override func layoutSubviews() {
    super.layoutSubviews()

    contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12))
  }

  func setContents(book: MyBookEntity) {
    coverImage.downloadImage(fromURL: book.coverURL)
    titleLabel.text = book.title
    authorLabel.text = book.author
  }

  // MARK: Private

  private let coverImage = BKCoverImageView(frame: .zero)
  private let titleLabel = BKTitleLabel(textAlignment: .center, fontSize: 17, fontWeight: .bold)
  private let authorLabel = BKBodyLabel(textAlignment: .center, fontSize: 13, fontWeight: .medium)

  private func setupUI() {
    let padding: CGFloat = 8
    contentView.addSubviews(coverImage, titleLabel, authorLabel)

    NSLayoutConstraint.activate([
      coverImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
      coverImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      coverImage.widthAnchor.constraint(equalToConstant: 100),
      coverImage.heightAnchor.constraint(equalTo: coverImage.widthAnchor, multiplier: 1.5),

      titleLabel.topAnchor.constraint(equalTo: coverImage.bottomAnchor, constant: padding),
      titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      titleLabel.heightAnchor.constraint(equalToConstant: 20),

      authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding),
      authorLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      authorLabel.heightAnchor.constraint(equalToConstant: 18),
    ])
  }

}
