//
//  MoviesService.swift
//  NetflixClone
//
//  Created by Enrique Poyato Ortiz on 19/11/25.
//

import Foundation


struct MoviesService {
    func getTrendingMovies() async throws -> [Title] {
        guard let baseURL = InfoManager.shared.getUrlString(forKey: .host) else { throw HttpError.invalidURL }
        guard let apiKey = InfoManager.shared.getUrlString(forKey: .apiKey) else { throw HttpError.invalidURL }
        
        let request = try RequestBuilder(endpoint: Endpoint.trendingMovies.rawValue,
                                         baseURL: baseURL,
                                         method: .get,
        queryItems: [
            .init(name: "api_key", value: apiKey)
        ])
            .buildURLRequest()
        
        let response: TrendingTitleResponse = try await URLRequestDispatcher().doRequest(request: request)
        
        return response.results
    }
    
    func getTrendingTVShows() async throws -> [Title] {
        guard let baseURL = InfoManager.shared.getUrlString(forKey: .host) else { throw HttpError.invalidURL }
        guard let apiKey = InfoManager.shared.getUrlString(forKey: .apiKey) else { throw HttpError.invalidURL }
        
        let request = try RequestBuilder(endpoint: Endpoint.trendingTv.rawValue,
                                         baseURL: baseURL,
                                         method: .get,
        queryItems: [
            .init(name: "api_key", value: apiKey)
        ])
            .buildURLRequest()
        
        let response: TrendingTitleResponse = try await URLRequestDispatcher().doRequest(request: request)
        
        return response.results
    }
    
    func getPopularMovies() async throws -> [Title] {
        guard let baseURL = InfoManager.shared.getUrlString(forKey: .host) else { throw HttpError.invalidURL }
        guard let apiKey = InfoManager.shared.getUrlString(forKey: .apiKey) else { throw HttpError.invalidURL }
        
        let request = try RequestBuilder(endpoint: Endpoint.popular.rawValue,
                                         baseURL: baseURL,
                                         method: .get,
                                         queryItems: [
                                            .init(name: "api_key", value: apiKey)
                                         ])
            .buildURLRequest()
        
        let response: TrendingTitleResponse = try await URLRequestDispatcher().doRequest(request: request)
        
        return response.results
    }
    
    func getUpcomingMovies() async throws -> [Title] {
        guard let baseURL = InfoManager.shared.getUrlString(forKey: .host) else { throw HttpError.invalidURL }
        guard let apiKey = InfoManager.shared.getUrlString(forKey: .apiKey) else { throw HttpError.invalidURL }
        
        let request = try RequestBuilder(endpoint: Endpoint.upcoming.rawValue,
                                         baseURL: baseURL,
                                         method: .get,
                                         queryItems: [
                                            .init(name: "api_key", value: apiKey)
                                         ])
            .buildURLRequest()
        
        let response: TrendingTitleResponse = try await URLRequestDispatcher().doRequest(request: request)
        
        return response.results
    }
    
    func getTopRatedMovies() async throws -> [Title] {
        guard let baseURL = InfoManager.shared.getUrlString(forKey: .host) else { throw HttpError.invalidURL }
        guard let apiKey = InfoManager.shared.getUrlString(forKey: .apiKey) else { throw HttpError.invalidURL }
        
        let request = try RequestBuilder(endpoint: Endpoint.topRated.rawValue,
                                         baseURL: baseURL,
                                         method: .get,
                                         queryItems: [
                                            .init(name: "api_key", value: apiKey)
                                         ])
            .buildURLRequest()
        
        let response: TrendingTitleResponse = try await URLRequestDispatcher().doRequest(request: request)
        
        return response.results
    }
    
    func getDiscoverMovies() async throws -> [Title] {
        guard let baseURL = InfoManager.shared.getUrlString(forKey: .host) else { throw HttpError.invalidURL }
        guard let apiKey = InfoManager.shared.getUrlString(forKey: .apiKey) else { throw HttpError.invalidURL }
        
        let request = try RequestBuilder(endpoint: Endpoint.discover.rawValue,
                                         baseURL: baseURL,
                                         method: .get,
                                         queryItems: [
                                            .init(name: "api_key", value: apiKey),
                                            .init(name: "sort_by", value: "popularity.desc"),
                                            .init(name: "include_adult", value: "false"),
                                            .init(name: "include_video", value: "false"),
                                            .init(name: "page", value: "1"),
                                            .init(name: "with_watch_monetization_types", value: "flatrate")
                                         ])
            .buildURLRequest()
        
        let response: TrendingTitleResponse = try await URLRequestDispatcher().doRequest(request: request)
        
        return response.results
    }
    
    func searchMovies(query: String) async throws -> [Title] {
        guard let baseURL = InfoManager.shared.getUrlString(forKey: .host) else { throw HttpError.invalidURL }
        guard let apiKey = InfoManager.shared.getUrlString(forKey: .apiKey) else { throw HttpError.invalidURL }
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return []
        }
        
        let request = try RequestBuilder(endpoint: Endpoint.search.rawValue,
                                         baseURL: baseURL,
                                         method: .get,
                                         queryItems: [
                                            .init(name: "api_key", value: apiKey),
                                            .init(name: "query", value: query)
                                         ])
            .buildURLRequest()
        
        let response: TrendingTitleResponse = try await URLRequestDispatcher().doRequest(request: request)
        
        return response.results
    }
    
    func getMovie(with query: String) async throws -> VideoElement {
        guard let baseURL = InfoManager.shared.getUrlString(forKey: .ytSearchHost) else { throw HttpError.invalidURL }
        guard let apiKey = InfoManager.shared.getUrlString(forKey: .ytApiKey) else { throw HttpError.invalidURL }
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { throw HttpError.invalidURL}
        
        let request = try RequestBuilder(endpoint: Endpoint.ytSearch.rawValue,
                                         baseURL: baseURL,
                                         method: .get,
                                         queryItems: [
                                            .init(name: "q", value: query),
                                            .init(name: "key", value: apiKey),
                                            .init(name: "regionCode", value: "es"),
                                            .init(name: "relevanceLanguage", value: "es")
                                         ])
            .buildURLRequest()
        
        let response: YoutubeSearchResponse = try await URLRequestDispatcher().doRequest(request: request)
        
        return response.items[0]
    }
}
