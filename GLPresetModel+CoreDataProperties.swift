//
//  GLPresetModel+CoreDataProperties.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 05.02.2021.
//  Copyright © 2021 nproject. All rights reserved.
//
//

import Foundation
import CoreData


extension GLPresetModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GLPresetModel> {
        return NSFetchRequest<GLPresetModel>(entityName: "GLPresetModel")
    }

    @NSManaged public var centered: Bool
    @NSManaged public var color: Float
    @NSManaged public var customBrightness: Float
    @NSManaged public var effectType: GLPresetEffectType
    @NSManaged public var iconId: Int16
    @NSManaged public var id: Int32
    @NSManaged public var lowBrightnessEnabled: Bool
    @NSManaged public var minSignal: Float
    @NSManaged public var name: String?
    @NSManaged public var palette: GLPresetPalette
    @NSManaged public var random: Bool
    @NSManaged public var scale: Float
    @NSManaged public var soundReaction: GLPresetSoundReaction
    @NSManaged public var soundType: GLPresetSoundType
    @NSManaged public var speed: Float
    @NSManaged public var maxSignal: Float

}
