//
//  LoginRequest.swift
//  PostsApp
//
//  Created by MacBook Pro on 08/03/23.
//

import Foundation

struct LoginRequest : APIRequestBuilder {
    
    var method: NetworkMethod {
        return .get
    }
    
    var path: String {
        return "users/\(userId)/"
    }
    
    var userId: String
}
