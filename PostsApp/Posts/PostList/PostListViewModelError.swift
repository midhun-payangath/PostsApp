//
//  PostListViewModelError.swift
//  PostsApp
//
//  Created by MacBook Pro on 09/03/23.
//

import Foundation

enum PostListViewModelError: GenericErrorEnum {
    var id: Self { self }
    
    case userNotFound
    case other(String)
    
    var title: String {
        switch self {
        case .userNotFound:
            return StringContant.txt.sessionExpired
        default:
            return StringContant.txt.error
        }
    }
    
    var errorDescription: String {
        switch self {
        case .userNotFound:
            return StringContant.txt.pleaseLogoutAndLoginAgain
        case .other(let error):
            return error
        }
    }
}
