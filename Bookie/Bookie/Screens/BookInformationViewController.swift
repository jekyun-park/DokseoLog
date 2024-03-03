//
//
//  BookInformationViewController.swift
//  Bookie
//
//  Created by 박제균 on 1/8/24.
//

import CoreData
import UIKit

class BookInformationViewController: UIViewController {

  // MARK: Lifecycle

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  init(book: Book, style: BarButtonStyle) {
    self.book = book
    self.style = style
    super.init(nibName: nil, bundle: nil)
  }

  // MARK: Internal

  enum BarButtonStyle {
    case add, move
  }

  let book: Book
  let style: BookInformationViewController.BarButtonStyle

  override func viewDidLoad() {
    super.viewDidLoad()
    setupScrollView()
    setupNavigationBar()
    setupUI()
  }

  // MARK: Private

  private lazy var scrollView = UIScrollView(frame: .zero)
  private let titleLabel = BKTitleLabel(textAlignment: .center, fontSize: 22, fontWeight: .bold)
  private let authorLabel = BKBodyLabel(textAlignment: .center, fontSize: 15, fontWeight: .regular)

  private let pagePlaceholderLabel = BKTitleLabel(textAlignment: .left, fontSize: 15, fontWeight: .medium)
  private let pageLabel = BKBodyLabel(textAlignment: .left, fontSize: 15, fontWeight: .regular)
  private let publishedDatePlaceholderLabel = BKTitleLabel(textAlignment: .left, fontSize: 15, fontWeight: .medium)
  private let publishedDateLabel = BKBodyLabel(textAlignment: .left, fontSize: 15, fontWeight: .regular)
  private let publisherPlaceholderLabel = BKTitleLabel(textAlignment: .left, fontSize: 15, fontWeight: .medium)
  private let publisherLabel = BKBodyLabel(textAlignment: .left, fontSize: 15, fontWeight: .regular)

  private let descriptionPlaceholderLabel = BKTitleLabel(textAlignment: .left, fontSize: 15, fontWeight: .medium)
  private let descriptionLabel = BKBodyLabel(textAlignment: .left, fontSize: 15, fontWeight: .regular)
  private let coverImage = BKCoverImageView(frame: .zero)

  private lazy var addToWishListBarButton = UIBarButtonItem(
    image: Images.basketBarButtonImage,
    style: .plain,
    target: self,
    action: #selector(addToWishListBarButtonTapped))

  private lazy var addBookBarButton = UIBarButtonItem(
    image: Images.plusButtonImage,
    style: .plain,
    target: self,
    action: #selector(addBookBarButtonTapped))

  private lazy var moveToBookCaseBarButton = UIBarButtonItem(
    image: Images.moveToBookCaseBarButtonImage,
    style: .plain,
    target: self,
    action: #selector(moveToBookCaseBarButtonImageTapped))

  private lazy var deleteButton: UIBarButtonItem = {
    let button = UIBarButtonItem(
      image: Images.trashImage,
      style: .plain,
      target: self,
      action: #selector(deleteButtonTapped))
    button.tintColor = .red
    return button
  }()

  private func setupUI() {
    titleLabel.text = book.title
    authorLabel.text = book.author
    descriptionLabel.text = (book.description.count == 0) ? "내용이 없습니다." : (book.description)
    descriptionLabel.adjustsFontSizeToFitWidth = false
    descriptionLabel.numberOfLines = 0
    descriptionPlaceholderLabel.text = "책소개"
    publisherPlaceholderLabel.text = "출판사"
    publisherLabel.text = book.publisher

    publishedDatePlaceholderLabel.text = "발행일"
    publishedDateLabel.text = book.publishedAt

    pagePlaceholderLabel.text = "쪽수"
    if let page = book.page, page != 0 {
      pageLabel.text = "\(page)p"
    } else {
      pageLabel.text = "페이지 정보가 없습니다."
    }

    coverImage.downloadImage(fromURL: book.coverURL)

    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: view.topAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      view.centerXAnchor.constraint(equalTo: coverImage.centerXAnchor),
      coverImage.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 50),
      coverImage.widthAnchor.constraint(equalToConstant: 150),
      coverImage.heightAnchor.constraint(equalToConstant: 225),

      titleLabel.topAnchor.constraint(equalTo: coverImage.bottomAnchor, constant: 40),
      titleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
      titleLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
      titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

      authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
      authorLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
      authorLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
      authorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

      publisherPlaceholderLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 20),
      publisherPlaceholderLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
      publisherPlaceholderLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),

      publisherLabel.topAnchor.constraint(equalTo: publisherPlaceholderLabel.bottomAnchor, constant: 10),
      publisherLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
      publisherLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),

      publishedDatePlaceholderLabel.topAnchor.constraint(equalTo: publisherLabel.bottomAnchor, constant: 20),
      publishedDatePlaceholderLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
      publishedDatePlaceholderLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),

      publishedDateLabel.topAnchor.constraint(equalTo: publishedDatePlaceholderLabel.bottomAnchor, constant: 10),
      publishedDateLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
      publishedDateLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),

      pagePlaceholderLabel.topAnchor.constraint(equalTo: publishedDateLabel.bottomAnchor, constant: 20),
      pagePlaceholderLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
      pagePlaceholderLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),

      pageLabel.topAnchor.constraint(equalTo: pagePlaceholderLabel.bottomAnchor, constant: 10),
      pageLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
      pageLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),

      descriptionPlaceholderLabel.topAnchor.constraint(equalTo: pageLabel.bottomAnchor, constant: 20),
      descriptionPlaceholderLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),

      descriptionLabel.topAnchor.constraint(equalTo: descriptionPlaceholderLabel.bottomAnchor, constant: 10),
      descriptionLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
      descriptionLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
      descriptionLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10),
    ])
  }

  private func setupScrollView() {
    view.addSubview(scrollView)
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.addSubviews(
      titleLabel,
      authorLabel,
      descriptionLabel,
      descriptionPlaceholderLabel,
      coverImage,
      pagePlaceholderLabel,
      pageLabel,
      publisherPlaceholderLabel,
      publisherLabel,
      publishedDatePlaceholderLabel,
      publishedDateLabel)
    scrollView.backgroundColor = .bkBackground
    scrollView.isScrollEnabled = true
  }

  private func setupNavigationBar() {
    switch style {
    case .add:
      navigationItem.setRightBarButtonItems([addToWishListBarButton, addBookBarButton], animated: true)
      addToWishListBarButton.tintColor = .bkTabBarTint
      addBookBarButton.tintColor = .bkTabBarTint
    case .move:
      navigationItem.setRightBarButtonItems([deleteButton, moveToBookCaseBarButton], animated: true)
      moveToBookCaseBarButton.tintColor = .bkTabBarTint
    }
    navigationController?.navigationBar.isHidden = false
    navigationController?.navigationBar.tintColor = .bkTabBarTint
  }

  @objc
  private func addToWishListBarButtonTapped() {
    do {
      try PersistenceManager.shared.addToWishList(book: book)
    } catch (let error) {
      let bkError = error as? BKError
      self.presentBKAlert(title: "도서를 추가할 수 없어요.", message: bkError?.description ?? "다시 시도하거나, 개발자에게 문의해주세요.", buttonTitle: "확인")
    }
  }

  @objc
  private func addBookBarButtonTapped() {
    do {
      try PersistenceManager.shared.addToBookCase(book: book)
    } catch (let error) {
      let bkError = error as? BKError
      self.presentBKAlert(title: "도서를 추가할 수 없어요.", message: bkError?.description ?? "다시 시도하거나, 개발자에게 문의해주세요.", buttonTitle: "확인")
    }
  }

  @objc
  private func moveToBookCaseBarButtonImageTapped() {
    let result = PersistenceManager.shared.moveToBookCase(book: book)
    switch result {
    case .success:
      navigationController?.popViewController(animated: true)
    case .failure(let error):
      presentBKAlert(title: "책장으로 이동할 수 없어요.", message: error.description, buttonTitle: "확인")
    }
  }

  @objc
  private func deleteButtonTapped() {
    let result = PersistenceManager.shared.deleteBook(book)
    switch result {
    case .success:
      navigationController?.popViewController(animated: true)
    case .failure(let error):
      presentBKAlert(title: "도서를 삭제할 수 없어요.", message: error.description, buttonTitle: "확인")
    }
  }

}
