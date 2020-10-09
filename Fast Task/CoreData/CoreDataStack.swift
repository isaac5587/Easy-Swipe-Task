//
//  CoreDataStack.swift
//  Fast Task
//
//  Created by Trill Isaac on 7/8/19.
//  Copyright © 2019 Isaac Ansumana. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    var container: NSPersistentContainer{
        let container = NSPersistentContainer(name: "Todos")
        container.loadPersistentStores { (description, error) in
            guard error == nil else {
                print("Error: \(error!)")
                return
            }
            
        }
        return container
    }
    var managedContext: NSManagedObjectContext {
        return container.viewContext
    }
}
