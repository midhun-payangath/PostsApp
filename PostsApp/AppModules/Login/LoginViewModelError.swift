//
//  LoginViewModelError.swift
//  PostsApp
//
//  Created by MacBook Pro on 08/03/23.
//

import Foundation

enum LoginViewModelError: GenericErrorEnum {
    var id: Self { self }
    
    case userNotFound
    case other(String)

    var title: String {
        switch self {
        case .userNotFound:
            return StringContant.txt.userNotFound
        default:
            return StringContant.txt.pleaseEnterValidUserId
        }
    }

    var errorDescription: String {
        switch self {
        case .userNotFound:
            return StringContant.txt.pleaseEnterValidUserId
        case .other(let error):
            return error
        }
    }
}
