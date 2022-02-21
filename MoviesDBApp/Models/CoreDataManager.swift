//
//  CoreDataManager.swift
//  MoviesDBApp
//
//  Created by Mingyong Zhu on 2/20/22.
//

import Foundation


import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    private init() { }
    
    lazy private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Movie")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("something went wrog")
            }
        }
        return container
    }()
    
    var mainContext: NSManagedObjectContext { persistentContainer.viewContext }
    
    func saveContext() {
        if mainContext.hasChanges {
            do {
                try mainContext.save()
                print("Save data to Core Data successfully!")
            } catch {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
    
}
