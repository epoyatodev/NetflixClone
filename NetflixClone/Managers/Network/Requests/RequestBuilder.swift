//
//  RequestBuilder.swift
//  NetflixClone
//
//  Created by Enrique Poyato Ortiz on 19/11/25.
//

import Foundation

struct RequestBuilder {
    let baseURL: String
    let completeURL: String
    let url: URL?
    let queryItems: [URLQueryItem]?
    let data: Data?
    let method: HttpMethod
    
    init(endpoint: String, baseURL: String, method: HttpMethod, data: Data? = nil, queryItems: [URLQueryItem]? = nil) {
        self.baseURL = baseURL
        self.completeURL = baseURL + endpoint
        self.url = URL(string: completeURL)
        self.data = data
        self.queryItems = queryItems
        self.method = method
    }
    
    func buildURLRequest() throws -> URLRequest {
        guard url != nil else {
            throw HttpError.invalidURL
        }
        
        var urlComponents = URLComponents(string: self.completeURL)
        
        if let queryItems {
            urlComponents?.queryItems = queryItems
        }
        
        guard let url = urlComponents?.url else {
            throw HttpError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        if let data, method == .post {
            urlRequest.httpBody = data
        }
        
        return urlRequest
    }
}
