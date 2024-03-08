//
//  AddRecordViewController.swift
//  DokseoLog
//
//  Created by 박제균 on 2/21/24.
//

import CoreData
import Toast
import UIKit

// MARK: - AddRecordViewController

class AddRecordViewController: UIViewController {

  // MARK: Lifecycle

  init(book: Book, style: AddRecordViewController.recordStyle) {
    self.book = book
    self.style = style
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  let book: Book
  let style: AddRecordViewController.recordStyle

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .bkBackground
    setupNavigationController()
    self.style == .sentence ? setupSentenceUI() : setupThoughtUI()
    hideKeyboardWhenTappedAround()
  }

  // MARK: Private

  private lazy var pageTextField: BKTextField = {
    let textField = BKTextField(frame: .zero)
    return textField
  }()

  private lazy var pagePlaceholderLabel: BKTitleLabel = {
    let label = BKTitleLabel(textAlignment: .left, fontSize: 17, fontWeight: .medium)
    label.text = "페이지"
    return label
  }()

  private lazy var textView: UITextView = {
    let textView = UITextView()
    textView.translatesAutoresizingMaskIntoConstraints = false
    textView.backgroundColor = .tertiarySystemBackground
    textView.text = self.style.placeHolderString
    textView.autocorrectionType = .no
    textView.spellCheckingType = .no
    textView.font = UIFont(name: Fonts.HanSansNeo.medium.description, size: 15)
    textView.textColor = .label
    textView.delegate = self
    textView.layer.cornerRadius = 5
    textView.layer.borderColor = UIColor.systemGray4.cgColor
    textView.layer.borderWidth = 0.8
    return textView
  }()

  private lazy var sentencePlaceholderLabel: BKTitleLabel = {
    let label = BKTitleLabel(textAlignment: .left, fontSize: 17, fontWeight: .medium)
    label.text = "문장 수집하기"
    return label
  }()

  private lazy var thoughtPlaceholderLabel: BKTitleLabel = {
    let label = BKTitleLabel(textAlignment: .left, fontSize: 17, fontWeight: .medium)
    label.text = "내 생각 적기"
    return label
  }()

  private lazy var saveButton: UIBarButtonItem = {
    let button = UIBarButtonItem(
      title: "저장",
      style: .done,
      target: self,
      action: #selector(saveButtonTapped))
    button.tintColor = .bkTabBarTintColor
    return button
  }()

  private func setupSentenceUI() {
    let padding: CGFloat = 20
    view.addSubviews(pageTextField, pagePlaceholderLabel, sentencePlaceholderLabel, textView)
    NSLayoutConstraint.activate([
      pagePlaceholderLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
      pagePlaceholderLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
      pagePlaceholderLabel.heightAnchor.constraint(equalToConstant: padding),

      pageTextField.topAnchor.constraint(equalTo: pagePlaceholderLabel.bottomAnchor, constant: padding),
      pageTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
      pageTextField.heightAnchor.constraint(equalToConstant: 50),
      pageTextField.widthAnchor.constraint(equalToConstant: 100),

      sentencePlaceholderLabel.topAnchor.constraint(equalTo: pageTextField.bottomAnchor, constant: padding),
      sentencePlaceholderLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
      sentencePlaceholderLabel.heightAnchor.constraint(equalToConstant: padding),

      textView.topAnchor.constraint(equalTo: sentencePlaceholderLabel.bottomAnchor, constant: padding),
      textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
      textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
      textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
    ])
  }

  private func setupThoughtUI() {
    let padding: CGFloat = 20
    view.addSubviews(thoughtPlaceholderLabel, textView)
    NSLayoutConstraint.activate([
      thoughtPlaceholderLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
      thoughtPlaceholderLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
      thoughtPlaceholderLabel.heightAnchor.constraint(equalToConstant: padding),

      textView.topAnchor.constraint(equalTo: thoughtPlaceholderLabel.bottomAnchor, constant: padding),
      textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
      textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
      textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
    ])
  }

  private func setupNavigationController() {
    navigationItem.rightBarButtonItem = saveButton
    navigationItem.rightBarButtonItem?.tintColor = .bkTabBarTint
//    self.navigationItem.backButtonTitle = ""
    navigationItem.backButtonDisplayMode = .minimal
//    self.navigationItem.leftBarButtonItem?.tintColor = .bkTabBarTint
  }

  @objc
  private func saveButtonTapped() {
    switch style {
    case .sentence:
      // 페이지, 내용 없을경우 에러처리
      guard let pageString = pageTextField.text, !pageString.isEmpty else {
        var style = ToastStyle()
        style.messageFont = UIFont(name: Fonts.HanSansNeo.medium.description, size: 16)!
        style.backgroundColor = .systemRed
        self.view.makeToast(BKError.noPageInput.description, duration: 1, position: .center, style: style)
        return
      }

      if (textView.text == style.placeHolderString) || textView.text.isEmpty {
        var style = ToastStyle()
        style.messageFont = UIFont(name: Fonts.HanSansNeo.medium.description, size: 16)!
        style.backgroundColor = .systemRed
        self.view.makeToast(BKError.noContentInput.description, duration: 1, position: .center, style: style)
        return        
      }

      guard let page = Int(pageString) else {
        var style = ToastStyle()
        style.messageFont = UIFont(name: Fonts.HanSansNeo.medium.description, size: 16)!
        style.backgroundColor = .systemRed
        self.view.makeToast(BKError.pageInputInvalid.description, duration: 1, position: .center, style: style)
        return
      }

      let sentence = Sentence(book: book, page: page, memo: textView.text)

      do {
        try PersistenceManager.shared.addSentence(sentence: sentence)
      } catch (let error) {
        let bkError = error as? BKError
        self.presentBKAlert(title: "저장에 실패했어요.", message: bkError?.description ?? "다시 시도하거나 개발자에게 문의해주세요.", buttonTitle: "확인")
      }

    case .thought:
      // text 없을경우 에러처리
      if (textView.text == self.style.placeHolderString) || textView.text.isEmpty {
        var style = ToastStyle()
        style.messageFont = UIFont(name: Fonts.HanSansNeo.medium.description, size: 16)!
        style.backgroundColor = .systemRed
        self.view.makeToast(BKError.noContentInput.description, duration: 1, position: .center, style: style)
        return
      }

      let thought = Thought(book: book, memo: textView.text)

      do {
        try PersistenceManager.shared.addThought(thought)
      } catch (let error) {
        let bkError = error as? BKError
        self.presentBKAlert(title: "저장에 실패했어요.", message: bkError?.description ?? "다시 시도하거나 개발자에게 문의해주세요.", buttonTitle: "확인")
      }
    }

    var style = ToastStyle()
    style.messageFont = UIFont(name: Fonts.HanSansNeo.medium.description, size: 16)!
    style.backgroundColor = .systemGreen
    self.view.makeToast("저장되었습니다.", duration: 1, position: .center, style: style) { _ in
      self.navigationController?.popViewController(animated: true)
    }

  }

}

// MARK: AddRecordViewController.style

extension AddRecordViewController {
  enum recordStyle {
    case sentence, thought

    var placeHolderString: String {
      switch self {
      case .sentence:
        return "인상깊었던 문장을 입력하세요"
      case .thought:
        return "책을 읽으며 했던 생각이나 느꼈던 감정을 입력하세요"
      }
    }
  }
}

// MARK: UITextViewDelegate

extension AddRecordViewController: UITextViewDelegate {

  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.text == self.style.placeHolderString {
      textView.text = nil
      textView.textColor = .black
    }
  }

  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
      textView.text = self.style.placeHolderString
      textView.textColor = .lightGray
    }
  }
}
