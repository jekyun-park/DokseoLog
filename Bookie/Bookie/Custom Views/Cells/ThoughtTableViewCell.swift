//
//  ThoughtTableViewCell.swift
//  Bookie
//
//  Created by 박제균 on 2/21/24.
//

import UIKit

class ThoughtTableViewCell: UITableViewCell {

  static let reuseID = "ThoughtTableViewCell"

  private lazy var thoughtLabel: BKBodyLabel = {
    let label = BKBodyLabel(textAlignment: .left, fontSize: 15, fontWeight: .regular)
    label.lineBreakMode = .byCharWrapping
    return label
  }()

  private lazy var dateLabel: BKTitleLabel = {
    let label = BKTitleLabel(textAlignment: .left, fontSize: 15, fontWeight: .medium)
    return label
  }()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupUI() {
    let padding: CGFloat = 20

    self.selectionStyle = .none
    self.backgroundColor = .bkBackgroundColor
    self.contentView.addSubviews(thoughtLabel, dateLabel)

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

  func setContent(thought: Thought) {
    self.thoughtLabel.text = thought.memo
    self.dateLabel.text = thought.createdAt.formatted()
  }

}
