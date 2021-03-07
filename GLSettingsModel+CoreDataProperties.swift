//
//  GLSettingsModel+CoreDataProperties.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 05.02.2021.
//  Copyright © 2021 nproject. All rights reserved.
//
//

import Foundation
import CoreData


extension GLSettingsModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GLSettingsModel> {
        return NSFetchRequest<GLSettingsModel>(entityName: "GLSettingsModel")
    }

    @NSManaged public var timeZone: Int16
    @NSManaged public var cityId: UInt32
    @NSManaged public var brightness: Float
    @NSManaged public var adcMode: GLSettingsADCMode
    @NSManaged public var minBrightness: Float
    @NSManaged public var maxBrigtness: Float
    @NSManaged public var modeChange: GLSettingsPresetChangeMode
    @NSManaged public var random: Bool
    @NSManaged public var changePeriod: GLSettingsChangePeriod
    @NSManaged public var lampType: GLSettingsLampType
    @NSManaged public var maxCurrent: UInt16
    @NSManaged public var mqttState: Bool
    @NSManaged public var mqttId: String
    @NSManaged public var mqttHost: String
    @NSManaged public var mqttPort: UInt16
    @NSManaged public var mqttLogin: String
    @NSManaged public var mqttPass: String
    @NSManaged public var workTimeSince: UInt16
    @NSManaged public var workTimeUntil: UInt16
    @NSManaged public var length: UInt16
    @NSManaged public var width: UInt16
    @NSManaged public var matrixOrientation: GLSettingsOrientation

}
