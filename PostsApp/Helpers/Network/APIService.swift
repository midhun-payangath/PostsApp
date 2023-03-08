//
//  APIService.swift
//  PostsApp
//
//  Created by MacBook Pro on 08/03/23.
//

import Foundation
import Combine

protocol APIProtocol {
    func publisher<T: Decodable>(for request: APIRequestBuilder, decoder: JSONDecoder) -> AnyPublisher<T, APIError>
}


struct APIService: APIProtocol {
    func publisher<T>(for request: APIRequestBuilder, decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<T, APIError> where T : Decodable {
        URLSession.shared.dataTaskPublisher(for: request.urlRequest())
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .map(\.data)
            .decode(type: T.self, decoder: decoder)
            .mapError({ error -> APIError in
                switch error {
                case is DecodingError:
                    return APIError.decoding(error)
                case is URLError:
                    return APIError.network(error)
                default:
                    return APIError.other(error)
                }})
            .eraseToAnyPublisher()
    }
}

