//
//  GLDawnDay+CoreDataProperties.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 05.02.2021.
//  Copyright © 2021 nproject. All rights reserved.
//
//

import Foundation
import CoreData


extension GLDawnDay {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GLDawnDay> {
        return NSFetchRequest<GLDawnDay>(entityName: "GLDawnDay")
    }

    @NSManaged public var day: Int16
    @NSManaged public var timeInSeconds: Int32
    @NSManaged public var isEnabled: Bool

}
