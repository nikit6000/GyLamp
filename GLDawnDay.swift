//
//  GLDawnDay+CoreDataClass.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 05.02.2021.
//  Copyright © 2021 nproject. All rights reserved.
//
//

import Foundation
import CoreData

@objc(GLDawnDay)
public class GLDawnDay: NSManagedObject {

    var rawValue: GLDawnDayRaw {
        return GLDawnDayRaw(day: UInt8(day), timeInSeconds: UInt(timeInSeconds), isEnabled: isEnabled)
    }
    
}
