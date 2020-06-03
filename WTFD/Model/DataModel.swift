//
//  DataModel.swift
//  WTFD
//
//  Created by Garima Bothra on 04/06/20.
//  Copyright © 2020 Garima Bothra. All rights reserved.
//

import Foundation
import CoreData

class DataController {

    let persistentContainer: NSPersistentContainer
    var viewContext: NSManagedObjectContext{
        return persistentContainer.viewContext
    }

    //MARK: Initializing Persistent Container
    init(modelName: String){
        persistentContainer = NSPersistentContainer(name: modelName)
    }

    func configureContexts() {
        viewContext.automaticallyMergesChangesFromParent = true
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }

    //MARK: Loading the Persistent Store
    func load(completion: (() -> Void)? = nil){
        persistentContainer.loadPersistentStores(completionHandler: { storeDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            self.autoSaveViewContext(timeInterval: 3)
            self.configureContexts()
            completion?()
        })
    }
}

//MARK: Autosaving with Time Intervals
extension DataController {
    func autoSaveViewContext(timeInterval: TimeInterval = 30) {
        guard timeInterval > 0 else {
            print("Negative intrval not possible!")
            return
        }
        if viewContext.hasChanges {
            try? viewContext.save()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval) {
            self.autoSaveViewContext(timeInterval: timeInterval)
        }
    }
}
