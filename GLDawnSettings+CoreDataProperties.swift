//
//  GLDawnSettings+CoreDataProperties.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 05.02.2021.
//  Copyright © 2021 nproject. All rights reserved.
//
//

import Foundation
import CoreData


extension GLDawnSettings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GLDawnSettings> {
        return NSFetchRequest<GLDawnSettings>(entityName: "GLDawnSettings")
    }

    @NSManaged public var brightness: Float
    @NSManaged public var minutesUntilDawn: Int16
    @NSManaged public var days: Set<GLDawnDay>?

}

// MARK: Generated accessors for days
extension GLDawnSettings {

    @objc(addDaysObject:)
    @NSManaged public func addToDays(_ value: GLDawnDay)

    @objc(removeDaysObject:)
    @NSManaged public func removeFromDays(_ value: GLDawnDay)

    @objc(addDays:)
    @NSManaged public func addToDays(_ values: NSSet)

    @objc(removeDays:)
    @NSManaged public func removeFromDays(_ values: NSSet)

}
