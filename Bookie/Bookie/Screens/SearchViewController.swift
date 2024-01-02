//
//  SearchViewController.swift
//  Bookie
//
//  Created by 박제균 on 11/10/23.
//

import UIKit

// MARK: - SearchViewController

class SearchViewController: UIViewController {

  // MARK: Internal

  let tableView = UITableView()
  let searchController = UISearchController()
  var results: [Item] = []
  var page = 1

  override func viewDidLoad() {
    super.viewDidLoad()
    configureViewController()
    configureSearchController()
    configureTableView()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }

  func updateUI(with books: [Item]) {
    results.append(contentsOf: books)
    DispatchQueue.main.async {
      self.tableView.reloadData()
      self.view.bringSubviewToFront(self.tableView)
    }
  }

  // MARK: Private

  private func getResults(for string: String) {
    NetworkManager.shared.searchBookInformation(for: string, page: page) { [weak self] result in
      guard let self else { return }
      switch result {
      case .success(let searchResult):
        updateUI(with: searchResult.books)
      case .failure(let error):
        print(error)
      }
    }
  }

  private func configureViewController() {
    view.backgroundColor = .bkBackground
    navigationController?.navigationBar.isHidden = false
    navigationController?.navigationItem.hidesSearchBarWhenScrolling = false
  }

  private func configureSearchController() {
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.searchBar.delegate = self
    searchController.searchBar.placeholder = "책 제목, 저자를 검색해보세요"
    navigationItem.searchController = searchController
  }

  private func configureTableView() {
    view.addSubview(tableView)
    tableView.frame = view.bounds
    tableView.delegate = self
    tableView.dataSource = self
    tableView.rowHeight = 120
    tableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.reuseID)
  }

}

// MARK: UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let searchString = searchBar.text else { return }
    results.removeAll()
    getResults(for: searchString)
  }

  func searchBarCancelButtonClicked(_: UISearchBar) {
    results.removeAll()
  }
}

// MARK: UITableViewDelegate, UITableViewDataSource

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {

  func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
    results.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.reuseID) as? SearchResultCell
    else { return UITableViewCell() }
    let searchResult = results[indexPath.row]
    cell.set(book: searchResult)
    return cell
  }

}
