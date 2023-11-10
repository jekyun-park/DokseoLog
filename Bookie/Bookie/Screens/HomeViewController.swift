//
//  HomeViewController.swift
//  Bookie
//
//  Created by 박제균 on 2023/07/24.
//

import UIKit

// MARK: - HomeViewController

class HomeViewController: UIViewController {

  // MARK: Internal

  let searchBar = UISearchBar()
  let searchBookTextField = BKTextField()

  override func viewDidLoad() {
    super.viewDidLoad()
    configureViewController()
    configureTextField()
  }

  // MARK: Private

  private func configureViewController() {
    view.backgroundColor = .bkBackground
    navigationController?.navigationBar.prefersLargeTitles = false
    navigationController?.navigationBar.isHidden = true
  }

  private func configureTextField() {
    view.addSubview(searchBookTextField)
    searchBookTextField.delegate = self

    NSLayoutConstraint.activate([
      searchBookTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
      searchBookTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
      searchBookTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80),
      searchBookTextField.heightAnchor.constraint(equalToConstant: 40),
    ])
  }

}

// MARK: UITextFieldDelegate

extension HomeViewController: UITextFieldDelegate {
  func textFieldShouldBeginEditing(_: UITextField) -> Bool {
    let destinationViewController = SearchViewController()
//    destinationViewController.navigationController?.navigationBar.isHidden = false
    navigationController?.pushViewController(destinationViewController, animated: true)
    return true
  }
}

#Preview {
  HomeViewController()
}
