//
//  APIRequestBuilder.swift
//  PostsApp
//
//  Created by MacBook Pro on 08/03/23.
//

import Foundation

public enum NetworkMethod: Equatable {
    case get
    case put(Data?)
    case post(Data?)
    
    var name: String {
        switch self {
        case .get: return "GET"
        case .put: return "PUT"
        case .post: return "POST"
        }
    }
}

public enum URLScheme: Equatable {
    case http
    case https
    
    var name: String {
        switch self {
        case .http: return "http://"
        case .https: return "https://"
        }
    }
}

public typealias Parameters = [String: Any]

public protocol APIRequestBuilder {
    
    var scheme: URLScheme { get }
    var baseURL: URL { get }
    var path: String { get }
    var method: NetworkMethod { get }
    func urlRequest() -> URLRequest
    func parameters() -> Parameters?
    func headers() -> [String: String]?
}

extension APIRequestBuilder {
    
    var scheme: URLScheme {
        URLScheme.https
    }
    
    var baseURL: URL {
        guard let host = EnvConfig.value(EnvConfig.HOST), let url = URL(string: scheme.name + host) else {
            fatalError("Unable to configure base url")
        }
        return url
    }
    
    func sampleData() -> Data? {
        return Data()
    }
    
    func urlRequest() -> URLRequest {
        var request = URLRequest(url: baseURL)
        
        switch method {
        case .post(let data), .put(let data):
            request.httpBody = data
        case .get:
            let url = baseURL.appendingPathComponent(path)
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            guard let url = components?.url else { preconditionFailure("Invalid URL format...") }
            request = URLRequest(url: url)
        }
        
        request.allHTTPHeaderFields = headers()
        request.httpMethod = method.name
        return request
    }
    
    func parameters() -> Parameters? {
        return nil
    }
    
    func headers() -> [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
