//
//  CoreDataStack.swift
//  Study-Groups
//
//  Created by Matthew Harrilal on 12/13/17.
//  Copyright © 2017 Matthew Harrilal. All rights reserved.
//

import Foundation
import UIKit
import CoreData

public class CoreDataStack {
    static let singletonInstance = CoreDataStack()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Study_Groups")
        
        container.loadPersistentStores(completionHandler: { (completionHandler, error) in
            if let error = error as NSError? {
                fatalError("Unresolved Error \(error), \(error.localizedDescription)")
            }
        })
        return container
    }()
    
    lazy var privateContext: NSManagedObjectContext = {
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
        return privateContext
    }()
    
    func saveTo(context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                print("The changes that were made were saved to the context")
                try context.save()
            }
            catch {
                let error = error as NSError?
                fatalError("Could not save changes \(String(describing: error)), \(String(describing: error?.localizedDescription))")
            }
        }
    }
}

