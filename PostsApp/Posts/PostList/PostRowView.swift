//
//  PostRowView.swift
//  PostsApp
//
//  Created by MacBook Pro on 09/03/23.
//

import SwiftUI

struct PostRowView: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var post: PostModel
    var onFavouriteToggled: ((PostModel) -> Bool?)
    
    var body: some View {
        
        ZStack {
            Color.teal.opacity(0.2)
            VStack(alignment: .leading, spacing: 2) {
                HStack(alignment: .center) {
                    Text(post.title)
                        .font(.headline)
                    Spacer()
                    Heart(isFilled: post.isFavourite)
                        .font(.title)
                        .onTapGesture {
                            if onFavouriteToggled(post) != nil {
                                dismiss()
                            }
                        }
                }
                VStack(alignment: .leading) {
                    Text(post.body)
                        .font(.subheadline)
                }
            }
            .padding()
        }
        .cornerRadius(5)
    }
}

