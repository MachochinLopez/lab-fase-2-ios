//
//  StoreItemController.swift
//  iTunesSearch
//
//  Created by Oscar Lopez on 2/27/21.
//

import Foundation
import UIKit

class StoreItemController {
    /**
     *  Funcion para hacer fetch de los items
     */
    func fetchItems(matching query: [String: String], completion:
        @escaping (Result<[StoreItem], Error>) -> Void) {
        var urlComponents = URLComponents(string:
           "https://itunes.apple.com/search")!
        urlComponents.queryItems = query.map { URLQueryItem(name: $0.key,
           value: $0.value) }
        let task = URLSession.shared.dataTask(with: urlComponents.url!)
           { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let searchResponse = try
                       decoder.decode(SearchResponse.self, from: data)
                    completion(.success(searchResponse.results))
                } catch {
                    completion(.failure(error))
                }
            }
        }

        task.resume()
    }

}
