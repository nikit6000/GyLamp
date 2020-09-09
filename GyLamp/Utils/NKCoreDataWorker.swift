//
//  NKCoreDataWorker.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 05/10/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import Foundation
import CoreData
import RxSwift

class NKCoreDataWorker {
    
    public static let shared = NKCoreDataWorker()
    
    public var modelChangeSubject = PublishSubject<NKModel>()
    
    public func readModels<T:NKSerializeable>() -> [T] {
        
        var objectModels = [T]()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        do {
            let managedObjectContext = NKCoreDataUtil.shared.managedObjectContext
            
            let results = try managedObjectContext.fetch(fetchRequest)
            
            for result in results as! [NSManagedObject] {
                
                if let objectModel = T.make(from: result) {
                    objectModels.append(objectModel)
                }
            }
        } catch {
            NKLogE(error)
        }
        
        return objectModels
    }
    
    public func save<T:NKModel>(model: T) -> Error?{
        
        let managedObjectContext = NKCoreDataUtil.shared.managedObjectContext
        
        guard let entityDescription = NSEntityDescription.entity(forEntityName: T.entityName, in: managedObjectContext) else {
            return nil
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        
        fetchRequest.predicate = model.searchPredicate
        
        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            
            if let managedObject = results.first as? NSManagedObject {
                model.managedObject = managedObject
                return NKCoreDataUtil.shared.saveContext()
            }
            
        } catch {
            NKLogE(error)
        }

        
        let managedObject = NSManagedObject(entity: entityDescription, insertInto: managedObjectContext)
        
        model.managedObject = managedObject
        
        return NKCoreDataUtil.shared.saveContext()
        
    }
    
    public func deleteAllData(_ entity:String) {
        let managedObjectContext = NKCoreDataUtil.shared.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                managedObjectContext.delete(objectData)
            }
            //NKCoreDataUtil.shared.saveContext()
        } catch let error {
            NKLogE("Detele all data in \(entity) error :", error)
        }
    }
    
}
