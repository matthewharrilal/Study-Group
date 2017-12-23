//
//  CoreDataFetchRequestAbstraction.swift
//  Study-Groups
//
//  Created by Matthew Harrilal on 12/22/17.
//  Copyright © 2017 Matthew Harrilal. All rights reserved.
//

import Foundation
import UIKit
import CoreData

func fetchRequest<T: NSManagedObject>(namOfEntity: String, type: T.Type) -> [T]? {
    let fetchRequest = NSFetchRequest<T>(entityName: namOfEntity)
    let result = try? CoreDataStack.singletonInstance.viewContext.fetch(fetchRequest)
    return result
}
