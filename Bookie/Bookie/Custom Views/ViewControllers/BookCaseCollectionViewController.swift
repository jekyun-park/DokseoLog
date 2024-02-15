//
//  BookCaseCollectionViewController.swift
//  Bookie
//
//  Created by 박제균 on 2/15/24.
//

import UIKit

private let reuseIdentifier = "BookBaseCollectionViewCell"

class BookCaseCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    // MARK: UICollectionViewDataSource


    // MARK: UICollectionViewDelegate
}

extension BookCaseCollectionViewController {
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
      return 0
  }


  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      // #warning Incomplete implementation, return the number of items
      return 2
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)

      // Configure the cell

      return cell
  }

}
