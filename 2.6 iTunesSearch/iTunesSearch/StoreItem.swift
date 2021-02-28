//
//  StoreItem.swift
//  iTunesSearch
//
//  Created by Oscar Lopez on 2/27/21.
//

import Foundation
import UIKit

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
        case artworkURL = "artworkUrl100"
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
