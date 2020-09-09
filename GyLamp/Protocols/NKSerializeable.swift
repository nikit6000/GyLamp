//
//  NKManagedObject.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 05/10/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import Foundation
import CoreData

protocol NKSerializeable {
    
    static var entityName: String { get }
    
    var searchPredicate: NSPredicate { get }
    
    func isEqual(to managedObject: NSManagedObject) -> Bool
    func serialize(with managedObject: NSManagedObject)
    static func make(from managedObject: NSManagedObject) -> Self?
    
}
