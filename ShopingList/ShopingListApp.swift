//
//  ShopingListApp.swift
//  ShopingList
//
//  Created by Marco Alonso Rodriguez on 17/07/23.
//

import SwiftUI

@main
struct ShopingListApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
