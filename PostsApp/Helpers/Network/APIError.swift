//
//  APIError.swift
//  PostsApp
//
//  Created by MacBook Pro on 08/03/23.
//

import Foundation

enum APIError: Swift.Error {
    case network(Error)
    case decoding(Error)
    case other(Error)
}
