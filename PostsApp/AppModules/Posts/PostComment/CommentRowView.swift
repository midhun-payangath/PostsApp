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
        ZStack {
            Color.systemGray6
            VStack(alignment: .leading, spacing: 5) {
                Text(comment.name)
                    .font(.body)
                Text(comment.body)
                    .font(.footnote)
            }
            .frame(maxWidth:.infinity,maxHeight:.infinity,alignment:.topLeading)
            .padding()
        }
        .cornerRadius(5)
        .padding(EdgeInsets(top: 0, leading: 60, bottom: 0, trailing: 0))
    }
}

struct CommentRowView_Previews: PreviewProvider {
    static var previews: some View {
        CommentRowView(comment: CommentModel(postID: 1, id: 2, name: "midhun", email: "midhun@m.com", body: "sample description"))
    }
}

