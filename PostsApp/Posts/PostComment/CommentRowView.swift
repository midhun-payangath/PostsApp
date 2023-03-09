//
//  CommentRowView.swift
//  PostsApp
//
//  Created by MacBook Pro on 09/03/23.
//

import SwiftUI

struct CommentRowView: View {
    var comment: CommentModel
    
    var body: some View {
        VStack {
            ZStack {
                Color.systemGray6
                VStack(alignment: .leading, spacing: 2) {
                    HStack(alignment: .center) {
                        Text(comment.name)
                            .font(.subheadline)
                    }
                    VStack(alignment: .leading) {
                        Text(comment.body)
                            .font(.body)
                    }
                }
                .padding(10)
            }
            .cornerRadius(5)
        }
        .padding(EdgeInsets(top: 0, leading: 60, bottom: 0, trailing: 0))
    }
}

struct CommentRowView_Previews: PreviewProvider {
    static var previews: some View {
        CommentRowView(comment: CommentModel(postID: 1, id: 2, name: "midhun", email: "midhun@m.com", body: "sample description"))
    }
}

