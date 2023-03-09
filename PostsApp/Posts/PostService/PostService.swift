//
//  PostService.swift
//  PostsApp
//
//  Created by MacBook Pro on 09/03/23.
//

import Foundation
import Combine
import CoreData

typealias getPostListPublisher = AnyPublisher<[PostModel], APIError>

protocol PostServiceProtocol {
    var apiClient: APIService { get }
    func getPostList(_ request: postListRequest) -> getPostListPublisher
}

protocol PostPersistencServiceProtocol {
    func getFavouriteList(loggedInUser: String) -> [Favourite]
    func addToFavouriteList(postId: Int, loggedInUser: String) -> Bool
    func removeFromFavouriteList(postId: Int, loggedInUser: String) -> Bool
}


struct PostService: PostServiceProtocol, PostPersistencServiceProtocol {
    var apiClient: APIService = APIService()
    let persistentContainer = PersistenceController.shared.container
    
    
    func getPostList(_ request: postListRequest) -> getPostListPublisher {
        return apiClient.publisher(for: request)
    }
}

extension PostService {
    
    func getFavouriteList(loggedInUser: String) -> [Favourite] {
        do {
            let request : NSFetchRequest<Favourite> = Favourite.fetchRequest()
            request.predicate = NSPredicate(format: "userId == %@", loggedInUser)
            let records = try persistentContainer.viewContext.fetch(request)
            return records
        } catch {
            print("Error saving context \(error)")
            return []
        }
    }
    
    
    func addToFavouriteList(postId: Int, loggedInUser: String) -> Bool {
        do {
            let request : NSFetchRequest<Favourite> = Favourite.fetchRequest()
            request.predicate = NSPredicate(format: "userId == %@ AND postId == %@", loggedInUser, postId.description)
            let numberOfRecords = try persistentContainer.viewContext.count(for: request)
            if numberOfRecords == 0 {
                let newFav = Favourite(context: persistentContainer.viewContext)
                newFav.userId = loggedInUser.description
                newFav.postId = postId.description
                try persistentContainer.viewContext.save()
                return true
            }
            else {
                return true
            }
        } catch {
            print("Error saving context \(error)")
            return false
        }
    }
    
    func removeFromFavouriteList(postId: Int, loggedInUser: String) -> Bool {
        do {
            let request : NSFetchRequest<Favourite> = Favourite.fetchRequest()
            request.predicate = NSPredicate(format: "userId == %@ AND postId == %@", loggedInUser, postId.description)
            let records = try persistentContainer.viewContext.fetch(request)
            if records.count > 0 {
                persistentContainer.viewContext.delete(records.first!)
                try persistentContainer.viewContext.save()
                return true
            }
            else {
                return true
            }
        } catch {
            print("Error saving context \(error)")
            return false
        }
    }
}


