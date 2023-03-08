//
//  PostsAppApp.swift
//  PostsApp
//
//  Created by MacBook Pro on 08/03/23.
//

import SwiftUI

@main
struct PostsAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
