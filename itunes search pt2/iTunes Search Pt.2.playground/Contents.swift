import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

/**
 *  Definicion del modelo StoreItem
 */
struct StoreItem: Codable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: CodingKeys.name)
        artist = try values.decode(String.self, forKey: CodingKeys.artist)
        kind = try values.decode(String.self, forKey: CodingKeys.kind)
        artworkURL = try values.decode(URL.self, forKey:
           CodingKeys.artworkURL)
    
        if let description = try? values.decode(String.self,
           forKey: CodingKeys.description) {
            self.description = description
        } else {
            let additionalValues = try decoder.container(keyedBy:
               AdditionalKeys.self)
            description = (try? additionalValues.decode(String.self,
               forKey: AdditionalKeys.longDescription)) ?? ""
        }
    }
    
    var name: String
    var artist: String
    var kind: String
    var description: String
    var artworkURL: URL
    
    enum CodingKeys: String, CodingKey {
        case description
        case name = "trackName"
        case artist = "artistName"
        case kind
        case artworkURL = "trackViewUrl"
    }
    
    enum AdditionalKeys: String, CodingKey {
        case longDescription
    }
}

/**
 *  Modelo Search Response
 */
struct SearchResponse: Codable {
    let results: [StoreItem]
}

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

let query = [
    "term": "Apple",
    "media": "ebook",
    "attribute": "authorTerm",
    "lang": "es_mx",
    "limit": "10"
]

fetchItems(matching: query) { (result) in
    switch result {
    case .success(let storeItems):
        storeItems.forEach { item in
            print("""
                
            -----------------------------
            Name: \(item.name)
            Artist: \(item.artist)
            Kind: \(item.kind)
            Description: \(item.description)
            Artwork URL: \(item.artworkURL)
            -----------------------------
                
            """)
        }
    case .failure(let error):
        print(error)
    }

    PlaygroundPage.current.finishExecution()
}
