//
//  Persistence.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 10/06/24.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    public var context : NSManagedObjectContext!
    
    let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "AnimalProDB")
        setupDatabase()
        context = persistentContainer.viewContext
    }
    
    private func setupDatabase() {
        persistentContainer.loadPersistentStores { (desc, error) in
            if let error = error {
                print("Error loading store \(desc) — \(error)")
                return
            }
            print("Database ready!")
        }
    }
}
