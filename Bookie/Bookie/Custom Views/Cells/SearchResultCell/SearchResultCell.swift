//
//  SearchResultCell.swift
//  Bookie
//
//  Created by 박제균 on 11/9/23.
//

import UIKit

class SearchResultCell: UITableViewCell {

  // MARK: Lifecycle

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configure()
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  static let reuseID = "SearchResultCell"

  let coverImageView = BKCoverImageView(frame: .zero)
  let titleLabel = BKTitleLabel(textAlignment: .left, fontSize: 24)
  let authorLabel = BKBodyLabel(textAlignment: .left, fontSize: 20)

  func set(book: Book) {
    coverImageView.downloadImage(fromURL: book.coverURL)
    titleLabel.text = book.title
    authorLabel.text = book.author
  }

  // MARK: Private

  private func configure() {
    addSubview(coverImageView)
    addSubview(titleLabel)
    addSubview(authorLabel)

    let padding: CGFloat = 8

    NSLayoutConstraint.activate([
      coverImageView.topAnchor.constraint(equalTo: topAnchor),
      coverImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
      coverImageView.bottomAnchor.constraint(equalTo: bottomAnchor),

      titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
      titleLabel.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: padding),
      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
      titleLabel.bottomAnchor.constraint(equalTo: authorLabel.topAnchor, constant: padding),

      authorLabel.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: padding),
      authorLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
      authorLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: padding),
    ])
  }

}
