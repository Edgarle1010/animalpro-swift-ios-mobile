//
//  AnimalProApp.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 10/06/24.
//

import SwiftUI

@main
struct AnimalProApp: App {
    let persistenceController = CoreDataManager.shared

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(\.managedObjectContext, persistenceController.persistentContainer.viewContext)
        }
    }
}
