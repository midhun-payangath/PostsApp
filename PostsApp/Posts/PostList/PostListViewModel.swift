//
//  PostListViewModel.swift
//  PostsApp
//
//  Created by MacBook Pro on 09/03/23.
//

import Foundation
import Combine

class PostListViewModel: ObservableObject {
    
    private var bindings = Set<AnyCancellable>()
    let postService: PostService = PostService()
    @Published var isLoading: Bool = false
    @Published var viewModelError: PostListViewModelError?
    private let loggedInUser = Keychain.value(forKey: AppConstant.Keychain.loggedInUser) ?? ""
    private(set) var selectedCategory : FilterType =  FilterType.allPosts
    private(set) var categories : [FilterType] =  FilterType.allCases
    private var favouriteList : [String?] =  []
    private var allPosts: [PostModel] = []
    @Published var posts: [PostModel] = []
    

    
    init() {
        fetchPostList()
    }
    
    func toggleFavouriteFor(_ post: PostModel) -> Bool? {
        if let row = self.posts.firstIndex(where: {$0.id == post.id}) {
            if post.isFavourite {
                if selectedCategory == .favouritePost {
                    posts.remove(at: row)
                    _ = postService.removeFromFavouriteList(postId: post.id, loggedInUser: loggedInUser)
                    return true
                }
                else {
                    posts[row].isFavourite = false
                    _ = postService.removeFromFavouriteList(postId: post.id, loggedInUser: loggedInUser)
                }
            }
            else {
                posts[row].isFavourite = true
                _ = postService.addToFavouriteList(postId: post.id, loggedInUser: loggedInUser)
            }
        }
        return nil
    }
    
    func toggleCategory(_ category: FilterType) {
        print(category)
        selectedCategory = category
        favouriteList = self.postService.getFavouriteList(loggedInUser: loggedInUser).map(\.postId)
        updateListViewBycategory(category: selectedCategory, postList: allPosts, favList: favouriteList)
    }
    
    func logOut() {
        Keychain.removeValue(forKey: AppConstant.Keychain.loggedInUser)
    }
    
    
    func updateListViewBycategory(category: FilterType, postList: [PostModel], favList: [String?]) {
        
        switch category {
        case .allPosts:
            var tempPosts = postList
            favList.forEach( { favId in
                if let indx = tempPosts.firstIndex(where: { $0.id.description == favId }) {
                    tempPosts[indx].isFavourite = true
                }
            })
            
            posts = tempPosts.sorted{$0.title < $1.title}
            
        case .favouritePost:
            var tempPosts: [PostModel] = []
            favList.forEach( { favId in
                if var post = postList.first(where: { $0.id.description == favId }) {
                    post.isFavourite = true
                    tempPosts.append(post)
                }
            })
            posts = tempPosts.sorted{$0.title < $1.title}
        }
    }
    
    func fetchPostList() {
        viewModelError = nil
        isLoading = true
        let completionHandler: (Subscribers.Completion<APIError>) -> Void = { [weak self] completion in
            guard let self = self else { return}
            self.isLoading = false
            switch completion {
            case .failure(let error):
                self.posts = []
                switch error {
                case .network(let msg), .other(let msg), .decoding(let msg):
                    self.viewModelError = .other(msg.localizedDescription)
                }
            case .finished:
                break
            }
        }
        
        let userId = Keychain.value(forKey: AppConstant.Keychain.loggedInUser) ?? ""
        guard !userId.isEmpty else {
            self.isLoading = false
            self.viewModelError = .userNotFound
            return
        }
        let request = postListRequest(userId: userId)
        postService.getPostList(request)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: completionHandler, receiveValue: { [weak self] postListResponse in
                guard let self = self else { return}
                self.allPosts = postListResponse
                self.favouriteList = self.postService.getFavouriteList(loggedInUser: self.loggedInUser).map(\.postId)
                self.updateListViewBycategory(category: self.selectedCategory, postList: self.allPosts, favList: self.favouriteList)
            })
            .store(in: &bindings)
    }
}

enum FilterType: String, CaseIterable {
    case allPosts = "All"
    case favouritePost = "Favourites"
}

