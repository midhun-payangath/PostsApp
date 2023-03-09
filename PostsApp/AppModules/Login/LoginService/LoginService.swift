//
//  LoginService.swift
//  PostsApp
//
//  Created by MacBook Pro on 08/03/23.
//

import Foundation
import Combine

typealias userLoginPublisher = AnyPublisher<UserModel, APIError>

protocol LoginServiceProtocol {
    var apiClient: APIService { get }
    func userLogin(_ request: LoginRequest) -> userLoginPublisher
    //signup
}

struct LoginService: LoginServiceProtocol {
    var apiClient: APIService = APIService()
    
    func userLogin(_ request: LoginRequest) -> userLoginPublisher {
        return apiClient.publisher(for: request)
    }
}


