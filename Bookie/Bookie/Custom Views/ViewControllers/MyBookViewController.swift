//
//  MyBookViewController.swift
//  Bookie
//
//  Created by 박제균 on 2/16/24.
//

import CoreData
import UIKit

class MyBookViewController: BKLoadingViewController {

  var myBooks: [MyBook] = []

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

  private func getMyBooks() {
    do {
      myBooks = try PersistenceManager.shared.fetchMyBooks()
    } catch(let error) {
      guard let bkError = error as? BKError else { return }
      self.presentBKAlert(title: "도서를 불러올 수 없습니다.", message: bkError.description, buttonTitle: "확인")
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

extension MyBookViewController: UICollectionViewDelegate {

}

extension MyBookViewController: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return myBooks.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyBookCollectionViewCell.reuseID, for: indexPath) as? MyBookCollectionViewCell else { return UICollectionViewCell() }
    let myBook = myBooks[indexPath.item]
    cell.setContents(book: myBook)

    return cell
  }

}

extension MyBookViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 8
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 8
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return CGSize() }
//    flowLayout.estimatedItemSize = .zero

    let width = collectionView.frame.width - flowLayout.minimumInteritemSpacing
    let height = collectionView.frame.height - flowLayout.minimumLineSpacing

    let cellWidth = (width - flowLayout.sectionInset.left * 2) / 2
    let cellHeight = (height - flowLayout.sectionInset.top * 2) / 3

    return CGSize(width: cellWidth, height: cellHeight)
  }
}
