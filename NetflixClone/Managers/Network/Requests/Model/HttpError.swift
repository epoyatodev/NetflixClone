//
//  HttpError.swift
//  NetflixClone
//
//  Created by Enrique Poyato Ortiz on 19/11/25.
//

import Foundation

enum HttpError: Error {
    case invalidURL
    case invalidResponse
    case errorDecoder(Error)
}
