//
//  NetworkManager.swift
//  Bookie
//
//  Created by 박제균 on 10/31/23.
//

import UIKit

final class NetworkManager {

  // MARK: Lifecycle

  // MARK: - Initializer
  private init() { }

  // MARK: Internal

  // MARK: - Properties
  static let shared = NetworkManager()

  let cache = NSCache<NSString, UIImage>()

  // MARK: - Methods
  func searchBookInformation(for keyword: String, page: Int, completion: @escaping (Result<SearchResult, BKError>) -> Void) {
    let endPoint = baseURL + "&Query=\(keyword)&MaxResults=50&Cover=Big&start=\(page)&SearchTarget=All&output=js&Version=20131101"

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

  func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
    let cacheKey = NSString(string: urlString)

    if let image = cache.object(forKey: cacheKey) {
      completion(image)
      return
    }

    guard let url = URL(string: urlString) else {
      completion(nil)
      return
    }

    let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in

      guard let self else {
        completion(nil)
        return
      }

      if error != nil {
        completion(nil)
        return
      }

      guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        completion(nil)
        return
      }

      guard let data else {
        completion(nil)
        return
      }

      guard let image = UIImage(data: data) else {
        completion(nil)
        return
      }

      cache.setObject(image, forKey: cacheKey)

      completion(image)
    }

    task.resume()
  }

  // MARK: Private

  private let baseURL = "https://www.aladin.co.kr/ttb/api/ItemSearch.aspx?ttbkey=\(Bundle.main.APIKey)"
}
