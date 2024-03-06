//
//  SentenceTableViewCell.swift
//  Bookie
//
//  Created by 박제균 on 2/21/24.
//

import UIKit

class SentenceTableViewCell: UITableViewCell {

  // MARK: Lifecycle

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  static let reuseID = "SentenceTableViewCell"

  func setContents(sentence: Sentence) {
    pageLabel.text = "p.\(Int(sentence.page))"
    sentenceLabel.text = sentence.memo
    dateLabel.text = sentence.createdAt.formatted()
  }

  // MARK: Private

  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.addArrangedSubview(pageLabel)
    stackView.addArrangedSubview(dateLabel)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    return stackView
  }()

  private lazy var pageLabel: BKTitleLabel = {
    let label = BKTitleLabel(textAlignment: .left, fontSize: 15, fontWeight: .medium)
    return label
  }()

  private lazy var sentenceLabel: BKBodyLabel = {
    let label = BKBodyLabel(textAlignment: .left, fontSize: 15, fontWeight: .medium)
    label.lineBreakMode = .byCharWrapping
    return label
  }()

  private let dateLabel: BKBodyLabel = {
    let label = BKBodyLabel(textAlignment: .right, fontSize: 13, fontWeight: .regular)
    return label
  }()

  private func setupUI() {
    let padding: CGFloat = 20

    selectionStyle = .none
    backgroundColor = .bkBackgroundColor
    contentView.addSubviews(stackView, sentenceLabel)

    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
      stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
      stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),

      sentenceLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: padding),
      sentenceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
      sentenceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
      sentenceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
    ])
  }

}
