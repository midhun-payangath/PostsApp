//
//  PostCommentListViewModel.swift
//  PostsApp
//
//  Created by MacBook Pro on 09/03/23.
//

import Foundation
import Combine

class PostCommentListViewModel: ObservableObject {
    
    private var bindings = Set<AnyCancellable>()
    private let postService: PostService = PostService()
    @Published var isLoading: Bool = false
    @Published var viewModelError: PostCommentListViewModelError?
    
    @Published var comments: [CommentModel] = []
    @Published var selectedPostId: Int?
     
    func loadPostComments(postId: Int?) {
        self.selectedPostId = postId
        fetchPostCommentList(id: selectedPostId)
    }
    
    func fetchPostCommentList(id: Int?) {
        viewModelError = nil
        isLoading = true
        let completionHandler: (Subscribers.Completion<APIError>) -> Void = { [weak self] completion in
            guard let self = self else { return}
            self.isLoading = false
            switch completion {
            case .failure(let error):
                self.comments = []
                switch error {
                case .network(let msg), .other(let msg), .decoding(let msg):
                    self.viewModelError = .other(msg.localizedDescription)
                }
            case .finished:
                break
            }
        }
        
        guard let postId = id?.description else {
            self.isLoading = false
            self.viewModelError = .postIdMissing
            return
        }
        let request = postCommentListRequest(postId: postId)
        postService.getPostCommentList(request)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: completionHandler, receiveValue: { [weak self] commentListResponse in
                guard let self = self else { return}
                self.comments = commentListResponse
            })
            .store(in: &bindings)
    }
}

