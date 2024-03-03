//
//  MyBookCaseViewController.swift
//  Bookie
//
//  Created by 박제균 on 2/16/24.
//

import CoreData
import UIKit

// MARK: - MyBookCaseViewController

class MyBookCaseViewController: BKLoadingViewController {

  // MARK: Internal

  var myBooks: [MyBookEntity] = []

  let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.sectionInset = .init(top: 8, left: 8, bottom: 8, right: 8)
    layout.estimatedItemSize = .zero
    layout.scrollDirection = .vertical
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    return collectionView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    getMyBooks()
    setupCollectionView()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    getMyBooks()
    showLoadingView()
    collectionView.reloadData()
    dismissLoadingView()
  }

  // MARK: Private

  private func getMyBooks() {
    do {
      myBooks = try PersistenceManager.shared.fetchMyBooks()
    } catch (let error) {
      guard let bkError = error as? BKError else { return }
      self.presentBKAlert(title: "도서를 불러올 수 없어요.", message: bkError.description, buttonTitle: "확인")
    }
  }

  private func setupCollectionView() {
    view.addSubview(collectionView)
    collectionView.backgroundColor = .bkBackground
    collectionView.frame = view.bounds
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(MyBookCollectionViewCell.self, forCellWithReuseIdentifier: MyBookCollectionViewCell.reuseID)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
  }

}

// MARK: UICollectionViewDelegate

extension MyBookCaseViewController: UICollectionViewDelegate {

  func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let myBook = myBooks[indexPath.item]
    let book = Book(
      title: myBook.title!,
      link: myBook.link!,
      author: myBook.author!,
      description: myBook.bookDescription!,
      publishedAt: myBook.publishedAt!,
      isbn13: myBook.isbn13!,
      coverURL: myBook.coverURL!,
      publisher: myBook.publisher!,
      page: Int(myBook.totalPage))

    if
      let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
      let window = windowScene.windows.first,
      let rootViewController = window.rootViewController as? BKTabBarController
    {
      let vc = rootViewController.viewControllers?[1] as? UINavigationController
      vc?.pushViewController(MyBookViewController(book: book), animated: true)
    }
  }

}

// MARK: UICollectionViewDataSource

extension MyBookCaseViewController: UICollectionViewDataSource {

  func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
    myBooks.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: MyBookCollectionViewCell.reuseID,
        for: indexPath) as? MyBookCollectionViewCell
    else { return UICollectionViewCell() }
    let myBook = myBooks[indexPath.item]
    cell.setContents(book: myBook)

    return cell
  }

}

// MARK: UICollectionViewDelegateFlowLayout

extension MyBookCaseViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
    8
  }

  func collectionView(
    _: UICollectionView,
    layout _: UICollectionViewLayout,
    minimumInteritemSpacingForSectionAt _: Int)
    -> CGFloat
  {
    8
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt _: IndexPath)
    -> CGSize
  {
    guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return CGSize() }
//    flowLayout.estimatedItemSize = .zero

    let width = collectionView.frame.width - flowLayout.minimumInteritemSpacing
    let height = collectionView.frame.height - flowLayout.minimumLineSpacing

    let cellWidth = (width - flowLayout.sectionInset.left * 2) / 2
    let cellHeight = (height - flowLayout.sectionInset.top * 2) / 3

    return CGSize(width: cellWidth, height: cellHeight)
  }
}
