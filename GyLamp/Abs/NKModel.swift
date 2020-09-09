//
//  NKModel.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 05/10/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import Foundation
import CoreData
import IGListKit

class NKModel: NSObject, ListDiffable {
    
    var managedObject: NSManagedObject?
    
    class var entityName: String {
        fatalError("Error: this var must be overriden")
    }
    
    var searchPredicate: NSPredicate {
        fatalError("Error: this var must be overriden")
    }
    
    override init(){
        managedObject = nil
        super.init()
    }
    
    required init?(with managedObject: NSManagedObject) {
        self.managedObject = managedObject
        super.init()
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return self
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return self.isEqual(object)
    }
    
}

