//
//  NKCoreDataUtil.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 03/10/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import Foundation
import CoreData

class NKCoreDataUtil {
    
    public static var shared = NKCoreDataUtil()
    
    
    private lazy var applicationDocumentsDirectory: URL? = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        if urls.count == 0 {
            return nil
        }
        
        return urls[urls.count-1]
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel? = {
        guard let modelURL = Bundle.main.url(forResource: "CData", withExtension: "momd") else {
            return nil
        }
        
        return NSManagedObjectModel(contentsOf: modelURL)
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        
        guard let mObjectModel = self.managedObjectModel, let documentsDirectory = self.applicationDocumentsDirectory else {
            return nil
        }
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: mObjectModel)
        let url = documentsDirectory.appendingPathComponent("CData.sqlite")
        
        //var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
            return coordinator
        } catch {
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject
            dict[NSLocalizedFailureReasonErrorKey] = "There was an error creating or loading the application's saved data." as AnyObject
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            NKLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            return nil
        }
    }()
    
    public lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    public func saveContext() -> Error? {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
                return nil
            } catch {
                return error
            }
        }
        
        return nil
    }
}

