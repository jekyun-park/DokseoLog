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
    configureUI()
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  static let reuseID = "SearchResultCell"

  let coverImageView = BKCoverImageView(frame: .zero)
  let titleLabel = BKTitleLabel(textAlignment: .left, fontSize: 17)
  let authorLabel = BKBodyLabel(textAlignment: .left, fontSize: 15)

  override func layoutSubviews() {
    super.layoutSubviews()
    contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0))
  }

  func setContents(book: Item) {
    coverImageView.downloadImage(fromURL: book.coverURL)
    titleLabel.text = book.title
    authorLabel.text = book.author
  }

  // MARK: Private

  private func configureUI() {
    selectionStyle = .none
    backgroundColor = UIColor(resource: .bkBackground)

    contentView.addSubview(coverImageView)
    contentView.addSubview(titleLabel)
    contentView.addSubview(authorLabel)

    let padding: CGFloat = 8

    NSLayoutConstraint.activate([
      coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
      coverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
      coverImageView.widthAnchor.constraint(equalToConstant: 100),
      coverImageView.heightAnchor.constraint(equalToConstant: 100),
      coverImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

      titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
      titleLabel.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: padding),
      titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      titleLabel.bottomAnchor.constraint(equalTo: authorLabel.topAnchor, constant: padding),

      authorLabel.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: padding),
      authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      authorLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: padding),
    ])
  }

}
