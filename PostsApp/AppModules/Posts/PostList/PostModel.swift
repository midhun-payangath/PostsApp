//
//  PostModel.swift
//  PostsApp
//
//  Created by MacBook Pro on 09/03/23.
//

import Foundation

struct PostModel: Codable, Identifiable {
    var id: Int
    var userId: Int
    var title, body: String
    var isFavourite: Bool = false

    enum CodingKeys: String, CodingKey {
        case userId, id, title, body
    }
}

