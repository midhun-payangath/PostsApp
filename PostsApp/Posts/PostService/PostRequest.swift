//
//  PostRequest.swift
//  PostsApp
//
//  Created by MacBook Pro on 09/03/23.
//

import Foundation

struct postListRequest : APIRequestBuilder {
    
    var method: NetworkMethod {
        return .get
    }
    
    var path: String {
        return "users/\(userId)/posts"
    }
    
    var userId: String
}
