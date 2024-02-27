//
//  WishListViewController.swift
//  Bookie
//
//  Created by 박제균 on 2/16/24.
//

import CoreData
import UIKit

class WishListViewController: BKLoadingViewController {

  var wishList: [MyBookEntity] = []

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
    getWishList()
    setupCollectionView()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    getWishList()
    showLoadingView()
    collectionView.reloadData()
    dismissLoadingView()
  }

  private func getWishList() {
    do {
      wishList = try PersistenceManager.shared.fetchWishList()
    } catch(let error) {
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
    collectionView.register(WishListCollectionViewCell.self, forCellWithReuseIdentifier: WishListCollectionViewCell.reuseID)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
  }

}

extension WishListViewController: UICollectionViewDelegate {

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let myBook = wishList[indexPath.item]
    let book = Book(title: myBook.title!, link: myBook.link!, author: myBook.author!, description: myBook.bookDescription!, publishedAt: myBook.publishedAt!, isbn13: myBook.isbn13!, coverURL: myBook.coverURL!, publisher: myBook.publisher!, page: Int(myBook.totalPage))

    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let window = windowScene.windows.first,
       let rootViewController = window.rootViewController as? BKTabBarController {
      let vc = rootViewController.viewControllers?[1] as? UINavigationController
      let pushViewController = BookInformationViewController(book: book, style: .move)
      vc?.pushViewController(pushViewController, animated: true)
    }

  }
}

extension WishListViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return wishList.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WishListCollectionViewCell.reuseID, for: indexPath) as? WishListCollectionViewCell else { return UICollectionViewCell() }
    let myBook = wishList[indexPath.item]
    cell.setContents(book: myBook)
    return cell
  }
  
}

extension WishListViewController: UICollectionViewDelegateFlowLayout {

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
