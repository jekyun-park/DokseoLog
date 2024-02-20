//
//  BookBasketViewController.swift
//  Bookie
//
//  Created by 박제균 on 2/16/24.
//

import CoreData
import UIKit

class BookBasketViewController: BKLoadingViewController {

  var bookBasket: [MyBook] = []

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
    getBookBasket()
    setupCollectionView()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    getBookBasket()
    showLoadingView()
    collectionView.reloadData()
    dismissLoadingView()
  }

  private func getBookBasket() {
    do {
      bookBasket = try PersistenceManager.shared.fetchBookBasket()
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
    collectionView.register(BookBasketCollectionViewCell.self, forCellWithReuseIdentifier: BookBasketCollectionViewCell.reuseID)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
  }

}

extension BookBasketViewController: UICollectionViewDelegate {

}

extension BookBasketViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return bookBasket.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookBasketCollectionViewCell.reuseID, for: indexPath) as? BookBasketCollectionViewCell else { return UICollectionViewCell() }
    let myBook = bookBasket[indexPath.item]
    cell.setContents(book: myBook)

    return cell
  }
  
}

extension BookBasketViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 8
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 8
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

    guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return CGSize() }

    let width = collectionView.frame.width - flowLayout.minimumInteritemSpacing
    let height = collectionView.frame.height - flowLayout.minimumLineSpacing

    let cellWidth = (width - flowLayout.sectionInset.left * 2) / 2
    let cellHeight = (height - flowLayout.sectionInset.top * 2) / 3

    return CGSize(width: cellWidth, height: cellHeight)
  }
}
