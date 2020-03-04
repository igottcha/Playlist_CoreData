//
//  CoreDataStack.swift
//  PlaylistCoredata
//
//  Created by Chris Gottfredson on 3/4/20.
//  Copyright © 2020 Trevor Walker. All rights reserved.
//

import Foundation
import CoreData

enum CoreDataStack {
    
   static let container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PlaylistCoredata")
        
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load persisttent stores \(error)")
            }
        }
        return container
    }()
    
   static var context: NSManagedObjectContext {
        return container.viewContext
    }
}
