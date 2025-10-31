//
//  Reflect_RoomApp.swift
//  Reflect Room
//
//  Created by Andrew Lawrence on 10/30/25.
//

import SwiftUI
import CoreData

@main
struct Reflect_RoomApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

