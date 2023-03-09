//
//  PostListView.swift
//  PostsApp
//
//  Created by MacBook Pro on 09/03/23.
//

import SwiftUI

struct PostListView: View {
    
    @StateObject private var viewModel = PostListViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            List {
                ForEach($viewModel.posts, id: \.id) { post in
                    NavigationLink(destination: {
                    }, label: {
                        PostRowView(post: post, onFavouriteToggled: viewModel.toggleFavouriteFor)
                    })
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }
            }
            .refreshable {
                viewModel.fetchPostList()
            }
            .listStyle(PlainListStyle())
            FilterTabView(categories: viewModel.categories, action: viewModel.toggleCategory)
        }
        .withErrorHandling(error: $viewModel.viewModelError)
        .loaderViewWrapper(isLoading: viewModel.isLoading)
        .navigationBarBackButtonHidden(true)
        .navigationTitle(Text(StringContant.txt.myPosts))
        .toolbar {
            Button(StringContant.txt.logout) {
                viewModel.logOut()
                dismiss()
            }
        }
    }
    
}

struct PostListView_Previews: PreviewProvider {
    static var previews: some View {
        PostListView()
    }
}

