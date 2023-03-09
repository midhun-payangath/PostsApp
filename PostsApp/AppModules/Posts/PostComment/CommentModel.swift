//
//  CommentModel.swift
//  PostsApp
//
//  Created by MacBook Pro on 09/03/23.
//

import Foundation

struct CommentModel: Codable, Identifiable {
    let postID, id: Int
    let name, email, body: String

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case id, name, email, body
    }
}
