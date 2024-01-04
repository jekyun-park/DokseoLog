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
    contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12))
  }

  func setContents(book: Item) {
    coverImageView.downloadImage(fromURL: book.coverURL)
    titleLabel.text = book.title
    authorLabel.text = book.author
  }

  // MARK: Private

  private func configureUI() {
    let padding: CGFloat = 8
    selectionStyle = .none
    backgroundColor = UIColor(resource: .bkBackground)

    let containerView = UIView()
    containerView.translatesAutoresizingMaskIntoConstraints = false
    containerView.addSubviews(coverImageView, titleLabel, authorLabel)
    contentView.addSubview(containerView)

    NSLayoutConstraint.activate([
      containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
      containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

      coverImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
      coverImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      coverImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
      coverImageView.widthAnchor.constraint(equalToConstant: 85),

      titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
      titleLabel.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: padding),
      titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
      titleLabel.bottomAnchor.constraint(equalTo: authorLabel.topAnchor, constant: -padding),
      titleLabel.heightAnchor.constraint(equalToConstant: 20),

      authorLabel.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: padding),
      authorLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
      authorLabel.heightAnchor.constraint(equalToConstant: 18)
    ])
  }

}
