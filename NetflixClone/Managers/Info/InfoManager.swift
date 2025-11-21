//
//  InfoManager.swift
//  NetflixClone
//
//  Created by Enrique Poyato Ortiz on 19/11/25.
//

import Foundation

enum DictionaryKey: String {
    case host = "HOST_URL"
    case apiKey = "API_KEY"
    case ytApiKey = "YT_API_KEY"
    case ytSearchHost = "YT_SEARCH_HOST"
}

final class InfoManager {
    static let shared = InfoManager()
    
    private init() {}
    
    func getUrlString(forKey key: DictionaryKey) -> String? {
        if let infoDictionary = Bundle.main.infoDictionary,
           let urls = infoDictionary["urls"] as? [String: Any],
           let urlString = urls[key.rawValue] as? String {
            return urlString
        }
        return nil
    }
}
