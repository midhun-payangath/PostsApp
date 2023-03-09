//
//  PostCommentListViewModelError.swift
//  PostsApp
//
//  Created by MacBook Pro on 09/03/23.
//

import Foundation

enum PostCommentListViewModelError: GenericErrorEnum {
    var id: Self { self }
    
    case postIdMissing
    case other(String)

    var title: String {
        switch self {
        case .postIdMissing:
            return StringContant.txt.postNotFound
        default:
            return StringContant.txt.error
        }
    }

    var errorDescription: String {
        switch self {
        case .postIdMissing:
            return StringContant.txt.pleaseTryAgainLater
        case .other(let error):
            return error
        }
    }
}
