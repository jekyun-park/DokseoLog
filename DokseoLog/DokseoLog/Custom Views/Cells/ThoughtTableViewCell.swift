//
//  ThoughtTableViewCell.swift
//  Bookie
//
//  Created by 박제균 on 2/21/24.
//

import UIKit

class ThoughtTableViewCell: UITableViewCell {

  // MARK: Lifecycle

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  static let reuseID = "ThoughtTableViewCell"

  func setContents(thought: Thought) {
    thoughtLabel.text = thought.memo
    dateLabel.text = thought.createdAt.formatted()
  }

  // MARK: Private

  private lazy var thoughtLabel: BKBodyLabel = {
    let label = BKBodyLabel(textAlignment: .left, fontSize: 15, fontWeight: .regular)
    label.lineBreakMode = .byCharWrapping
    return label
  }()

  private lazy var dateLabel: BKTitleLabel = {
    let label = BKTitleLabel(textAlignment: .left, fontSize: 15, fontWeight: .medium)
    return label
  }()

  private func setupUI() {
    let padding: CGFloat = 20

    selectionStyle = .none
    backgroundColor = .bkBackgroundColor
    contentView.addSubviews(thoughtLabel, dateLabel)

    NSLayoutConstraint.activate([
      dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
      dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
      dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
      dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),

      thoughtLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: padding),
      thoughtLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
      thoughtLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
      thoughtLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
    ])
  }

}
