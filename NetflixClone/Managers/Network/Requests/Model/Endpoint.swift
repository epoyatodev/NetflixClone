//
//  Endpoint.swift
//  NetflixClone
//
//  Created by Enrique Poyato Ortiz on 19/11/25.
//

import Foundation

enum Endpoint: String {
    case trendingMovies = "/3/trending/movie/day"
    case trendingTv = "/3/trending/tv/day"
    case upcoming = "/3/movie/upcoming"
    case popular = "/3/movie/popular"
    case topRated = "/3/movie/top_rated"
    case discover = "/3/discover/movie"
    case search = "/3/search/movie"
    case ytSearch = "/search"
}
