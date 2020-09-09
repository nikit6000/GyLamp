//
//  NKCoreDataUtil+extension.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 05/10/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import Foundation
import RxSwift
import CoreData

extension NKCoreDataWorker: ReactiveCompatible {}

extension Reactive where Base: NKCoreDataWorker {
    
    func loadModels<T:NKModel>(of type: T.Type) -> Observable<T> {
        return Observable.create { observer in
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
            do {
                let managedObjectContext = NKCoreDataUtil.shared.managedObjectContext
                
                let results = try managedObjectContext.fetch(fetchRequest)
                
                for result in results as! [NSManagedObject] {
                    
                    if let objectModel = T.init(with: result) {
                        observer.onNext(objectModel)
                    }
                }
            } catch {
                observer.onError(error)
            }
            
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
    
    func save<T:NKModel>(model: T) -> Observable<Void> {
        return Observable.create { observer in
            
            if model.managedObject == nil {
            
                let managedObjectContext = NKCoreDataUtil.shared.managedObjectContext
                
                guard let entityDescription = NSEntityDescription.entity(forEntityName: T.entityName, in: managedObjectContext) else {
                    self.base.modelChangeSubject.onError(NKEntityError(entityName: T.entityName))
                    return Disposables.create()
                }
                
                model.managedObject = NSManagedObject(entity: entityDescription, insertInto: managedObjectContext)
            }
            
            if let error = NKCoreDataUtil.shared.saveContext() {
                observer.onError(error)
                self.base.modelChangeSubject.onError(error)
                return Disposables.create()
            }
            
            self.base.modelChangeSubject.onNext(model)
            
            observer.onNext(())
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
    
    func delete<T:NKModel>(model: T) -> Observable<Void> {
        
        return Observable.create { observer in
            
            guard let managedObject = model.managedObject else {
                let error = NKEntityError(entityName: T.entityName)
                observer.onError(error)
                self.base.modelChangeSubject.onError(error)
                return Disposables.create()
            }
            
            let managedObjectContext = NKCoreDataUtil.shared.managedObjectContext
            
            managedObjectContext.delete(managedObject)
            
            model.managedObject = nil
            
            if let error = NKCoreDataUtil.shared.saveContext() {
                self.base.modelChangeSubject.onError(error)
                observer.onError(error)
            } else {
                self.base.modelChangeSubject.onNext(model)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
        
    }
    
}
