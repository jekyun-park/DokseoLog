//
//  NetworkManager.swift
//  Bookie
//
//  Created by 박제균 on 10/31/23.
//

import Foundation

final class NetworkManager {

  // MARK: Lifecycle

  // &Query=아주 작은 습관의 힘&MaxResults=50&start=1&SearchTarget=Book&output=js&Version=20131101

  // MARK: - Initializer
  private init() { }

  // MARK: Internal

  // MARK: - Properties
  static let shared = NetworkManager()

  // MARK: - Methods
  func searchBookInformation(for keyword: String, page: Int, completion: @escaping (Result<SearchResult, BKError>) -> Void) {
    let endPoint = baseURL + "&Query=\(keyword)&MaxResults=50&start=\(page)&output=js&Version=20131101"

    guard let url = URL(string: endPoint) else {
      completion(.failure(.invalidURL))
      return
    }

    let task = URLSession.shared.dataTask(with: url) { data , response, error in
      if error != nil {
        completion(.failure(.unableToComplete))
        return
      }

      guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        completion(.failure(.invalidResponse))
        return
      }

      guard let data else {
        completion(.failure(.invalidData))
        return
      }

      do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let result = try decoder.decode(SearchResult.self, from: data)
        completion(.success(result))
      } catch {
        completion(.failure(.invalidData))
      }
    }

    task.resume()
  }

  // MARK: Private

  private let baseURL = "https://www.aladin.co.kr/ttb/api/ItemSearch.aspx?ttbkey=\(Bundle.main.APIKey)"
}
