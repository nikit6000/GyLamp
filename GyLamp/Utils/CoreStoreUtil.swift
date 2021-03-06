//
//  CoreStoreUtil.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 05.02.2021.
//  Copyright © 2021 nproject. All rights reserved.
//

import Foundation
import CoreStore

typealias CoreStoreUtilProgressHandler = (_ progress: Progress?) -> ()
typealias CoreStoreUtilErrorHandler = (_ error: Error) -> ()
typealias CoreStoreUtilSuccessHandler = () -> ()
typealias CoreStoreUtilFetchHandler<T: DynamicObject> = (_ objects: [T]) -> ()
typealias CoreStoreUtilFetchOneHandler<T: DynamicObject> = (_ object: T) -> ()

enum CoreStoreUtilError: Error {
    case storageNotInited
    case fetchResultIsNil
}

class CoreStoreUtil {
    
    public static let shared = CoreStoreUtil()
    
    private(set) var isStorageInited: Bool
    private(set) var storageLoadProgress: Progress?
    private(set) var dataStack: DataStack
    private var localStorage: LocalStorage?
    
    
    init() {
        isStorageInited = false
        dataStack = DataStack(xcodeModelName: "GyLamp", bundle: Bundle.main, migrationChain: ["CData", "CDataV1.4"])
    }
    
    public func initStorage(onProgress: CoreStoreUtilProgressHandler? = nil, onSuccess: CoreStoreUtilSuccessHandler? = nil, onError: CoreStoreUtilErrorHandler? = nil) {
        guard isStorageInited == false else {
            return
        }
        
        storageLoadProgress = dataStack.addStorage(SQLiteStore(fileName: "GyLamp.sqlite"), completion: { [weak self] result in
            
            switch (result) {
            case .success(let store):
                self?.isStorageInited = true
                self?.localStorage = store
                onSuccess?()
            case .failure(let error):
                self?.isStorageInited = false
                onError?(error)
            }
            
        })
        
        if storageLoadProgress != nil {
            storageLoadProgress!.setProgressHandler(onProgress)
        }
        
    }
    
    public func fetch<T: DynamicObject>(onSuccess: CoreStoreUtilFetchHandler<T>? = nil, onError: CoreStoreUtilErrorHandler? = nil) {
        
        guard isStorageInited else {
            onError?(CoreStoreUtilError.storageNotInited)
            return
        }
        
        dataStack.perform(asynchronous: { transaction -> [T] in
            try transaction.fetchAll(From<T>())
        }, completion: { result in
            
            switch (result) {
            case .success(let entities):
                onSuccess?(entities)
            case .failure(let error):
                onError?(error)
            }
            
        })
    }
    
    public func createOrFetch<T: DynamicObject>(onSuccess: CoreStoreUtilFetchOneHandler<T>? = nil, onError: CoreStoreUtilErrorHandler? = nil) {
        
        guard isStorageInited else {
            onError?(CoreStoreUtilError.storageNotInited)
            return
        }
        
        dataStack.perform(asynchronous: { transaction -> T in
            let objects = try transaction.fetchAll(From<T>())
            if objects.count > 0 {
                return objects[0]
            }
            
            return transaction.create(Into<T>())
        }, completion: { result in
            switch (result) {
            case .success(let object):
                onSuccess?(object)
            case .failure(let error):
                onError?(error)
            }
        })
        
    }
    
    public func create<T: DynamicObject>(onSuccess: CoreStoreUtilFetchOneHandler<T>? = nil, onError: CoreStoreUtilErrorHandler? = nil) {
        
        guard isStorageInited else {
            onError?(CoreStoreUtilError.storageNotInited)
            return
        }
      
        dataStack.perform(asynchronous: { transaction -> T in
            transaction.create(Into<T>())
        }, completion: { result in
            switch (result) {
            case .success(let object):
                onSuccess?(object)
            case .failure(let error):
                onError?(error)
            }
        })
        
    }
    
    public func edit<T: NSManagedObject, U: AllowedObjectiveCKeyPathValue>(field keyPath: KeyPath<T, U>, of object: T, with newValue: Any, onSuccess: CoreStoreUtilFetchOneHandler<T>? = nil, onError: CoreStoreUtilErrorHandler? = nil) {
        let keyPathStr = KeyPathString(keyPath: keyPath)
        self.edit(field: keyPathStr, of: object, with: newValue, onSuccess: onSuccess, onError: onError)
    }
    
    public func edit<T: NSManagedObject>(field keyPathStr: String, of object: T, with newValue: Any, onSuccess: CoreStoreUtilFetchOneHandler<T>? = nil, onError: CoreStoreUtilErrorHandler? = nil) {
        
        guard isStorageInited else {
            onError?(CoreStoreUtilError.storageNotInited)
            return
        }
    
        dataStack.perform(asynchronous: { transaction -> T in
            
            let editableObject = transaction.edit(object)
            
            editableObject?.setValue(newValue, forKey: keyPathStr)
            
            NKLog("CoreDataUtil.edit", "Setting new value for", "\(T.self).\(keyPathStr)", "=", newValue)
            
            guard let model = try transaction.fetchOne(From<T>()) else {
                throw CoreStoreUtilError.fetchResultIsNil
            }
            
            return model
        }, completion: { result in
            switch (result) {
            case .success(let model):
                onSuccess?(model)
            case .failure(let error):
                onError?(error)
            }
            
        })
        
    }
    
    public func delete<T: ObjectRepresentation>(objects: [T], onSuccess: CoreStoreUtilSuccessHandler? = nil, onError: CoreStoreUtilErrorHandler? = nil) {
        
        guard isStorageInited else {
            onError?(CoreStoreUtilError.storageNotInited)
            return
        }
        
        dataStack.perform(asynchronous: { transaction in
            transaction.delete(objects)
        }, completion: { result in
            switch (result) {
            case .success:
                onSuccess?()
            case .failure(let error):
                onError?(error)
            }
        })
        
    }
    
    
}
