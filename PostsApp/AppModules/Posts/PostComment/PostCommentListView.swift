//
//  PostCommentListView.swift
//  PostsApp
//
//  Created by MacBook Pro on 09/03/23.
//

import SwiftUI

struct PostCommentListView: View {
    
    @Binding var postDetail: PostModel
    @State var onFavouriteToggled: ((PostModel) -> Bool?)
    
    @StateObject private var viewModel = PostCommentListViewModel()
    
    var body: some View {
        VStack {
            List {
                PostRowView(post: $postDetail, onFavouriteToggled: onFavouriteToggled)
                ForEach(viewModel.comments) { comment in
                    CommentRowView(comment: comment)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                }
            }
            .listStyle(PlainListStyle())
        }
        .withErrorHandling(error: $viewModel.viewModelError)
        .loaderViewWrapper(isLoading: viewModel.isLoading)
        .navigationTitle(Text(StringContant.txt.comments))
        .onAppear {
            viewModel.loadPostComments(postId: postDetail.id)
        }
    }
}
