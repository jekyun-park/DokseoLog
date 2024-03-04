//
//  ModifyRecordViewController.swift
//  Bookie
//
//  Created by 박제균 on 2/23/24.
//

import UIKit

// MARK: - ModifyRecordViewController

class ModifyRecordViewController: UIViewController {

  // MARK: Lifecycle

  init(_ sentence: Sentence) {
    self.sentence = sentence
    thought = nil
    self.style = .sentence
    super.init(nibName: nil, bundle: nil)
  }

  init(_ thought: Thought) {
    sentence = nil
    self.thought = thought
    self.style = .thought
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  let sentence: Sentence?
  let thought: Thought?
  let style: ModifyRecordViewController.style

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
    textField.text = String(self.sentence?.page ?? 0)
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
    textView.delegate = self
    textView.autocorrectionType = .no
    textView.spellCheckingType = .no
    textView.font = UIFont(name: Fonts.HanSansNeo.medium.description, size: 15)
    textView.textColor = .label
    textView.layer.cornerRadius = 5
    textView.layer.borderColor = UIColor.systemGray4.cgColor
    textView.layer.borderWidth = 0.8
    switch self.style {
    case .sentence:
      textView.text = self.sentence?.memo
    case .thought:
      textView.text = self.thought?.memo
    }
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

  private lazy var deleteButton: UIBarButtonItem = {
    let button = UIBarButtonItem(
      image: Images.trashImage,
      style: .plain,
      target: self,
      action: #selector(deleteButtonTapped))
    button.tintColor = .red
    return button
  }()

  private lazy var updateButton: UIBarButtonItem = {
    let button = UIBarButtonItem(
      title: "수정",
      style: .done,
      target: self,
      action: #selector(updateButtonTapped))
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
    navigationItem.rightBarButtonItems = [deleteButton, updateButton]
    navigationController?.navigationItem.backButtonDisplayMode = .minimal
    navigationItem.leftBarButtonItem = .none
  }

  @objc
  private func updateButtonTapped() {
    switch self.style {
    case .sentence:
      // 페이지, 내용 없을경우 에러처리
      guard let pageString = pageTextField.text, !pageString.isEmpty else {
        presentBKAlert(title: "저장에 실패했습니다.", message: BKError.noPageInput.description, buttonTitle: "확인")
        return
      }

      if (textView.text == self.style.placeHolderString) || textView.text.isEmpty {
        presentBKAlert(title: "저장에 실패했습니다.", message: BKError.noContentInput.description, buttonTitle: "확인")
        return
      }

      guard let page = Int(pageString) else {
        presentBKAlert(title: "저장에 실패했습니다.", message: BKError.pageInputInvalid.description, buttonTitle: "확인")
        return
      }

      let sentence = Sentence(
        book: sentence!.book,
        page: page,
        memo: textView.text,
        id: sentence!.id,
        createdAt: sentence!.createdAt)
      let update = PersistenceManager.shared.updateSentence(sentence)

      switch update {
      case .success:
        break
      case .failure(let error):
        presentBKAlert(title: "저장에 실패했어요.", message: error.description , buttonTitle: "확인")
        return
      }

    case .thought:
      // text 없을경우 에러처리
      if (textView.text == self.style.placeHolderString) || textView.text.isEmpty {
        presentBKAlert(title: "내용을 입력해주세요", message: BKError.noContentInput.description, buttonTitle: "확인")
        return
      }

      let thought = Thought(book: thought!.book, memo: textView.text, id: thought!.id, createdAt: thought!.createdAt)
      let update = PersistenceManager.shared.updateThought(thought)

      switch update {
      case .success:
        break
      case .failure(let error):
        presentBKAlert(title: "저장에 실패했어요.", message: error.description , buttonTitle: "확인")
        return
      }
    }

    navigationController?.popViewController(animated: true)
    // toast alert
  }

  @objc
  private func deleteButtonTapped() {
    let alertController = UIAlertController(title: "삭제하시겠습니까?", message: "기록이 삭제됩니다.", preferredStyle: .alert)

    alertController.addAction(UIAlertAction(title: "취소", style: .cancel) { _ in
      self.dismiss(animated: true)
    })

    alertController.addAction(UIAlertAction(title: "삭제", style: .destructive) { _ in
      switch self.style {
      case .sentence:
        let result = PersistenceManager.shared.deleteSentence(self.sentence!)
        switch result {
        case .success:
          break
        case .failure(let error):
          self.presentBKAlert(title: "데이터 삭제를 실패했어요.", message: error.description, buttonTitle: "확인")
          return
        }
      case .thought:
        let result = PersistenceManager.shared.deleteThought(self.thought!)
        switch result {
        case .success:
          break
        case .failure(let error):
          self.presentBKAlert(title: "데이터 삭제를 실패했어요.", message: error.description, buttonTitle: "확인")
          return
        }
      }
      self.navigationController?.popViewController(animated: true)
    })

    present(alertController, animated: true)
  }

}

// MARK: ModifyRecordViewController.style

extension ModifyRecordViewController {
  enum style {
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

extension ModifyRecordViewController: UITextViewDelegate {

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
