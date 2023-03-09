//
//  PostTests.swift
//  PostsAppTests
//
//  Created by MacBook Pro on 09/03/23.
//

import XCTest
import Combine
@testable import PostsApp

final class PostTests: XCTestCase {

    private var viewModel: PostListViewModel!
    private var bindings: Set<AnyCancellable> = []
    private let dummyPostData: [PostModel] = [PostModel(id: 26, userId: 3, title: "est et quae odit qui non", body: "similique esse doloribus nihi fuga consequuntur", isFavourite: false),
                                      PostModel(id: 27, userId: 3, title: "quasi id et eos tenetur aut quo autem", body: "eum sed dolores consequatur suscipit", isFavourite: false),
                                      PostModel(id: 28, userId: 3, title: "delectus ullam et corporis nulla voluptas sequi", body: "non et nostrum eum", isFavourite: false),
                                      PostModel(id: 29, userId: 3, title: "iusto eius quod necessitatibus culpa ea", body: "odit magnam ut repudiandae odit maiores", isFavourite: false),
                                      PostModel(id: 30, userId: 3, title: "a quo magni similique perferendis", body: "alias dolor impedit  eveniet t quia", isFavourite: false)]
    
    override func setUp() {
        super.setUp()
        viewModel = PostListViewModel()
    }
    
    func testListTypeSelectionSuccess() {
        viewModel.toggleCategory(FilterType.favouritePost)
        XCTAssertEqual(viewModel.selectedCategory, FilterType.favouritePost)
    }
    
    func testListTypeSelectionFailure() {
        viewModel.toggleCategory(FilterType.allPosts)
        XCTAssertNotEqual(viewModel.selectedCategory, FilterType.favouritePost)
    }
    
    
    func testPostList() {
        
        let expectation = self.expectation(description: "Wait for testPostList to complete")
        let completionHandler: (Subscribers.Completion<APIError>) -> Void = {completion in
            switch completion {
            case .failure(let error):
                switch error {
                case .network(let msg):
                    XCTAssert(msg is URLError)
                    expectation.fulfill()
                case .decoding(let msg):
                    XCTAssert(msg is DecodingError)
                    expectation.fulfill()
                    break
                case .other(_):
                    expectation.fulfill()
                    break
                }
            case .finished:
                expectation.fulfill()
                break
            }
        }
        let userId = "1"
        let request = postListRequest(userId: userId)
        viewModel.postService.getPostList(request)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: completionHandler, receiveValue: { postListResponse in
                XCTAssertNotNil(postListResponse)
                if postListResponse.count > 0 {
                    XCTAssertNotEqual(postListResponse[0].id, nil)
                    XCTAssertEqual(postListResponse[0].userId.description, userId)
                }
            })
            .store(in: &bindings)
        wait(for: [expectation], timeout: 10)
    }
    
    
    func testLogoutSuccess() {
        let userId = "2"
        Keychain.set(userId, forKey: AppConstant.Keychain.loggedInUser)
        viewModel.logOut()
        let loggedInUserId = Keychain.value(forKey: AppConstant.Keychain.loggedInUser) ?? ""
        XCTAssertNotEqual(loggedInUserId, userId)
        XCTAssertEqual(loggedInUserId, "")
    }
    
    
    func testCategoryWiseFilteringAll() {
        let favList = ["27", "28"]
        XCTAssertEqual(dummyPostData.count, 5)
        viewModel.updateListViewBycategory(category: .allPosts, postList: dummyPostData, favList: favList)
        XCTAssertEqual(viewModel.posts.count, 5)
        let favouritesItemsCount = viewModel.posts.filter({$0.isFavourite == true}).count
        XCTAssertEqual(favouritesItemsCount, 2)
    }
    
    func testCategoryWiseFilteringFavourite() {
        let favList = ["27", "28"]
        XCTAssertEqual(dummyPostData.count, 5)
        viewModel.updateListViewBycategory(category: .favouritePost, postList: dummyPostData, favList: favList)
        XCTAssertEqual(viewModel.posts.count, 2)
        let favouritesItemsCount = viewModel.posts.filter({$0.isFavourite == true}).count
        XCTAssertEqual(favouritesItemsCount, 2)
    }
    
    func testAddPostToFavourite() {
        let post = dummyPostData[2]
        let userId = "7"        
        _ = viewModel.postService.addToFavouriteList(postId: post.id, loggedInUser: userId)
        let favouriteListAfterInsert = viewModel.postService.getFavouriteList(loggedInUser: userId).map(\.postId)
        XCTAssertTrue(favouriteListAfterInsert.contains(post.id.description))
    }
    func testRemovePostFromFavourite() {
        let post = dummyPostData[3]
        let userId = "8"
        _ = viewModel.postService.addToFavouriteList(postId: post.id, loggedInUser: userId)
        let favouriteListAfterInsert = viewModel.postService.getFavouriteList(loggedInUser: userId).map(\.postId)
        XCTAssertTrue(favouriteListAfterInsert.contains(post.id.description))
        _ = viewModel.postService.removeFromFavouriteList(postId: post.id, loggedInUser: userId)
        let favouriteListAfterRemove = viewModel.postService.getFavouriteList(loggedInUser: userId).map(\.postId)
        XCTAssertFalse(favouriteListAfterRemove.contains(post.id.description))
    }

    func testPostCommentList() {
        
        let expectation = self.expectation(description: "Wait for testPostCommentList to complete")
        let completionHandler: (Subscribers.Completion<APIError>) -> Void = {completion in
            switch completion {
            case .failure(let error):
                switch error {
                case .network(let msg):
                    XCTAssert(msg is URLError)
                    expectation.fulfill()
                case .decoding(let msg):
                    XCTAssert(msg is DecodingError)
                    expectation.fulfill()
                    break
                case .other(_):
                    expectation.fulfill()
                    break
                }
            case .finished:
                expectation.fulfill()
                break
            }
        }
        
        let postId = "1"
        let request = postCommentListRequest(postId: postId)
        viewModel.postService.getPostCommentList(request)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: completionHandler, receiveValue: {commentListResponse in
                XCTAssertNotNil(commentListResponse)
                if commentListResponse.count > 0 {
                    XCTAssertNotEqual(commentListResponse[0].postID, nil)
                    XCTAssertEqual(commentListResponse[0].postID.description, postId)
                }
            })
            .store(in: &bindings)
        wait(for: [expectation], timeout: 10)
    }
}
